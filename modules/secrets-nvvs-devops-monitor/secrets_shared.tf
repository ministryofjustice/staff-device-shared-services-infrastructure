resource "aws_secretsmanager_secret" "shared_githubworkflow_role_arn" {
  name        = "${local.supported-application}/shared/shared_githubworkflow_role_arn"
  description = "Role ARN for GitHub Actions"
  tags        = local.tag_secrets_nvvs_devops_monitor_shared
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "shared_githubworkflow_role_arn" {
  secret_id     = aws_secretsmanager_secret.shared_githubworkflow_role_arn.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}
