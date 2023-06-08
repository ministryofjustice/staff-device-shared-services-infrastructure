data "aws_region" "current_region" {}

locals {
  cidr_block = "10.0.0.0/16"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"

  name = module.label.id

  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr                 = local.cidr_block

  azs = [
    "${data.aws_region.current_region.id}a",
    "${data.aws_region.current_region.id}b",
    "${data.aws_region.current_region.id}c"
  ]

  private_subnets = [
    cidrsubnet(local.cidr_block, 8, 1),
    cidrsubnet(local.cidr_block, 8, 2),
    cidrsubnet(local.cidr_block, 8, 3)
  ]

  map_public_ip_on_launch = false
}

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
    "source-code"      = "https://github.com/ministryofjustice/pttp-shared-services-infrastructure"
  }
}

# TODO this pipeline is in failed status, resolve before changing.
module "pttp-infrastructure-ci-pipeline" {
  source                   = "./modules/ci-pipeline"
  service_name             = "core"
  github_organisation_name = "ministryofjustice"
  github_repo_name         = "staff-device-logging-infrastructure"
  git_branch_name          = "main"

  name                     = "Staff-Device-Logging"
  prefix_name              = module.label.id
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  manual_production_deploy = true

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn
}

module "pttp-infrastructure-ci-pipeline-dns-dhcp" {
  source                   = "./modules/ci-pipeline"
  service_name             = "core"
  github_organisation_name = "ministryofjustice"
  github_repo_name         = "staff-device-dns-dhcp-infrastructure"
  git_branch_name          = "main"

  name        = "Staff-Device-DNS-DHCP-Infrastructure"
  prefix_name = "${module.label.id}-dns-dhcp"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn
}

module "pttp-infrastructure-ci-pipeline-dhcp-container" {
  source                   = "./modules/ci-pipeline"
  service_name             = "core"
  github_organisation_name = "ministryofjustice"
  github_repo_name         = "staff-device-dhcp-server"
  git_branch_name          = "main"

  name        = "Staff-Device-DHCP-Server"
  prefix_name = "${module.label.id}-kea-server"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn

  privileged_mode = true
}

module "staff-device-logging-syslog-to-cloudwatch-pipeline" {
  source                   = "./modules/ci-pipeline"
  service_name             = "core"
  github_organisation_name = "ministryofjustice"
  github_repo_name         = "staff-device-logging-syslog-to-cloudwatch"
  git_branch_name          = "main"

  name        = "Staff-Device-Logging-Syslog-To-Cloudwatch"
  prefix_name = "${module.label.id}-log-syslog"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn

  privileged_mode = true
}

module "pttp-infrastructure-ci-pipeline-dns-dhcp-admin-container" {
  source                   = "./modules/ci-pipeline"
  service_name             = "core"
  github_organisation_name = "ministryofjustice"
  github_repo_name         = "staff-device-dns-dhcp-admin"
  git_branch_name          = "main"

  name        = "Staff-Device-Admin-Portal"
  prefix_name = "${module.label.id}-admin"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn

  privileged_mode = true
}

module "pttp-infrastructure-ci-pipeline-dns-container" {
  source                   = "./modules/ci-pipeline"
  service_name             = "core"
  github_organisation_name = "ministryofjustice"
  github_repo_name         = "staff-device-dns-server"
  git_branch_name          = "main"

  name        = "Staff-Device-DNS-Server"
  prefix_name = "${module.label.id}-dns-server"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn

  privileged_mode = true
}


module "staff-device-private-dns-zone" {
  github_repo_name         = "staff-device-private-dns-zone"
  source                   = "./modules/ci-pipeline"
  github_organisation_name = "ministryofjustice"
  git_branch_name          = "main"
  service_name             = "core"

  name        = "staff-device-private-dns-zone"
  prefix_name = "${module.label.id}-pvt-dns"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn

  privileged_mode = true
}

module "network-access-control-infrastructure" {
  github_repo_name         = "network-access-control-infrastructure"
  source                   = "./modules/ci-pipeline"
  github_organisation_name = "ministryofjustice"
  git_branch_name          = "main"
  service_name             = "core"
  manual_production_deploy = true
  production_plan          = true

  name        = "network-access-control-infrastructure"
  prefix_name = "${module.label.id}-nac"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
}

module "network-access-control-server" {
  github_repo_name         = "network-access-control-server"
  source                   = "./modules/ci-pipeline"
  github_organisation_name = "ministryofjustice"
  git_branch_name          = "main"
  service_name             = "core"
  docker_image             = "aws/codebuild/standard:5.0"
  manual_production_deploy = true

