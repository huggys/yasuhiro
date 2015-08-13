# Description:
#   定時を知らせたり、定時までの残り時間を教える。
#
# Notes:
#   ぴったんこカン・カンならささやかなお祝い

END_HOUR = 17
END_MINUTES = 45
END_SECOND = 0
module.exports = (robot) ->
  robot.hear /定時/i, (res) ->
    endDate = new Date()
    endDate.setHours(END_HOUR, END_MINUTES, END_SECOND)

    remainigTime = new Date(endDate.getTime() - Date.now())

    res.emote printDate(remainigTime)

printDate = (milliSec) ->
  date = new Date(milliSec)
  hour = date.getUTCHours()
  minute = date.getUTCMinutes()
  second = date.getUTCSeconds()
  isExactly = (hour + minute + second) == 0

  "定時まであと#{if hour then "#{hour}時間" else ""}#{if minute then "#{minute}分" else ""}#{if second then "#{second}秒" else ""}です#{if isExactly then ":tada:" else ""}"
