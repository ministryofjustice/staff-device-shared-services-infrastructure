resource "aws_iam_role" "production_cloudwatch_exporter_role" {
  name = "mojo-shared-services-ima-cloudwatch-exporter-assume-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = { "AWS" : "arn:aws:iam::${var.production_account_id}:root" }
    }]
  })
}

resource "aws_iam_policy" "production_cloudwatch_exporter_access_policy" {
  name = "mojo-shared-services-ima-cloudwatch-exporter-access-policy"

  policy = file("${path.module}/policies/cloudwatchExporterPolicy.json")
}

resource "aws_iam_role_policy_attachment" "production_cloudwatch_access_policy_attachment" {
  policy_arn = aws_iam_policy.production_cloudwatch_exporter_access_policy
  role       = aws_iam_role.production_cloudwatch_exporter_role.name
}
