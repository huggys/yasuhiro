# Description
#  SlackからTrelloの操作を行う。
#
# Dependencies:
#  "node-trello": "^1.1.2"
#
# Configuration:
#  HUBOT_TRELLO_KEY - Trello application key
#  HUBOT_TRELLO_TOKEN - Trello API token
#  HUBOT_TRELLO_BOARD - The board ID that you'd like to create cards for
#  HUBOT_BACKLOG_URL - Backlog URL
#  HUBOT_BACKLOG_KEY - Backlog API key
#
# Commands:
#  todo add <Card name>
#  todo list
#
# Notes:
#  None
Trello = require('node-trello')
t = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)

module.exports = (robot) ->
  robot.hear /todo add (.*)/i, (res) ->
    title = res.match[1]

    isBacklog = title.match(/OMNI_SYSTEM_UNYOU-\d+/)
    # Backlogではない場合
    if !isBacklog
      createCard(res, title)
      return

    title = isBacklog[0]
    # Backlog課題を取得
    robot.http("#{process.env.HUBOT_BACKLOG_URL}/api/v2/issues/#{title}?apiKey=#{process.env.HUBOT_BACKLOG_KEY}")
      .get() (err, res_, body) ->
        data = JSON.parse(body)
        desc = {desc: "#{process.env.HUBOT_BACKLOG_URL}/view/#{title}"}

        createCard(res, title + '\n' + data.summary, desc)

  robot.hear /todo list/, (res) ->
    showCards(res)

createCard = (res, title, desc) ->
  t.get('/1/boards/' + process.env.HUBOT_TRELLO_BOARD + '/lists', (err, lists) ->
    firstList = lists[0]
    options = {name: title, idList: firstList.id}

    # descが存在する場合はoptionsにmerge
    if desc
      options = Object.assign(options, desc)

    t.post('/1/cards', options, (err, data) ->
      if err
        res.emote('追加に失敗したよ')
        return

      res.emote("[#{title}] を #{firstList.name} に追加したよ")
    )
  )

showCards = (res) ->
  t.get '/1/boards/' + process.env.HUBOT_TRELLO_BOARD + '/cards', {filter: 'open'}, (err, data) ->
    res.emote ':shit:'
    res.emote '- ' + card.name for card in data
