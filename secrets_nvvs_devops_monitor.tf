module "secrets-nvvs-devops-monitor" {
  source          = "./modules/secrets-nvvs-devops-monitor"
  tags_minus_name = local.tags_minus_name
}
