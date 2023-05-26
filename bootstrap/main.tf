terraform {
  required_version = "> 0.12.23"
}

provider "aws" {
  region  = "eu-west-2"
  version = "~> 2.52"
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  delimiter = "-"
  namespace = "pttp"
  stage     = "global-bootstrap"
  name      = "pttp-infrastructure"

  tags = {
    "business-unit"    = "MoJO"
    "environment-name" = "global"
    "owner"            = var.owner-email
    "is-production"    = tostring(var.is-production)

    "application" = "pttp-shared-services-infrastructure",
    "source-code" = "https://github.com/ministryofjustice/pttp-shared-services-infrastructure"
  }
}
