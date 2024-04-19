module "log-forward" {
  source      = "./modules/log-forwarding"
  prefix_name = module.label.id

  subscriptions_config = {
    production = {
      destination_arn = local.production_kinesis_destination_arn,
      log_groups = [
        "Panorama-Policy-as-Code-codepipeline-log-group",
        "Panorama-codepipeline-log-group",
        "pttp-ci-infrastructure-admin-log-group-core",
        "pttp-ci-infrastructure-aggregation-log-group-",
        "pttp-ci-infrastructure-cloudtrail-log-group",
        "pttp-ci-infrastructure-dns-dhcp-log-group-core",
        "pttp-ci-infrastructure-dns-server-log-group-core",
        "pttp-ci-infrastructure-ds-config-log-group-core",
        "pttp-ci-infrastructure-kea-server-log-group-core",
        "pttp-ci-infrastructure-log-group-core",
        "pttp-ci-infrastructure-log-hc-log-group-core",
        "pttp-ci-infrastructure-pki-log-group-core",
        "pttp-ci-infrastructure-snmp-log-group-core",
        "pttp-ci-infrastructure-vpc-flow-logs-log-group",
        "SOP-OCI-Access-codepipeline-log-group",
        "TGW-codepipeline-log-group",
        module.logging_heartbeat.production_log_group_name
      ]
    },
    pre_production = {
      destination_arn = local.pre_production_kinesis_destination_arn,
      log_groups = [
        module.logging_heartbeat.pre_production_log_group_name
      ]
    },
    development = {
      destination_arn = local.development_kinesis_destination_arn,
      log_groups = [
        module.logging_heartbeat.development_log_group_name
      ]
    }
  }
}

module "cloudtrail" {
  source                                       = "./modules/cloudtrail"
  enable_cloudtrail_log_shipping_to_cloudwatch = var.enable_cloudtrail_log_shipping_to_cloudwatch
  prefix                                       = module.label.id
  region                                       = data.aws_region.current_region.id
  tags                                         = module.label.tags
}

module "vpc_flow_logs" {
  source = "./modules/vpc_flow_logs"
  prefix = module.label.id
  region = data.aws_region.current_region.id
  tags   = module.label.tags
  vpc_id = module.vpc.vpc_id
}

module "logging_heartbeat" {
  source = "./modules/logging_heartbeat"
  tags   = module.label.tags
}

module "cloudwatch_exporter_role" {
  source = "./modules/cloudwatch_exporter_role"

  production_account_id = local.production_account_id
}
