output "pre_production_log_group_name" {
  value = aws_cloudwatch_log_group.logging_heartbeat_pre_production.name
}

output "development_log_group_name" {
  value = aws_cloudwatch_log_group.logging_heartbeat_development.name
}