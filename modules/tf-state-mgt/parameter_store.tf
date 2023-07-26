resource "aws_kms_key" "peramater_store_key" {
  description             = "${var.prefix_name}-${var.service_name}-peramater-store-key"
  deletion_window_in_days = 10

  tags = merge(local.tags, {
    Name = "${var.prefix_name}-${var.service_name}"
  })
}

resource "aws_kms_alias" "peramater_store_key" {
  name          = "alias/${var.prefix_name}-${var.service_name}"
  target_key_id = aws_kms_key.peramater_store_key.id
}

resource "aws_ssm_parameter" "assume_role_dev" {
  name   = "/codebuild/${var.prefix_name}-${var.service_name}-pipeline/development/assume_role"
  type   = "SecureString"
  key_id = aws_kms_key.peramater_store_key.id
  value  = var.dev_assume_role_arn

  tags = merge(local.tags, {
    Name = "/codebuild/${var.prefix_name}-${var.service_name}-pipeline/development/assume_role"
  })
}

resource "aws_ssm_parameter" "assume_role_pre" {
  name   = "/codebuild/${var.prefix_name}-${var.service_name}-pipeline/pre-production/assume_role"
  type   = "SecureString"
  key_id = aws_kms_key.peramater_store_key.id
  value  = var.pre_production_assume_role_arn

  tags = merge(local.tags, {
    Name = "/codebuild/${var.prefix_name}-${var.service_name}-pipeline/pre-production/assume_role"
  })
}

resource "aws_ssm_parameter" "assume_role_prod" {
  name   = "/codebuild/${var.prefix_name}-${var.service_name}-pipeline/production/assume_role"
  type   = "SecureString"
  key_id = aws_kms_key.peramater_store_key.id
  value  = var.production_assume_role_arn

  tags = merge(local.tags, {
    Name = "/codebuild/${var.prefix_name}-${var.service_name}-pipeline/production/assume_role"
  })
}
