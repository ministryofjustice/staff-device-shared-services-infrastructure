locals {
  tags = merge(var.tags, {
    resource-for-source-code = "https://github.com/${var.github_repo_id}"
  })

  s3_bucket_arns = [
    aws_s3_bucket.artifacts.arn,
    aws_s3_bucket.client-tf-state.arn
  ]

  log_group_name  = "${var.prefix_name}-log-group-${var.service_name}"
  log_stream_name = "${var.prefix_name}-log-streem-${var.service_name}"
}
