module "pttp-infrastructure-ci-pipeline" {
  source                   = "./modules/ci-pipeline-webhook"
  service_name             = "core"
  github_repo_id           = "ministryofjustice/staff-device-logging-infrastructure"
  git_branch_name          = "decommission_infra"
  name                     = "Staff-Device-Logging"
  prefix_name              = module.label.id
  codestar_connection_arn  = aws_codestarconnections_connection.staff-infrastructure-moj.id
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  manual_production_deploy = true
  docker_image             = "aws/codebuild/standard:7.0"

  dev_assume_role_arn            = local.dev_assume_role_arn
  pre_production_assume_role_arn = local.pre_production_assume_role_arn
  production_assume_role_arn     = local.production_assume_role_arn

  tags = module.label.tags
}
