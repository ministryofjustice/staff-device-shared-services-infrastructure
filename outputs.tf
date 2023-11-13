output "cloudwatch_exporter_role_arn" {
  value = module.cloudwatch_exporter_role.arn
}
output "codestar_connection_arn" {
  value = aws_codestarconnections_connection.staff-infrastructure-moj.id
}

output "module_logging_heartbeat_debug" {
  value = module.logging_heartbeat.debug
}

output "module_label" {
  value = module.label
}

output "s3-mojo_file_transfer_assume_role_arn" {
  value = module.s3-mojo_file_transfer_assume_role.arn
}