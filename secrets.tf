resource "aws_secretsmanager_secret" "dev_assume_role_arn" {
  name        = "${module.label.id}__dev_assume_role_arn"
  description = "Role ARN for development env"
  tags        = local.tags_minus_name
}

resource "aws_secretsmanager_secret" "pre_production_assume_role_arn" {
  name        = "${module.label.id}__pre_production_assume_role_arn"
  description = "Role ARN for pre-production env"
  tags        = local.tags_minus_name
}

resource "aws_secretsmanager_secret" "production_assume_role_arn" {
  name        = "${module.label.id}__production_assume_role_arn"
  description = "Role ARN for production env"
  tags        = local.tags_minus_name
}

resource "aws_secretsmanager_secret" "production_kinesis_destination_arn" {
  name        = "${module.label.id}__production_kinesis_destination_arn"
  description = "ARN for production Kinesis"
  tags        = local.tags_minus_name
}

resource "aws_secretsmanager_secret" "pre_production_kinesis_destination_arn" {
  name        = "${module.label.id}__pre_production_kinesis_destination_arn"
  description = "ARN for pre-production Kinesis"
  tags        = local.tags_minus_name
}

resource "aws_secretsmanager_secret" "development_kinesis_destination_arn" {
  name        = "${module.label.id}__development_kinesis_destination_arn"
  description = "ARN for development Kinesis"
  tags        = local.tags_minus_name
}

resource "aws_secretsmanager_secret" "production_account_id" {
  name        = "${module.label.id}__production_account_id"
  description = "AWS Account ID for production"
  tags        = local.tags_minus_name
}
