resource "aws_secretsmanager_secret" "development_assume_role_arn" {
  name        = "${local.supported-application}/development/assume_role_arn"
  description = "Role ARN for Development Assume Role"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { tf_var = "assume_role" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_assume_role_arn" {
  secret_id     = aws_secretsmanager_secret.development_assume_role_arn.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_azuread_auth_url" {
  name        = "${local.supported-application}/development/azuread_auth_url"
  description = "Development AZURE AD AUTH URL"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { env_var = "AZUREAD_AUTH_URL" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_azuread_auth_url" {
  secret_id     = aws_secretsmanager_secret.development_azuread_auth_url.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_azuread_client_id" {
  name        = "${local.supported-application}/development/azuread_client_id"
  description = "Development AZURE AD CLIENT ID"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { env_var = "AZUREAD_CLIENT_ID" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_azuread_client_id" {
  secret_id     = aws_secretsmanager_secret.development_azuread_client_id.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_azuread_client_secret" {
  name        = "${local.supported-application}/development/azuread_client_secret"
  description = "Development AZURE AD CLIENT SECRET"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { env_var = "AZUREAD_CLIENT_SECRET" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_azuread_client_secret" {
  secret_id     = aws_secretsmanager_secret.development_azuread_client_secret.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_azuread_token_url" {
  name        = "${local.supported-application}/development/azuread_token_url"
  description = "Development AZURE AD TOKEN URL"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { env_var = "AZUREAD_TOKEN_URL" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_azuread_token_url" {
  secret_id     = aws_secretsmanager_secret.development_azuread_token_url.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_byoip_pool_id" {
  name        = "${local.supported-application}/development/byoip_pool_id"
  description = "Development AWS byoip pool id"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { tf_var = "byoip_pool_id" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_byoip_pool_id" {
  secret_id     = aws_secretsmanager_secret.development_byoip_pool_id.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_corsham_mgmt_range" {
  name        = "${local.supported-application}/development/corsham_mgmt_range"
  description = "Development - Corsham management cidr range"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { tf_var = "corsham_mgmt_range" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_corsham_mgmt_range" {
  secret_id     = aws_secretsmanager_secret.development_corsham_mgmt_range.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_db_name" {
  name        = "${local.supported-application}/development/db_name"
  description = "Development database name"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { env_var = "DB_NAME" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_db_name" {
  secret_id     = aws_secretsmanager_secret.development_db_name.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_db_password" {
  name        = "${local.supported-application}/development/db_password"
  description = "Development database password"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { env_var = "DB_PASSWORD" }, { tf_var = "db_password" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_db_password" {
  secret_id     = aws_secretsmanager_secret.development_db_password.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_db_username" {
  name        = "${local.supported-application}/development/db_username"
  description = "Role ARN for Development Assume Role"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { env_var = "DB_USERNAME" }, { tf_var = "db_username" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_db_username" {
  secret_id     = aws_secretsmanager_secret.development_db_username.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_domain_name" {
  name        = "${local.supported-application}/development/domain_name"
  description = "Development Domain name"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { tf_var = "domain_name" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_domain_name" {
  secret_id     = aws_secretsmanager_secret.development_domain_name.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_enabled" {
  name        = "${local.supported-application}/development/enabled"
  description = "Development - Feature flag that controls the deployment of the infrastructure in a given environment"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { tf_var = "enabled" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_enabled" {
  secret_id     = aws_secretsmanager_secret.development_enabled.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_enable_transit_gateway" {
  name        = "${local.supported-application}/development/enable_transit_gateway"
  description = "Development - enable AWS transit gateway"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { tf_var = "enable_transit_gateway" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_enable_transit_gateway" {
  secret_id     = aws_secretsmanager_secret.development_enable_transit_gateway.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_farnborough_mgmt_range" {
  name        = "${local.supported-application}/development/farnborough_mgmt_range"
  description = "Development - Farnborough management cidr range"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { tf_var = "farnborough_mgmt_range" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_farnborough_mgmt_range" {
  secret_id     = aws_secretsmanager_secret.development_farnborough_mgmt_range.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_network_services_cidr_block" {
  name        = "${local.supported-application}/development/network_services_cidr_block"
  description = "Development network services cidr block"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { tf_var = "network_services_cidr_block" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_network_services_cidr_block" {
  secret_id     = aws_secretsmanager_secret.development_network_services_cidr_block.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_server_root_url" {
  name        = "${local.supported-application}/development/server_root_url"
  description = "Development server root URL"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { env_var = "SERVER_ROOT_URL" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_server_root_url" {
  secret_id     = aws_secretsmanager_secret.development_server_root_url.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_transit_gateway_id" {
  name        = "${local.supported-application}/development/transit_gateway_id"
  description = "Development AWS Transit Gateway ID"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { tf_var = "transit_gateway_id" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_transit_gateway_id" {
  secret_id     = aws_secretsmanager_secret.development_transit_gateway_id.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_transit_gateway_route_table_id" {
  name        = "${local.supported-application}/development/transit_gateway_route_table_id"
  description = "Development AWS Transit Gateway route table ID"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { tf_var = "transit_gateway_route_table_id" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_transit_gateway_route_table_id" {
  secret_id     = aws_secretsmanager_secret.development_transit_gateway_route_table_id.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}

resource "aws_secretsmanager_secret" "development_zone_id" {
  name        = "${local.supported-application}/development/zone_id"
  description = "Development Zone ID"
  tags        = merge(local.tag_secrets_nvvs_devops_monitor_development, { tf_var = "zone_id" })
  lifecycle { prevent_destroy = true }
}

resource "aws_secretsmanager_secret_version" "development_zone_id" {
  secret_id     = aws_secretsmanager_secret.development_zone_id.id
  secret_string = "XXXX_NOT_REAL_VALUE_XXXX"
  lifecycle { ignore_changes = [secret_string] }
}
