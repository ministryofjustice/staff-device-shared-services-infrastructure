resource "aws_secretsmanager_secret" "production_assume_role_arn" {
  name        = "production/assume_role_arn"
  description = "Role ARN for Production Assume Role"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_production, { tf_var = "assume_role" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_assume_role_arn" {
  secret_id     = aws_secretsmanager_secret.production_assume_role_arn.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}