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

  dev_assume_role_arn            = local.dev_assume_role_arn
  pre_production_assume_role_arn = local.pre_production_assume_role_arn
  production_assume_role_arn     = local.production_assume_role_arn

  docker_image = "aws/codebuild/standard:7.0"
  tags         = module.label.tags
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

  dev_assume_role_arn            = local.dev_assume_role_arn
  pre_production_assume_role_arn = local.pre_production_assume_role_arn
  production_assume_role_arn     = local.production_assume_role_arn

  docker_image    = "aws/codebuild/standard:7.0"
  privileged_mode = true
  tags            = module.label.tags
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

  dev_assume_role_arn            = local.dev_assume_role_arn
  pre_production_assume_role_arn = local.pre_production_assume_role_arn
  production_assume_role_arn     = local.production_assume_role_arn

  test_code_build_compute_type = "BUILD_GENERAL1_MEDIUM"
  docker_image    = "aws/codebuild/standard:7.0"
  privileged_mode = true
  tags            = module.label.tags
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

  dev_assume_role_arn            = local.dev_assume_role_arn
  pre_production_assume_role_arn = local.pre_production_assume_role_arn
  production_assume_role_arn     = local.production_assume_role_arn

  docker_image    = "aws/codebuild/standard:7.0" 
  privileged_mode = true
  tags            = module.label.tags
}
