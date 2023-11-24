#resource "aws_secretsmanager_secret" "example" {
#  name        = "shared/shared_githubworkflow_role_arn"
#  description = "Role ARN for GitHub Actions"
#  tags        = local.tag_minus_name
#  lifecycle { prevent_destroy = true }
#}
#
#resource "aws_secretsmanager_secret_version" "example" {
#  secret_id     = aws_secretsmanager_secret.example.id
#  secret_string = "secret_goes_here"
##  lifecycle { ignore_changes = [secret_string] }
#}