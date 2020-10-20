resource "aws_cloudwatch_log_subscription_filter" "production" {
  count = length(var.subscriptions_config.production.log_groups)

  name            = element(var.subscriptions_config.production.log_groups, count.index)
  log_group_name  = element(var.subscriptions_config.production.log_groups, count.index)
  filter_pattern  = ""
  destination_arn = var.subscriptions_config.production.destination_arn
}

resource "aws_cloudwatch_log_subscription_filter" "pre_production" {
  count = length(var.subscriptions_config.pre_production.log_groups)

  name            = element(var.subscriptions_config.pre_production.log_groups, count.index)
  log_group_name  = element(var.subscriptions_config.pre_production.log_groups, count.index)
  filter_pattern  = ""
  destination_arn = var.subscriptions_config.pre_production.destination_arn
}

resource "aws_cloudwatch_log_subscription_filter" "development" {
  count = length(var.subscriptions_config.development.log_groups)

  name            = element(var.subscriptions_config.development.log_groups, count.index)
  log_group_name  = element(var.subscriptions_config.development.log_groups, count.index)
  filter_pattern  = ""
  destination_arn = var.subscriptions_config.development.destination_arn
}