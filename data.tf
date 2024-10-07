data "aws_secretsmanager_secret" "dev_assume_role_arn" {
  name = "${module.label.id}__dev_assume_role_arn"
}

data "aws_secretsmanager_secret_version" "dev_assume_role_arn" {
  secret_id = data.aws_secretsmanager_secret.dev_assume_role_arn.id
}


data "aws_secretsmanager_secret" "pre_production_assume_role_arn" {
  name = "${module.label.id}__pre_production_assume_role_arn"
}

data "aws_secretsmanager_secret_version" "pre_production_assume_role_arn" {
  secret_id = data.aws_secretsmanager_secret.pre_production_assume_role_arn.id
}

data "aws_secretsmanager_secret" "production_assume_role_arn" {
  name = "${module.label.id}__production_assume_role_arn"
}

data "aws_secretsmanager_secret_version" "production_assume_role_arn" {
  secret_id = data.aws_secretsmanager_secret.production_assume_role_arn.id
}


data "aws_secretsmanager_secret" "production_kinesis_destination_arn" {
  name = "${module.label.id}__production_kinesis_destination_arn"
}

data "aws_secretsmanager_secret_version" "production_kinesis_destination_arn" {
  secret_id = data.aws_secretsmanager_secret.production_kinesis_destination_arn.id
}


data "aws_secretsmanager_secret" "pre_production_kinesis_destination_arn" {
  name = "${module.label.id}__pre_production_kinesis_destination_arn"
}

data "aws_secretsmanager_secret_version" "pre_production_kinesis_destination_arn" {
  secret_id = data.aws_secretsmanager_secret.pre_production_kinesis_destination_arn.id
}


data "aws_secretsmanager_secret" "development_kinesis_destination_arn" {
  name = "${module.label.id}__development_kinesis_destination_arn"
}

data "aws_secretsmanager_secret_version" "development_kinesis_destination_arn" {
  secret_id = data.aws_secretsmanager_secret.development_kinesis_destination_arn.id
}


data "aws_secretsmanager_secret" "production_account_id" {
  name = "${module.label.id}__production_account_id"
}

data "aws_secretsmanager_secret_version" "production_account_id" {
  secret_id = data.aws_secretsmanager_secret.production_account_id.id
}

data "aws_ssm_parameter" "production_account_id" {
  name = "/codebuild/production/account_id"
}

data "aws_ssm_parameter" "pre_production_account_id" {
  name = "/codebuild/pre-production/account_id"
}

data "aws_ssm_parameter" "development_account_id" {
  name = "/codebuild/development/account_id"
}