  name        = "network-access-control-server"
  prefix_name = "${module.label.id}-nac-server"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn

  privileged_mode = true
}

module "network-access-control-admin" {
  github_repo_name         = "network-access-control-admin"
  source                   = "./modules/ci-pipeline"
  github_organisation_name = "ministryofjustice"
  git_branch_name          = "main"
  service_name             = "core"
  docker_image             = "aws/codebuild/standard:5.0"
  manual_production_deploy = true

  name        = "network-access-control-admin"
  prefix_name = "${module.label.id}-nac-admin"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn

  privileged_mode = true
}

module "staff-infrastructure-network-services" {
  source                   = "./modules/ci-pipeline"
  service_name             = "core"
  github_organisation_name = "ministryofjustice"
  github_repo_name         = "staff-infrastructure-network-services"
  git_branch_name          = "main"

  name        = "staff-infrastructure-network-services"
  prefix_name = "${module.label.id}-net-svcs"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn
}

module "staff-infrastructure-smtp-relay-server" {
  source                   = "./modules/ci-pipeline-webhook"
  service_name             = "core"
  github_repo_id           = "ministryofjustice/staff-infrastructure-smtp-relay-server"
  git_branch_name          = "main"
  name                     = "staff-infrastructure-smtp-relay-server"
  prefix_name              = "${module.label.id}-smtp-relay"
  codestar_connection_arn  = aws_codestarconnections_connection.staff-infrastructure-moj.id
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn

  privileged_mode = true
}

module "log-forward" {
  source      = "./modules/log-forwarding"
  prefix_name = module.label.id

  subscriptions_config = {
    production = {
      destination_arn = var.production_kinesis_destination_arn,
      log_groups = [
        "Panorama-Policy-as-Code-codepipeline-log-group",
        "Panorama-codepipeline-log-group",
        "pttp-ci-infrastructure-admin-log-group-core",
        "pttp-ci-infrastructure-aggregation-log-group-",
        "pttp-ci-infrastructure-cloudtrail-log-group",
        "pttp-ci-infrastructure-dns-dhcp-log-group-core",
        "pttp-ci-infrastructure-dns-server-log-group-core",
        "pttp-ci-infrastructure-ds-config-log-group-core",
        "pttp-ci-infrastructure-kea-server-log-group-core",
        "pttp-ci-infrastructure-log-group-core",
        "pttp-ci-infrastructure-log-hc-log-group-core",
        "pttp-ci-infrastructure-log-syslog-log-group-core",
        "pttp-ci-infrastructure-pki-log-group-core",
        "pttp-ci-infrastructure-snmp-log-group-core",
        "pttp-ci-infrastructure-vpc-flow-logs-log-group",
        "SOP-OCI-Access-codepipeline-log-group",
        "TGW-codepipeline-log-group",
        module.logging_heartbeat.production_log_group_name
      ]
    },
    pre_production = {
      destination_arn = var.pre_production_kinesis_destination_arn,
      log_groups = [
        module.logging_heartbeat.pre_production_log_group_name
      ]
    },
    development = {
      destination_arn = var.development_kinesis_destination_arn,
      log_groups = [
        module.logging_heartbeat.development_log_group_name
      ]
    }
  }
}

module "cloudtrail" {
  source                                       = "./modules/cloudtrail"
  enable_cloudtrail_log_shipping_to_cloudwatch = var.enable_cloudtrail_log_shipping_to_cloudwatch
  prefix                                       = module.label.id
  region                                       = data.aws_region.current_region.id
  tags                                         = module.label.tags
}

module "vpc_flow_logs" {
  source = "./modules/vpc_flow_logs"
  prefix = module.label.id
  region = data.aws_region.current_region.id
  tags   = module.label.tags
  vpc_id = module.vpc.vpc_id
}

module "logging_heartbeat" {
  source = "./modules/logging_heartbeat"
  tags   = module.label.tags
}

module "cloudwatch_exporter_role" {
  source = "./modules/cloudwatch_exporter_role"

  production_account_id = var.production_account_id
}
resource "aws_codestarconnections_connection" "nvvs-github-connection" {
  name          = "nvvs github connection"
  provider_type = "GitHub"
  tags          = module.label.tags
}
resource "aws_codestarconnections_connection" "staff-infrastructure-moj" {
  name          = "staff-infrastructure-moj"
  provider_type = "GitHub"
  tags          = module.label.tags
}
