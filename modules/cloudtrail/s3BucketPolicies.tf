data "template_file" "s3_bucket_policies" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  template = file("${path.module}/policies/s3BucketPolicy.json")

  vars = {
    aws_account_id          = data.aws_caller_identity.current.account_id
    cloud_trail_bucket_name = local.cloud_trail_bucket_name
    s3_bucket_log_prefix    = local.s3_bucket_log_prefix
  }
}
