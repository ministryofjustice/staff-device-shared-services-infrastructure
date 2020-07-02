resource "aws_kms_key" "peramater_store_key" {
  description             = "${var.prefix_name}-${var.service_name}-peramater-store-key"
  deletion_window_in_days = 10
}

resource "aws_ssm_parameter" "assume_role_dev" {
  name   = "/codebuild/${var.prefix_name}-${var.service_name}-pipeline/development/assume_role"
  type   = "SecureString"
  key_id = aws_kms_key.peramater_store_key.id
  value  = var.dev_assume_role_arn
}

resource "aws_ssm_parameter" "assume_role_pre" {
  name   = "/codebuild/${var.prefix_name}-${var.service_name}-pipeline/pre-production/assume_role"
  type   = "SecureString"
  key_id = aws_kms_key.peramater_store_key.id
  value  = var.pre_production_assume_role_arn
}

resource "aws_ssm_parameter" "assume_role_prod" {
  name   = "/codebuild/${var.prefix_name}-${var.service_name}-pipeline/production/assume_role"
  type   = "SecureString"
  key_id = aws_kms_key.peramater_store_key.id
  value  = var.production_assume_role_arn
}