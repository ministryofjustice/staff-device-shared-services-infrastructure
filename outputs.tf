output "cloudwatch_exporter_role_arn" {
  value = module.cloudwatch_exporter_role.arn
}
output "codestar_connection_arn" {
  value = aws_codestarconnections_connection.staff-infrastructure-moj.id
}