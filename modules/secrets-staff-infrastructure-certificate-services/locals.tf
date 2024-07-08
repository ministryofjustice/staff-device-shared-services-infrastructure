locals {
  supported-application = "staff-infrastructure-certificate-services"

  additional_tags_secrets_staff_infrastructure_certificate_services = {
    supported-application-source     = "https://github.com/ministryofjustice/staff-infrastructure-certificate-services"
    supported-application-secret-for = local.supported-application
  }

  tag_secrets_staff_infrastructure_certificate_services = merge(var.tags_minus_name, local.additional_tags_secrets_staff_infrastructure_certificate_services)

  tag_secrets_staff_infrastructure_certificate_services_pre_production = merge(
    local.tag_secrets_staff_infrastructure_certificate_services,
    { supported-application-environment = "pre-production" }
  )
  tag_secrets_staff_infrastructure_certificate_services_production = merge(
    local.tag_secrets_staff_infrastructure_certificate_services,
    { supported-application-environment = "production" }
  )
}
