resource "aws_secretsmanager_secret" "production_assume_role_arn" {
  name        = "${local.supported-application}/production/assume_role_arn"
  description = "Role ARN for Production Assume Role"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { env_var = "TF_VAR_assume_role" }, { tf_var = "assume_role" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_assume_role_arn" {
  secret_id     = aws_secretsmanager_secret.production_assume_role_arn.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "production_trusted_cidr" {
  name        = "${local.supported-application}/production/trusted_cidr"
  description = "Production trusted cidr"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { env_var = "TF_VAR_trusted_cidr" }, { tf_var = "trusted_cidr" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_trusted_cidr" {
  secret_id     = aws_secretsmanager_secret.production_trusted_cidr.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "production_primary_remote_destination_cidr" {
  name        = "${local.supported-application}/production/primary_remote_destination_cidr"
  description = "Production primary remote destination cidr"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { env_var = "TF_VAR_primary_remote_destination_cidr" }, { tf_var = "primary_remote_destination_cidr" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_primary_remote_destination_cidr" {
  secret_id     = aws_secretsmanager_secret.production_primary_remote_destination_cidr.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "production_primary_internal_cidr" {
  name        = "${local.supported-application}/production/primary_internal_cidr"
  description = "Production primary internal cidr"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { env_var = "TF_VAR_primary_internal_cidr" }, { tf_var = "primary_internal_cidr" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_primary_internal_cidr" {
  secret_id     = aws_secretsmanager_secret.production_primary_internal_cidr.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "production_secondary_remote_destination_cidr" {
  name        = "${local.supported-application}/production/secondary_remote_destination_cidr"
  description = "Production secondary remote destination cidr"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { env_var = "TF_VAR_secondary_remote_destination_cidr" }, { tf_var = "secondary_remote_destination_cidr" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_secondary_remote_destination_cidr" {
  secret_id     = aws_secretsmanager_secret.production_secondary_remote_destination_cidr.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "secondary_internal_cidr" {
  name        = "${local.supported-application}/production/secondary_internal_cidr"
  description = "Production secondary internal cidr"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { tf_var = "TF_VAR_seondary_internal_cidr" }, { tf_var = "seondary_internal_cidr" })
  lifecycle { prevent_destroy = true }
  ## Misspelt in the supported-application Terraform
}

resource "aws_secretsmanager_secret_version" "secondary_internal_cidr" {
  secret_id     = aws_secretsmanager_secret.secondary_internal_cidr.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "production_cgw_hsm_primary_ip" {
  name        = "${local.supported-application}/production/cgw_hsm_primary_ip"
  description = "Production - cgw hsm primary ip"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { tf_var = "TF_VAR_cgw_hsm_primary_ip" }, { tf_var = "cgw_hsm_primary_ip" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_cgw_hsm_primary_ip" {
  secret_id     = aws_secretsmanager_secret.production_cgw_hsm_primary_ip.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "production_cgw_hsm_secondary_ip" {
  name        = "${local.supported-application}/production/cgw_hsm_secondary_ip"
  description = "Production cgw hsm secondary ip"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { env_var = "TF_VAR_cgw_hsm_secondary_ip" }, { tf_var = "cgw_hsm_secondary_ip" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_cgw_hsm_secondary_ip" {
  secret_id     = aws_secretsmanager_secret.production_cgw_hsm_secondary_ip.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "production_pcx_preproduction_pki_ost_id" {
  name        = "${local.supported-application}/production/pcx_preproduction_pki_ost_id"
  description = "Production pcx preproduction pki ost id"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { env_var = "TF_VAR_pcx_preproduction_pki_ost_id" }, { tf_var = "pcx_preproduction_pki_ost_id" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_pcx_preproduction_pki_ost_id" {
  secret_id     = aws_secretsmanager_secret.production_pcx_preproduction_pki_ost_id.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "production_pcx_production_pki_ost_id" {
  name        = "${local.supported-application}/production/pcx_production_pki_ost_id"
  description = "Production pcx production pki ost id"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { env_var = "TF_VAR_pcx_production_pki_ost_id" }, { tf_var = "pcx_production_pki_ost_id" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_pcx_production_pki_ost_id" {
  secret_id     = aws_secretsmanager_secret.production_pcx_production_pki_ost_id.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "production_pcx_preproduction_pki_ost_cidr" {
  name        = "${local.supported-application}/production/pcx_preproduction_pki_ost_cidr"
  description = "Production pcx preproduction pki ost cidr"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { env_var = "TF_VAR_pcx_preproduction_pki_ost_cidr" }, { tf_var = "pcx_preproduction_pki_ost_cidr" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_pcx_preproduction_pki_ost_cidr" {
  secret_id     = aws_secretsmanager_secret.production_pcx_preproduction_pki_ost_cidr.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "production_pcx_production_pki_ost_cidr" {
  name        = "${local.supported-application}/production/pcx_production_pki_ost_cidr"
  description = "Production pcx production pki ost cidr"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { env_var = "TF_VAR_pcx_production_pki_ost_cidr" }, { tf_var = "pcx_production_pki_ost_cidr" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_pcx_production_pki_ost_cidr" {
  secret_id     = aws_secretsmanager_secret.production_pcx_production_pki_ost_cidr.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "production_mojo_prod_tgw_id" {
  name        = "${local.supported-application}/production/mojo_prod_tgw_id"
  description = "Production mojo prod tgw id"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { env_var = "TF_VAR_mojo_prod_tgw_id" }, { tf_var = "mojo_prod_tgw_id" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_mojo_prod_tgw_id" {
  secret_id     = aws_secretsmanager_secret.production_mojo_prod_tgw_id.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "production_gp_client_prod_cidr_block" {
  name        = "${local.supported-application}/production/gp_client_prod_cidr_block"
  description = "Production gp client prod cidr block"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { env_var = "TF_VAR_gp_client_prod_cidr_block" }, { tf_var = "gp_client_prod_cidr_block" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_gp_client_prod_cidr_block" {
  secret_id     = aws_secretsmanager_secret.production_gp_client_prod_cidr_block.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "production_mojo_production_account_id" {
  name        = "${local.supported-application}/production/mojo_production_account_id"
  description = "Production MOJO production AWS account id"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { env_var = "TF_VAR_mojo_production_account_id" }, { tf_var = "mojo_production_account_id" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_mojo_production_account_id" {
  secret_id     = aws_secretsmanager_secret.production_mojo_production_account_id.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "production_alz_cidr_block" {
  name        = "${local.supported-application}/production/alz_cidr_block"
  description = "Production  alz cidr block"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { env_var = "TF_VAR_alz_cidr_block" }, { tf_var = "alz_cidr_block" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_alz_cidr_block" {
  secret_id     = aws_secretsmanager_secret.production_alz_cidr_block.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "production_ms_teams_webhook_url" {
  name        = "${local.supported-application}/production/ms_teams_webhook_url"
  description = "Production MS Teams Webhook URL"
  tags        = merge(local.tag_secrets_staff_infrastructure_certificate_services_production, { env_var = "TF_VAR_ms_teams_webhook_url" }, { tf_var = "ms_teams_webhook_url" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "production_ms_teams_webhook_url" {
  secret_id     = aws_secretsmanager_secret.production_ms_teams_webhook_url.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}
