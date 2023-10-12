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
