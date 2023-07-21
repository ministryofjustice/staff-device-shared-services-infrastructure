# TODO this pipeline is in failed status, resolve before changing.
module "pttp-infrastructure-ci-pipeline" {
  source                   = "./modules/ci-pipeline-webhook"
  service_name             = "core"
  github_repo_id           = "ministryofjustice/staff-device-logging-infrastructure"
  git_branch_name          = "main"
  name                     = "Staff-Device-Logging"
  prefix_name              = module.label.id
  codestar_connection_arn  = aws_codestarconnections_connection.staff-infrastructure-moj.id
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  manual_production_deploy = true

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn
}

module "pttp-infrastructure-ci-pipeline-dns-dhcp" {
  source                  = "./modules/ci-pipeline-webhook"
  service_name            = "core"
  github_repo_id          = "ministryofjustice/staff-device-dns-dhcp-infrastructure"
  git_branch_name         = "main"
  name                    = "Staff-Device-DNS-DHCP-Infrastructure"
  prefix_name             = "${module.label.id}-dns-dhcp"
  codestar_connection_arn = aws_codestarconnections_connection.staff-infrastructure-moj.id
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn
}

module "pttp-infrastructure-ci-pipeline-dhcp-container" {
  source                  = "./modules/ci-pipeline-webhook"
  service_name            = "core"
  github_repo_id          = "ministryofjustice/staff-device-dhcp-server"
  git_branch_name         = "main"
  name                    = "Staff-Device-DHCP-Server"
  prefix_name             = "${module.label.id}-kea-server"
  codestar_connection_arn = aws_codestarconnections_connection.staff-infrastructure-moj.id
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn

  privileged_mode = true
}

# TODO this pipeline is in failed status, resolve before changing.
module "staff-device-logging-syslog-to-cloudwatch-pipeline" {
  source                  = "./modules/ci-pipeline-webhook"
  service_name            = "core"
  github_repo_id          = "ministryofjustice/staff-device-logging-syslog-to-cloudwatch"
  git_branch_name         = "main"
  name                    = "Staff-Device-Logging-Syslog-To-Cloudwatch"
  prefix_name             = "${module.label.id}-log-syslog"
  codestar_connection_arn = aws_codestarconnections_connection.staff-infrastructure-moj.id
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn

  privileged_mode = true
}

module "pttp-infrastructure-ci-pipeline-dns-dhcp-admin-container" {
  source                  = "./modules/ci-pipeline-webhook"
  service_name            = "core"
  github_repo_id          = "ministryofjustice/staff-device-dns-dhcp-admin"
  git_branch_name         = "main"
  name                    = "Staff-Device-Admin-Portal"
  prefix_name             = "${module.label.id}-admin"
  codestar_connection_arn = aws_codestarconnections_connection.staff-infrastructure-moj.id
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn

  privileged_mode = true
}

module "pttp-infrastructure-ci-pipeline-dns-container" {
  source                  = "./modules/ci-pipeline-webhook"
  service_name            = "core"
  github_repo_id          = "ministryofjustice/staff-device-dns-server"
  git_branch_name         = "main"
  name                    = "Staff-Device-DNS-Server"
  prefix_name             = "${module.label.id}-dns-server"
  codestar_connection_arn = aws_codestarconnections_connection.staff-infrastructure-moj.id
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn

  privileged_mode = true
}

module "network-access-control-infrastructure" {
  source                   = "./modules/ci-pipeline-webhook"
  github_repo_id           = "ministryofjustice/network-access-control-infrastructure"
  git_branch_name          = "main"
  service_name             = "core"
  manual_production_deploy = true
  production_plan          = true
  name                     = "network-access-control-infrastructure"
  prefix_name              = "${module.label.id}-nac"
  codestar_connection_arn  = aws_codestarconnections_connection.staff-infrastructure-moj.id
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
}

module "network-access-control-server" {
  source                   = "./modules/ci-pipeline-webhook"
  github_repo_id           = "ministryofjustice/network-access-control-server"
  git_branch_name          = "main"
  service_name             = "core"
  docker_image             = "aws/codebuild/standard:5.0"
  manual_production_deploy = true

  name                    = "network-access-control-server"
  prefix_name             = "${module.label.id}-nac-server"
  codestar_connection_arn = aws_codestarconnections_connection.staff-infrastructure-moj.id
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn

  privileged_mode = true
}

module "network-access-control-admin" {
  source                   = "./modules/ci-pipeline-webhook"
  github_repo_id           = "ministryofjustice/network-access-control-admin"
  git_branch_name          = "main"
  service_name             = "core"
  docker_image             = "aws/codebuild/standard:5.0"
  manual_production_deploy = true

  name                    = "network-access-control-admin"
  prefix_name             = "${module.label.id}-nac-admin"
  codestar_connection_arn = aws_codestarconnections_connection.staff-infrastructure-moj.id
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn

  privileged_mode = true
}

module "staff-infrastructure-network-services" {
  source                  = "./modules/ci-pipeline-webhook"
  service_name            = "core"
  github_repo_id          = "ministryofjustice/staff-infrastructure-network-services"
  git_branch_name         = "main"
  name                    = "staff-infrastructure-network-services"
  prefix_name             = "${module.label.id}-net-svcs"
  codestar_connection_arn = aws_codestarconnections_connection.nvvs-github-connection.id
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn
}

module "staff-infrastructure-smtp-relay-server" {
  source                  = "./modules/ci-pipeline-webhook"
  service_name            = "core"
  github_repo_id          = "ministryofjustice/staff-infrastructure-smtp-relay-server"
  git_branch_name         = "main"
  name                    = "staff-infrastructure-smtp-relay-server"
  prefix_name             = "${module.label.id}-smtp-relay"
  codestar_connection_arn = aws_codestarconnections_connection.staff-infrastructure-moj.id
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnets

  dev_assume_role_arn            = var.dev_assume_role_arn
  pre_production_assume_role_arn = var.pre_production_assume_role_arn
  production_assume_role_arn     = var.production_assume_role_arn

  privileged_mode = true
}
