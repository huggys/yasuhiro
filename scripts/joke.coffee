# Description:
#   Joke commands.
#
# Commands:
#   ぬるぽ - You reply with, "ｶﾞｯ" When you post a "ぬるぽ" word.
#   芝刈り - 草が生えすぎ
#
# Notes:
#   ネタ/ジョーク系のbot全般

module.exports = (robot) ->
  robot.hear /ぬるぽ|ヌルポ|ﾇﾙﾎﾟ/, (msg) ->
    msg.send """
```
   Λ＿Λ     ＼＼
（  ・∀・）  | | ｶﾞｯ
 と     ）  | |
  Ｙ /ノ     人
   / ）    < >   _Λ  ∩
＿/し'   ／／  Ｖ｀Д´）/
（＿フ彡             / ←>> @#{msg.message.user.name}
```
  """

  robot.hear /(w|ｗ){4,}/i, (msg) ->
    msg.send """
```
　　　∧,,∧
　 (；`・ω・）　　,
　 /　ｏ={=}ｏ , ', ´
､､しー-Ｊミ(.@)ｗｗｗｗｗｗｗｗｗｗｗ
```
    """
