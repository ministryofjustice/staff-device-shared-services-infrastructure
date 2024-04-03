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

  dev_assume_role_arn            = local.dev_assume_role_arn
  pre_production_assume_role_arn = local.pre_production_assume_role_arn
  production_assume_role_arn     = local.production_assume_role_arn

  docker_image = "aws/codebuild/standard:7.0"
  tags         = module.label.tags
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

  dev_assume_role_arn            = local.dev_assume_role_arn
  pre_production_assume_role_arn = local.pre_production_assume_role_arn
  production_assume_role_arn     = local.production_assume_role_arn

  privileged_mode = true
  docker_image    = "aws/codebuild/standard:7.0"
  tags            = module.label.tags
}
