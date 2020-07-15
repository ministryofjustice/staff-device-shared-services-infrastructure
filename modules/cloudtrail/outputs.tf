output "log_group_name" {
  value = var.enable_cloudtrail_log_shipping_to_cloudwatch ? element(aws_cloudwatch_log_group.cloudtrail_log_group.*.name, 0) : ""
}

output "aws_account_number" {
  value = var.enable_cloudtrail_log_shipping_to_cloudwatch ? data.aws_caller_identity.current.account_id : ""
}
