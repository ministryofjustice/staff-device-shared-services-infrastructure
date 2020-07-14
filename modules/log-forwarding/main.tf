resource "aws_cloudwatch_log_subscription_filter" "cloud_watch_forward_subscription_filter_pttp_ci" {
  name            = "cloud-watch-forward-subscription-filter-pttp-ci"
  log_group_name  = "pttp-ci-infrastructure-log-group-core"
  filter_pattern  = ""
  destination_arn = var.destination_arn
}

resource "aws_cloudwatch_log_subscription_filter" "cloud_watch_forward_subscription_filter_sop_oci_access" {
  name            = "cloud-watch-forward-subscription-filter-sop-oci-access"
  log_group_name  = "SOP-OCI-Access-codepipeline-log-group"
  filter_pattern  = ""
  destination_arn = var.destination_arn
}

resource "aws_cloudwatch_log_subscription_filter" "cloud_watch_forward_subscription_filter_global_protect_code_pipeline" {
  name            = "cloud-watch-forward-subscription-filter-cloudtrail-infra"
  log_group_name  = "GlobalProtect-codepipeline-log-group"
  filter_pattern  = ""
  destination_arn = var.destination_arn
}

resource "aws_cloudwatch_log_subscription_filter" "cloud_watch_forward_subscription_global_protect_logs" {
  name            = "cloud-watch-forward-subscription-filter-global-protect-log-group"
  log_group_name  = "GlobalProtect-log-group"
  filter_pattern  = ""
  destination_arn = var.destination_arn
}

resource "aws_cloudwatch_log_subscription_filter" "cloud_watch_forward_subscription_filter_panorama_codepipeline" {
  name            = "cloud-watch-forward-subscription-filter-panorama-codepipeline-log-group"
  log_group_name  = "Panorama-codepipeline-log-group"
  filter_pattern  = ""
  destination_arn = var.destination_arn
}

resource "aws_cloudwatch_log_subscription_filter" "cloud_watch_forward_subscription_filter_tgw_codepipeline" {
  name            = "cloud-watch-forward-subscription-filter-tgw-codepipeline-log-group"
  log_group_name  = "TGW-codepipeline-log-group"
  filter_pattern  = ""
  destination_arn = var.destination_arn
}