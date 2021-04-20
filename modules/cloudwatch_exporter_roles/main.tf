resource "aws_iam_role" "production_cloudwatch_exporter_role" {
  name = "mojo-shared-services-ima-cloudwatch-exporter-assume-role"

  template = file("${path.module}/policies/cloudwatchExporterPolicy.json")
}
