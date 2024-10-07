locals {
  cidr_block = "10.0.0.0/16"

  ## vpc module requires the tags map without the "Name" value
  ## It uses the "name" attribute internally and concatenates with other attributes
  tags_minus_name = { for k, v in module.label.tags : k => v if !contains(["Name"], k) }

  dev_assume_role_arn            = nonsensitive(data.aws_secretsmanager_secret_version.dev_assume_role_arn.secret_string)
  pre_production_assume_role_arn = nonsensitive(data.aws_secretsmanager_secret_version.pre_production_assume_role_arn.secret_string)
  production_assume_role_arn     = nonsensitive(data.aws_secretsmanager_secret_version.production_assume_role_arn.secret_string)

  production_kinesis_destination_arn     = nonsensitive(data.aws_secretsmanager_secret_version.production_kinesis_destination_arn.secret_string)
  pre_production_kinesis_destination_arn = nonsensitive(data.aws_secretsmanager_secret_version.pre_production_kinesis_destination_arn.secret_string)
  development_kinesis_destination_arn    = nonsensitive(data.aws_secretsmanager_secret_version.development_kinesis_destination_arn.secret_string)

}
