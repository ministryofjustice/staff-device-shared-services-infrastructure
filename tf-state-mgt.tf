module "staff-device-private-dns-zone" {
  source         = "./modules/tf-state-mgt"
  service_name   = "core"
  prefix_name    = "${module.label.id}-pvt-dns"
  github_repo_id = "https://github.com/ministryofjustice/staff-device-private-dns-zone"
  tags           = module.label.tags

  dev_assume_role_arn            = local.dev_assume_role_arn
  pre_production_assume_role_arn = local.pre_production_assume_role_arn
  production_assume_role_arn     = local.production_assume_role_arn
}

module "staff-devops-monitoring" {
  source         = "./modules/tf-state-mgt"
  service_name   = "monitoring-cluster"
  prefix_name    = module.label_staff.id
  github_repo_id = "https://github.com/ministryofjustice/nvvs-devops-monitor"
  tags           = module.label_staff.tags

  dev_assume_role_arn            = local.dev_assume_role_arn
  pre_production_assume_role_arn = local.pre_production_assume_role_arn
  production_assume_role_arn     = local.production_assume_role_arn
}

module "network-operations-centre" {
  source         = "./modules/tf-state-mgt"
  service_name   = "noc"
  prefix_name    = module.label_staff.id
  github_repo_id = "https://github.com/ministryofjustice/deployment-aws-noc"
  tags           = module.label_staff.tags

  pre_production_assume_role_arn = "arn:aws:iam::724777394818:role/SharedServicesAccessRole"
  production_assume_role_arn     = "arn:aws:iam::208632142291:role/SharedServicesAccessRole"
}

module "staff-github-teams" {
  source         = "./modules/tf-state-mgt"
  service_name   = "github-teams"
  prefix_name    = module.label_github_teams.id
  github_repo_id = "https://github.com/ministryofjustice/staff-technology-services-github-teams"
  tags           = module.label_github_teams.tags

  dev_assume_role_arn            = local.dev_assume_role_arn
  pre_production_assume_role_arn = local.pre_production_assume_role_arn
  production_assume_role_arn     = local.production_assume_role_arn
}

module "mojo-aws-github" {
  source         = "./modules/tf-state-mgt"
  service_name   = "oidc-provider"
  prefix_name    = module.label_mojo_aws_github.id
  github_repo_id = "https://github.com/ministryofjustice/mojo-aws-github-oidc-provider"
  tags           = module.label_mojo_aws_github.tags

  dev_assume_role_arn            = local.dev_assume_role_arn
  pre_production_assume_role_arn = local.pre_production_assume_role_arn
  production_assume_role_arn     = local.production_assume_role_arn
}
