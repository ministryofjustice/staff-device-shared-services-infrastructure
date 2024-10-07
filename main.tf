data "aws_region" "current_region" {}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace = "pttp"
  stage     = terraform.workspace
  name      = "infrastructure"
  delimiter = "-"

  tags = {
    "business-unit" = "MoJO"
    "application"   = "pttp-shared-services-infrastructure",
    "is-production" = tostring(var.is-production),
    "owner"         = var.owner-email

    "environment-name" = "global"
    "source-code"      = "https://github.com/ministryofjustice/staff-device-shared-services-infrastructure"
  }
}

module "label_staff" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace = "staff"
  stage     = terraform.workspace
  name      = "infrastructure"
  delimiter = "-"

  tags = {
    "business-unit" = "MoJO"
    "application"   = "pttp-shared-services-infrastructure",
    "is-production" = tostring(var.is-production),
    "owner"         = var.owner-email

    "environment-name" = "global"
    "source-code"      = "https://github.com/ministryofjustice/staff-device-shared-services-infrastructure"
  }
}
module "label_github_teams" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace = "staff"
  stage     = terraform.workspace
  name      = "technology-services"
  delimiter = "-"

  tags = {
    "business-unit" = "MoJO"
    "application"   = "pttp-shared-services-infrastructure",
    "is-production" = tostring(var.is-production),
    "owner"         = var.owner-email

    "environment-name" = "global"
    "source-code"      = "https://github.com/ministryofjustice/staff-device-shared-services-infrastructure"
  }
}

module "label_mojo_aws_github" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace = "mojo"
  stage     = terraform.workspace
  name      = "aws-github"
  delimiter = "-"

  tags = {
    "business-unit" = "MoJO"
    "application"   = "pttp-shared-services-infrastructure",
    "is-production" = tostring(var.is-production),
    "owner"         = var.owner-email

    "environment-name" = "global"
    "source-code"      = "https://github.com/ministryofjustice/staff-device-shared-services-infrastructure"
  }
}


module "staff-device-dhcp-admin-ecrs" {
  source = "./modules/shared-services-ecrs"

  production_account_id = data.aws_ssm_parameter.production_account_id.value
  pre_production_account_id = data.aws_ssm_parameter.pre_production_account_id.value
  development_account_id = data.aws_ssm_parameter.development_account_id.value
  prefix = "staff-device-dhcp-admin"
  tags = module.label.tags
}

module "staff-device-dhcp-nginx-ecrs" {
  source = "./modules/shared-services-ecrs"

  production_account_id = data.aws_ssm_parameter.production_account_id.value
  pre_production_account_id = data.aws_ssm_parameter.pre_production_account_id.value
  development_account_id = data.aws_ssm_parameter.development_account_id.value
  prefix = "staff-device-dhcp-nginx"
  tags = module.label.tags
}

module "staff-device-dhcp-ecrs" {
  source = "./modules/shared-services-ecrs"

  production_account_id = data.aws_ssm_parameter.production_account_id.value
  pre_production_account_id = data.aws_ssm_parameter.pre_production_account_id.value
  development_account_id = data.aws_ssm_parameter.development_account_id.value
  prefix = "staff-device-dhcp"
  tags = module.label.tags
}