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
  job = new CronJob(
    cronTime: '00 45 16 * * 1-5'
    onTick: ->
      robot.send {room: config.targetChannel}, "本当にサイト見てるの？サイトで買い物してるの？\nこんなシステムで恥ずかしくないの？感覚を疑うぞ。\n自分がお客様だったらどう思うか、真剣に他人事ではなく、自分事で考えろ！"
    start: true
  )

  robot.hear /定時/i, (res) ->
    endDate = new Date()
    endDate.setHours(config.endHour, config.endMinute, config.endSecond)

    remainigTime = new Date(endDate.getTime() - Date.now())

    res.emote printDate(remainigTime)

printDate = (milliSec) ->
  date = new Date(milliSec)
  hour = date.getUTCHours()
  minute = date.getUTCMinutes()
  second = date.getUTCSeconds()
  isExactly = (hour + minute + second) == 0

  "定時まであと#{if hour then "#{hour}時間" else ""}#{if minute then "#{minute}分" else ""}#{if second then "#{second}秒" else ""}です#{if isExactly then ":tada:" else ""}"
