# Description:
#   Pull Request時に自動的にレビュアーをassignする
#
# Commands:
#   None
#
# Notes:
#   すでにassign済みの場合は何もしない。
#
crypto = require('crypto')
config =
  targetChannel: 'ganbalow'

module.exports = (robot) ->
  robot.router.post('/webhooks/github', (req, res) ->
    signature = req.header('X-Hub-Signature')
    hashAlgorithm = signature.split('=')[0]
    body = req.body

    if signature != generateSignature(hashAlgorithm, process.env.GITHUB_WEBHOOK_SECRET, body)
      robot.logger.error("Unauthorized!")
      return res.status(401).send('Unauthorized')

    robot.logger.info("Pass signature!")

    # openかreopen以外は無視
    if body.action not in ['opened', 'reopened']
      return res.status(200).send('OK')

    pr = body.pull_request

    # Assign済みの場合は無視
    return res.status(200).send('OK') if pr.assignee

    github = require('githubot')(robot)
    repository = body.repository
    repo = repository.name
    owner = repository.owner.login

    github.get("/repos/#{owner}/#{repo}/collaborators", (collaborators) ->
      targets = collaborators.filter (collaborator) ->
        userName = pr.user.login
        # プルリクした本人とbotは除外
        collaborator.login != userName && !/bot$/.test(userName)
      index = Math.floor(Math.random() * targets.length)

      assignee = targets[index].login

      # Asigneeを設定
      url = "/repos/#{owner}/#{repo}/issues/#{pr.number}"
      data = {assignee: assignee}

      github.patch(url, data, (issue, error) ->
        robot.logger.info("issue: #{JSON.stringify(issue)}")
        robot.send({room: config.targetChannel}, "#{issue.assignee.login} has been assigned for [\##{issue.number} #{issue.title}](#{issue.html_url}) as a reviewer")

        robot.logger.info("Assign complete!")
      )

      # GitHubにComment
      url += "/comments"
      data = {body: "@#{assignee} please review this."}

      github.post(url, data, (comment, error) ->
        robot.logger.info("comment: #{JSON.stringify(comment)}")

        robot.logger.info("Comment complete!")
      )

      res.send('OK')
    )
  )

generateSignature = (hashAlgorithm, key, data) ->
  hmac = crypto.createHmac(hashAlgorithm, key)
  hmac.update(JSON.stringify(data), 'utf-8')
  hashedBody = hmac.digest('hex')
  [hashAlgorithm, hashedBody].join('=')
