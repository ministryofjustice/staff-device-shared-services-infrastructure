data "aws_caller_identity" "current" {}

locals {
  s3_bucket_log_prefix                        = "cloudtrail_logs"
  cloud_trail_bucket_name                     = "${var.prefix}-cloudtrail-bucket"
  cloudtrail_log_shipping_to_cloudwatch_count = var.enable_cloudtrail_log_shipping_to_cloudwatch ? 1 : 0
}

resource "aws_kms_key" "cloudtrail_kms_key" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  description             = "${var.prefix}-cloudtrail-kms-key"
  deletion_window_in_days = 10
  policy                  = element(data.template_file.cloud_trail_kms_key_policies.*.rendered, 0)

  tags = var.tags
}

resource "aws_kms_alias" "cloudtrail_kms_key_alias" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  name          = "alias/${var.prefix}-cloudtrail-kms-key-alias"
  target_key_id = element(aws_kms_key.cloudtrail_kms_key.*.key_id, 0)
}

resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  name              = "${var.prefix}-cloudtrail-log-group"
  kms_key_id        = element(aws_kms_key.cloudtrail_kms_key.*.arn, 0)
  retention_in_days = 7

  tags = var.tags
}

resource "aws_cloudtrail" "pttp_cloudtrail" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  name                          = "${var.prefix}-cloudtrail"
  s3_bucket_name                = element(aws_s3_bucket.cloudtrail_bucket.*.id, 0)
  s3_key_prefix                 = local.s3_bucket_log_prefix
  cloud_watch_logs_group_arn    = "${element(aws_cloudwatch_log_group.cloudtrail_log_group.*.arn, 0)}:*"
  cloud_watch_logs_role_arn     = element(aws_iam_role.cloudtrail_role.*.arn, 0)
  include_global_service_events = true
  is_multi_region_trail         = true
  kms_key_id                    = element(aws_kms_key.cloudtrail_kms_key.*.arn, 0)

  tags = var.tags
}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  bucket        = local.cloud_trail_bucket_name
  force_destroy = true

  tags = var.tags
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  bucket = element(aws_s3_bucket.cloudtrail_bucket.*.id, 0)
  policy = element(data.template_file.s3_bucket_policies.*.rendered, 0)
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_bucket" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  bucket = element(aws_s3_bucket.cloudtrail_bucket.*.id, 0)

  rule {
    id     = "removal"
    status = "Enabled"

    expiration {
      days = 7
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_bucket" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  bucket = element(aws_s3_bucket.cloudtrail_bucket.*.id, 0)

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = element(aws_kms_key.cloudtrail_kms_key.*.arn, 0)
      sse_algorithm     = "aws:kms"
    }
  }
}
