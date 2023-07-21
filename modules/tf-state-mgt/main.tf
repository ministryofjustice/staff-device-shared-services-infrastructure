resource "aws_kms_key" "artifacts" {
  description = "${var.prefix_name}-artifacts-${var.service_name}"
}

locals {
  tags = merge(var.tags, {
    resource-for-source-code = var.github_repo_id
  })
}
