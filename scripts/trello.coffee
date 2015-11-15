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
    createCard(res, title)

  robot.hear /todo list/, (res) ->
    showCards(res)

createCard = (res, title) ->
  t.get('/1/boards/' + process.env.HUBOT_TRELLO_BOARD + '/lists', (err, lists) ->
    firstList = lists[0]
    t.post('/1/cards', {name: title, idList: firstList.id}, (err, data) ->
      if err
        res.emote('追加に失敗したよ')
        return

      res.emote("[#title] を #firstList.name に追加したよ")
    )
  )

showCards = (res) ->
  t.get '/1/boards/' + process.env.HUBOT_TRELLO_BOARD + '/cards', {filter: 'open'}, (err, data) ->
    res.emote ':shit:'
    res.emote '- ' + card.name for card in data
