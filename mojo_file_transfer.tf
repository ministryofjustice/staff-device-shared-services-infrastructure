resource "aws_kms_key" "mojo_file_transfer" {
  description = "mojo-file-transfer"

  tags = merge(module.label_staff.tags, {
    Name = "mojo-file-transfer"
  })
}

resource "aws_kms_alias" "mojo_file_transfer" {
  name          = "alias/mojo-file-transfer"
  target_key_id = aws_kms_key.mojo_file_transfer.id
}

resource "aws_s3_bucket" "mojo_file_transfer" {
  bucket        = "mojo-file-transfer"
  force_destroy = false
  lifecycle {
    prevent_destroy = true
  }

  tags = merge(module.label_staff.tags, {
    Name = "mojo-file-transfer"
  })
}

resource "aws_s3_bucket_public_access_block" "mojo_file_transfer" {
  bucket = aws_s3_bucket.mojo_file_transfer.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_ownership_controls" "mojo_file_transfer" {
  bucket = aws_s3_bucket.mojo_file_transfer.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "mojo_file_transfer" {
  depends_on = [
    aws_s3_bucket_public_access_block.mojo_file_transfer,
    aws_s3_bucket_ownership_controls.mojo_file_transfer
  ]

  bucket = aws_s3_bucket.mojo_file_transfer.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "mojo_file_transfer" {
  bucket = aws_s3_bucket.mojo_file_transfer.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mojo_file_transfer" {
  bucket = aws_s3_bucket.mojo_file_transfer.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mojo_file_transfer.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

module "s3-mojo_file_transfer_assume_role" {
  source = "./modules/s3-assume-role"

  prefix_name      = "s3-mojo-file-transfer"
  account_role_arns = [local.dev_assume_role_arn, local.pre_production_assume_role_arn, local.production_assume_role_arn]
  s3_bucket_arn   = [aws_s3_bucket.mojo_file_transfer.arn]
  tags = merge(module.label_staff.tags, {
    Name = "mojo-file-transfer"
  })
}
