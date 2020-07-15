resource "aws_iam_role" "cloudtrail_role" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  name               = "${var.prefix}-cloudtrail-role"
  assume_role_policy = element(data.template_file.cloudtrail_assume_role_policy.*.rendered, 0)

  tags = var.tags
}

data "template_file" "cloudtrail_assume_role_policy" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  template = file("${path.module}/policies/cloudTrailAssumeRolePolicy.json")
}

resource "aws_iam_role_policy_attachment" "cloudtrail_cloudwatch_access_policy_attachment" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  policy_arn = element(aws_iam_policy.cloudtrail_policy.*.arn, 0)
  role       = element(aws_iam_role.cloudtrail_role.*.name, 0)
}
