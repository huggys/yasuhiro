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
TRELLO_KEY = process.env.HUBOT_TRELLO_KEY
TRELLO_TOKEN = process.env.HUBOT_TRELLO_TOKEN
TRELLO_BOARD = process.env.HUBOT_TRELLO_BOARD
BACKLOG_URL = process.env.HUBOT_BACKLOG_URL
BACKLOG_KEY = process.env.HUBOT_BACKLOG_KEY

module.exports = (robot) ->
  robot.hear(/todo add (.*)/i, (res) ->
    taskName = res.match[1]
    backlog = taskName.match(/OMNI_SYSTEM_(UNYOU-\d+)/)
    # Backlogではない場合
    if !backlog
      res.emote("Backlogにないよ")
      return

    title = backlog[0]
    abbr = backlog[1]
    summary = ''

    getBacklog(robot, title).then((data) ->
      summary = data.summary
      getList()
    ).then((list) ->
      createCards(list.id, abbr, summary, "#{BACKLOG_URL}/view/#{title}")
    ).then((data) ->
      res.emote("#{abbr}の追加が完了した")
    ).catch((error) ->
      robot.logger.info(error)
      res.emote("ごめん、#{abbr}の追加に失敗した")
    )
  )

  robot.hear(/todo list/, (res) ->
    showCards().then((cards) ->
      res.emote('残タスクな:shit:')
      for card in cards
        res.emote('- ' + card.name)
    ).catch((error) ->
      robot.logger.info(error)
      res.emote('すまん、一覧取得できなかった:pray:')
    )
  )

getBacklog = (robot, issueKey) ->
  new Promise((resolve, reject) ->
    request = robot.http("#{BACKLOG_URL}/api/v2/issues/#{issueKey}?apiKey=#{BACKLOG_KEY}")
      .get()

    request((err, res, body) ->
      if err
        return reject(new Error(err))

      resolve(JSON.parse(body))
    )
  )

getInstance = ->
  Trello = require('node-trello')
  new Trello(TRELLO_KEY, TRELLO_TOKEN)

getList = ->
  new Promise((resolve, reject) ->
    trello = getInstance()
    trello.get('/1/boards/' + TRELLO_BOARD + '/lists', (err, lists) ->
      if err
        return reject(new Error(err))

      target = lists.filter((list) ->
        list.name.match(/to do/i)
      )

      resolve(target[0])
    )
  )

createCard = (listId, title, desc) ->
  new Promise((resolve, reject) ->
    trello = getInstance()
    options =
      name: title
      desc: desc || ''
      idList: listId

    trello.post('/1/cards', options, (err, data) ->
      if err
        return reject(new Error(err))

      resolve(data)
    )
  )

createCards = (listId, abbr, summary, url) ->
  types = [
    '仕様調査・作成'
    '7NM調整・合意'
    '設計書作成'
    '実装'
    '単体テスト項目作成'
    '単体テスト'
    'リリース準備'
    'チーム内試験'
    'サイト内試験'
  ]
  desc = summary.substr(0, 15) + '…'

  promises = for type in types
    title = "#{abbr}[#{type}]#{desc}"
    createCard(listId, title, url)

  Promise.all(promises)

showCards = ->
  new Promise((resolve, reject) ->
    trello = getInstance()
    trello.get('/1/boards/' + TRELLO_BOARD + '/cards', {filter: 'open'}, (err, data) ->
      if err
        return reject(new Error(err))

      resolve(data)
    )
  )
