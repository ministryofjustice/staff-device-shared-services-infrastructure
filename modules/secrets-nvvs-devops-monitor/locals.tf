locals {
  additional_tags_secrets_nvvs_devops_monitor = {
    supported-application-source     = "https://github.com/ministryofjustice/nvvs-devops-monitor"
    supported-application-secret-for = "nvvs-devops-monitor"
  }

  tag_secrets_nvvs_devops_monitor = merge(var.tags_minus_name, local.additional_tags_secrets_nvvs_devops_monitor)

  tag_secrets_nvvs_devops_monitor_shared = merge(
    local.tag_secrets_nvvs_devops_monitor,
    { supported-application-environment = "shared" }
  )
  tag_secrets_nvvs_devops_monitor_development = merge(
    local.tag_secrets_nvvs_devops_monitor,
    { supported-application-environment = "development" }
  )
  tag_secrets_nvvs_devops_monitor_pre_production = merge(
    local.tag_secrets_nvvs_devops_monitor,
    { supported-application-environment = "pre-production" }
  )
  tag_secrets_nvvs_devops_monitor_production = merge(
    local.tag_secrets_nvvs_devops_monitor,
    { supported-application-environment = "production" }
  )
}