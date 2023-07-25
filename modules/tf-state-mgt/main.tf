resource "aws_kms_key" "artifacts" {
  description = "${var.prefix_name}-${var.service_name}-artifacts"

  tags = merge(local.tags, {
    Name = "${var.prefix_name}-${var.service_name}-artifacts"
  })
}

resource "aws_kms_alias" "artifacts" {
  name          = "alias/${var.prefix_name}-${var.service_name}-artifacts"
  target_key_id = aws_kms_key.artifacts.id
}

locals {
  tags = merge(var.tags, {
    resource-for-source-code = var.github_repo_id
  })
}
