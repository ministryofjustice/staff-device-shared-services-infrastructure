# Example in case we refactor for separate pre-production secrets
# Why? both preproduction and production currently use the same values
# resource "aws_secretsmanager_secret" "pre_production_SECRET" {
#   name        = "${local.supported-application}/pre_production/SECRET"
#   description = "Pre-Production SECRET"
#   tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_pre_production, { env_var = "SECRET" }, { tf_var = "secret" })
#   lifecycle { prevent_destroy = true }
# }
#
# resource "aws_secretsmanager_secret_version" "pre_production_SECRET" {
#   secret_id     = aws_secretsmanager_secret.pre_production_SECRET.id
#   secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
#   lifecycle { ignore_changes = [secret_string] }
# }
