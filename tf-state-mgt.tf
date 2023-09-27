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
