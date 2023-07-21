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
