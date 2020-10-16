resource "aws_cloudwatch_log_subscription_filter" "this" {
  count = length(var.subscription_log_group_names)

  name            = element(var.subscription_log_group_names, count.index)
  log_group_name  = element(var.subscription_log_group_names, count.index)
  filter_pattern  = ""
  destination_arn = var.destination_arn
}