resource "aws_secretsmanager_secret" "pre_production_assume_role_arn" {
  name        = "${local.supported-application}/pre_production/assume_role_arn"
  description = "Role ARN for Pre-Production Assume Role"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { tf_var = "assume_role" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_assume_role_arn" {
  secret_id     = aws_secretsmanager_secret.pre_production_assume_role_arn.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_azuread_auth_url" {
  name        = "${local.supported-application}/pre_production/azuread_auth_url"
  description = "Pre-Production AZURE AD AUTH URL"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { env_var = "AZUREAD_AUTH_URL" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_azuread_auth_url" {
  secret_id     = aws_secretsmanager_secret.pre_production_azuread_auth_url.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_azuread_client_id" {
  name        = "${local.supported-application}/pre_production/azuread_client_id"
  description = "Pre-Production AZURE AD CLIENT ID"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { env_var = "AZUREAD_CLIENT_ID" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_azuread_client_id" {
  secret_id     = aws_secretsmanager_secret.pre_production_azuread_client_id.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_azuread_client_secret" {
  name        = "${local.supported-application}/pre_production/azuread_client_secret"
  description = "Pre-Production AZURE AD CLIENT SECRET"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { env_var = "AZUREAD_CLIENT_SECRET" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_azuread_client_secret" {
  secret_id     = aws_secretsmanager_secret.pre_production_azuread_client_secret.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_azuread_token_url" {
  name        = "${local.supported-application}/pre_production/azuread_token_url"
  description = "Pre-Production AZURE AD TOKEN URL"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { env_var = "AZUREAD_TOKEN_URL" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_azuread_token_url" {
  secret_id     = aws_secretsmanager_secret.pre_production_azuread_token_url.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_byoip_pool_id" {
  name        = "${local.supported-application}/pre_production/byoip_pool_id"
  description = "Pre-Production AWS byoip pool id"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { tf_var = "byoip_pool_id" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_byoip_pool_id" {
  secret_id     = aws_secretsmanager_secret.pre_production_byoip_pool_id.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_corsham_mgmt_range" {
  name        = "${local.supported-application}/pre_production/corsham_mgmt_range"
  description = "Pre-Production - Corsham management cidr range"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { tf_var = "corsham_mgmt_range" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_corsham_mgmt_range" {
  secret_id     = aws_secretsmanager_secret.pre_production_corsham_mgmt_range.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_db_name" {
  name        = "${local.supported-application}/pre_production/db_name"
  description = "Pre-Production database name"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { env_var = "DB_NAME" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_db_name" {
  secret_id     = aws_secretsmanager_secret.pre_production_db_name.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_db_password" {
  name        = "${local.supported-application}/pre_production/db_password"
  description = "Pre-Production database password"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { env_var = "DB_PASSWORD" }, { tf_var = "db_password" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_db_password" {
  secret_id     = aws_secretsmanager_secret.pre_production_db_password.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_db_username" {
  name        = "${local.supported-application}/pre_production/db_username"
  description = "Role ARN for Pre-Production Assume Role"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { env_var = "DB_USERNAME" }, { tf_var = "db_username" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_db_username" {
  secret_id     = aws_secretsmanager_secret.pre_production_db_username.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_domain_name" {
  name        = "${local.supported-application}/pre_production/domain_name"
  description = "Pre-Production Domain name"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { tf_var = "domain_name" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_domain_name" {
  secret_id     = aws_secretsmanager_secret.pre_production_domain_name.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_enabled" {
  name        = "${local.supported-application}/pre_production/enabled"
  description = "Pre-Production - Feature flag that controls the deployment of the infrastructure in a given environment"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { tf_var = "enabled" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_enabled" {
  secret_id     = aws_secretsmanager_secret.pre_production_enabled.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_enable_transit_gateway" {
  name        = "${local.supported-application}/pre_production/enable_transit_gateway"
  description = "Pre-Production - enable AWS transit gateway"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { tf_var = "enable_transit_gateway" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_enable_transit_gateway" {
  secret_id     = aws_secretsmanager_secret.pre_production_enable_transit_gateway.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_farnborough_mgmt_range" {
  name        = "${local.supported-application}/pre_production/farnborough_mgmt_range"
  description = "Pre-Production - Farnborough management cidr range"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { tf_var = "farnborough_mgmt_range" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_farnborough_mgmt_range" {
  secret_id     = aws_secretsmanager_secret.pre_production_farnborough_mgmt_range.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_network_services_cidr_block" {
  name        = "${local.supported-application}/pre_production/network_services_cidr_block"
  description = "Pre-Production network services cidr block"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { tf_var = "network_services_cidr_block" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_network_services_cidr_block" {
  secret_id     = aws_secretsmanager_secret.pre_production_network_services_cidr_block.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_server_root_url" {
  name        = "${local.supported-application}/pre_production/server_root_url"
  description = "Pre-Production server root URL"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { env_var = "SERVER_ROOT_URL" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_server_root_url" {
  secret_id     = aws_secretsmanager_secret.pre_production_server_root_url.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_transit_gateway_id" {
  name        = "${local.supported-application}/pre_production/transit_gateway_id"
  description = "Pre-Production AWS Transit Gateway ID"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { tf_var = "transit_gateway_id" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_transit_gateway_id" {
  secret_id     = aws_secretsmanager_secret.pre_production_transit_gateway_id.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_transit_gateway_route_table_id" {
  name        = "${local.supported-application}/pre_production/transit_gateway_route_table_id"
  description = "Pre-Production AWS Transit Gateway route table ID"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { tf_var = "transit_gateway_route_table_id" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_transit_gateway_route_table_id" {
  secret_id     = aws_secretsmanager_secret.pre_production_transit_gateway_route_table_id.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "pre_production_zone_id" {
  name        = "${local.supported-application}/pre_production/zone_id"
  description = "Pre-Production Zone ID"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_pre_production, { tf_var = "zone_id" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "pre_production_zone_id" {
  secret_id     = aws_secretsmanager_secret.pre_production_zone_id.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}
