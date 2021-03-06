# Description:
#   Joke commands.
#
# Commands:
#   ぬるぽ - You reply with, "ｶﾞｯ" When you post a "ぬるぽ" word.
#   芝刈り - 草が生えすぎ
#   お茶   - 疲れたときにお茶を差し出す
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

  robot.hear /[お]茶|疲れ(た|る)/, (msg) ->
    msg.send """
```
 ∧＿∧
( ´･ω･) お茶が入りましたよ・・・。>> @#{msg.message.user.name}
( つ旦O
と＿)＿) 旦
```
    """
