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

  tags = module.label.tags
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
  tags            = module.label.tags
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
  tags            = module.label.tags
}
