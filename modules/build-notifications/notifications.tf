resource "aws_codestarnotifications_notification_rule" "this" {
  detail_type    = "BASIC"
  event_type_ids = ["codecommit-repository-comments-on-commits"]

  name     = "example-code-repo-commits"
  resource = "arn:aws:chatbot::683290208331:chat-configuration/slack-channel/moj-pttp-builds"

  target {
    address = aws_sns_topic.notif.arn
  }
}