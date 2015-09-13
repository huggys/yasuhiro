# Description:
#   定時を知らせたり、定時までの残り時間を教える。
#
# Notes:
#   ぴったんこカン・カンならささやかなお祝い

CronJob = require('cron').CronJob
config =
  endHour: 17
  endMinute: 45
  endSecond: 0
  targetChannel: 'ganbalow'

module.exports = (robot) ->
  new CronJob(
    cronTime: '00 45 17 * * 1-5'
    onTick: ->
      sendNonsense(robot)
    start: true
  )

  new CronJob(
    cronTime: '00 00 */2 * * 1-5'
    onTick: ->
      sendNonsense(robot)
    start: true
  )

  robot.hear /定時/i, (res) ->
    endDate = new Date()
    endDate.setHours(config.endHour, config.endMinute, config.endSecond)

    remainigTime = new Date(endDate.getTime() - Date.now())

    res.emote printDate(remainigTime)

sendNonsense = (robot) ->
  robot.http('http://yasuhiro-api.herokuapp.com/nonsenses')
    .get() (err, res, body) ->
      nonsenses = JSON.parse(body).data
      index = Math.floor(Math.random() * nonsenses.length)
      nonsense = nonsenses[index]

      robot.send {room: config.targetChannel}, nonsense.body

printDate = (milliSec) ->
  date = new Date(milliSec)
  hour = date.getUTCHours()
  minute = date.getUTCMinutes()
  second = date.getUTCSeconds()
  isExactly = (hour + minute + second) == 0

  "定時まであと#{if hour then "#{hour}時間" else ""}#{if minute then "#{minute}分" else ""}#{if second then "#{second}秒" else ""}です#{if isExactly then ":tada:" else ""}"
