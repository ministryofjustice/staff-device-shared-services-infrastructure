resource "aws_cloudwatch_log_subscription_filter" "cloud-watch-forward-subscription-filter-pttp-ci" {
  name            = "cloud-watch-forward-subscription-filter-pttp-ci"
  log_group_name  = "pttp-ci-infrastructure-log-group-core"
  filter_pattern  = ""
  destination_arn = var.destination_arn
}

resource "aws_cloudwatch_log_subscription_filter" "cloud-watch-forward-subscription-filter-sop-oci-access" {
  name            = "cloud-watch-forward-subscription-filter-sop-oci-access"
  log_group_name  = "SOP-OCI-Access-codepipeline-log-group"
  filter_pattern  = ""
  destination_arn = var.destination_arn
}