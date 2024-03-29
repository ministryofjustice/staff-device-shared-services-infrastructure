resource "aws_s3_bucket" "client-tf-state" {
  bucket        = "${var.prefix_name}-client-${var.service_name}-tf-state"
  force_destroy = false
  lifecycle {
    prevent_destroy = true
  }

  tags = merge(local.tags, {
    Name = "${var.prefix_name}-client-${var.service_name}-tf-state"
  })
}

resource "aws_s3_bucket_public_access_block" "client-tf-state" {
  bucket = aws_s3_bucket.client-tf-state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_ownership_controls" "client-tf-state" {
  bucket = aws_s3_bucket.client-tf-state.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "client-tf-state" {
  depends_on = [
    aws_s3_bucket_public_access_block.client-tf-state,
    aws_s3_bucket_ownership_controls.client-tf-state
  ]

  bucket = aws_s3_bucket.client-tf-state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "client-tf-state" {
  bucket = aws_s3_bucket.client-tf-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "client-tf-state" {
  bucket = aws_s3_bucket.client-tf-state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.artifacts.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
