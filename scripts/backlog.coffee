# Description:
#   Backlog関係
#
# Commands:
#   None
#
# Notes:
#   Backlogを定期的に検索し通知
BACKLOG_URL = process.env.HUBOT_BACKLOG_URL
BACKLOG_KEY = process.env.HUBOT_BACKLOG_KEY
CronJob = require('cron').CronJob

url = "#{BACKLOG_URL}/api/v2/issues?statusId[]=1&statusId[]=2&statusId[]=3&assigneeId[]=97780&apiKey=#{BACKLOG_KEY}"
channel = 'omni-common'

module.exports = (robot) ->
  new CronJob(
    cronTime: '0 0 9,11,15 * * 1-5'
    onTick: ->
      getBacklog(robot).then((issues) ->
        if !issues.length
          robot.send {room: channel}, 'Backlogにはなにも起票されていませんでした'
          return

        message = "*#{issues.length}件のBacklogがあります。*"
        for issue in issues
          message += "\n#{issue.summary} #{getBacklogURI(issue.issueKey)}"

        robot.messageRoom(channel, message)
      ).catch((error) ->
        robot.logger.info(error)
        robot.send {room: channel}, '謎のエラーが発生した'
      )
    start: true
  )

getBacklog = (robot) ->
  new Promise((resolve, reject) ->
    request = robot.http(url)
      .get()

    request((err, res, body) ->
      if err
        return reject(new Error(err))

      resolve(JSON.parse(body))
    )
  )

getBacklogURI = (issueKey) ->
  "#{BACKLOG_URL}/view/#{issueKey}"
