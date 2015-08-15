# Description:
#   「ね」や「な」などの終助詞に反応する。
#
# Examples:
#   な - Yasu replies な
#   ね - Yasu replies ね
#
# Notes:
#   none

module.exports = (robot) ->
  robot.hear /(ね|な)[ぁあ?？]?([!！wｗ]*)\s?(yasu(hiro)?|やす(ひろ)?|康弘)?[!?！？]*$/i, (res) ->
    replyWord = res.match[1]
    exclamation = res.match[2]

    res.send "#{replyWord}#{exclamation}"
