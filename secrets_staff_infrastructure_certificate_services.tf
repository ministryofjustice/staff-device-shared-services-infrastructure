module "secrets-staff-infrastructure-certificate-services" {
  source          = "./modules/secrets-staff-infrastructure-certificate-services"
  tags_minus_name = local.tags_minus_name
}
