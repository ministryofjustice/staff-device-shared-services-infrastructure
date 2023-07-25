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

resource "aws_s3_bucket" "artifacts" {
  bucket        = "${var.prefix_name}-build-artifact-bucket"
  acl           = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.artifacts.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = merge(local.tags, {
    Name = "${var.prefix_name}-build-artifact-bucket"
  })
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "client-tf-state" {
  bucket        = "${var.prefix_name}-client-${var.service_name}-tf-state"
  acl           = "private"
  force_destroy = false

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.artifacts.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(local.tags, {
    Name = "${var.prefix_name}-client-${var.service_name}-tf-state"
  })
}

resource "aws_s3_bucket_public_access_block" "client-tf-state" {
  bucket = aws_s3_bucket.client-tf-state.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
