module "secrets-nvvs-devops-monitor" {
  source = "./modules/secrets-nvvs-devops-monitor"
  tags_minus_name = local.tags_minus_name

}

#output "tag_secrets_nvvs_devops_monitor" {
#  value = module.secrets-nvvs-devops-monitor.tag_secrets_nvvs_devops_monitor
#}
#
#output "tag_secrets_nvvs_devops_monitor_shared" {
#  value = module.secrets-nvvs-devops-monitor.tag_secrets_nvvs_devops_monitor_shared
#}
#
#output "tag_secrets_nvvs_devops_monitor_development" {
#  value = module.secrets-nvvs-devops-monitor.tag_secrets_nvvs_devops_monitor_development
#}
#
#output "tag_secrets_nvvs_devops_monitor_pre_production" {
#  value = module.secrets-nvvs-devops-monitor.tag_secrets_nvvs_devops_monitor_pre_production
#}
#
#output "tag_secrets_nvvs_devops_monitor_production" {
#  value = module.secrets-nvvs-devops-monitor.tag_secrets_nvvs_devops_monitor_production
#}