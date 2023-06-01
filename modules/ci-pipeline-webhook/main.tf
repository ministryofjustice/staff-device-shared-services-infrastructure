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
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name     = "${var.prefix_name}-client-${var.service_name}-tf-lock-table"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.dynamodb_terraform_state_lock.id}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = 70
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.dynamodb_terraform_state_lock.id}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_write_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_write_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_write_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 70
  }
}



resource "aws_s3_bucket_public_access_block" "client-tf-state" {
  bucket = aws_s3_bucket.client-tf-state.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "artifacts" {
  description = "${var.prefix_name}-artifacts-${var.service_name}"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "${var.prefix_name}-${var.service_name}-codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.prefix_name}-codepipeline_${var.service_name}"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.artifacts.arn}*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "kms:*",
        "ssm:*"
      ],
      "Resource": [
        "${aws_codebuild_project.test.id}",
        "${aws_codebuild_project.development.id}",
        "${aws_codebuild_project.pre-production.id}",
        "${aws_codebuild_project.production.id}",
        "${aws_codebuild_project.plan_production.id}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:*",
        "ssm:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

locals {
  s3_bucket_arns = [
    aws_s3_bucket.artifacts.arn,
    aws_s3_bucket.client-tf-state.arn
  ]
}

module "assume-role-dev" {
  source                = "../ci-assume-role"
  account_role_arn      = var.dev_assume_role_arn
  prefix_name           = "${var.prefix_name}-${var.service_name}-dev"
  dynamo_db_locking_arn = aws_dynamodb_table.dynamodb_terraform_state_lock.arn
  s3_bucket_arns        = local.s3_bucket_arns
}

module "assume-role-pre-production" {
  source                = "../ci-assume-role"
  account_role_arn      = var.pre_production_assume_role_arn
  prefix_name           = "${var.prefix_name}-${var.service_name}-pre-prod"
  dynamo_db_locking_arn = aws_dynamodb_table.dynamodb_terraform_state_lock.arn
  s3_bucket_arns        = local.s3_bucket_arns
}

module "ci-assume-role-production" {
  source                = "../ci-assume-role"
  account_role_arn      = var.production_assume_role_arn
  prefix_name           = "${var.prefix_name}-${var.service_name}-production"
  dynamo_db_locking_arn = aws_dynamodb_table.dynamodb_terraform_state_lock.arn
  s3_bucket_arns        = local.s3_bucket_arns
}

locals {
  log_group_name  = "${var.prefix_name}-log-group-${var.service_name}"
  log_stream_name = "${var.prefix_name}-log-streem-${var.service_name}"
}

resource "aws_codebuild_project" "development" {
  name          = "${var.prefix_name}-${var.service_name}-development"
  description   = "Development"
  build_timeout = 60
  service_role  = module.assume-role-dev.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.docker_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode

    environment_variable {
      name  = "ENV"
      value = "development"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = local.log_group_name
      stream_name = local.log_stream_name
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}

resource "aws_codebuild_project" "pre-production" {
  name          = "${var.prefix_name}-${var.service_name}-pre-production"
  description   = "Pre Production"
  build_timeout = 60
  service_role  = module.assume-role-pre-production.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.docker_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode

    environment_variable {
      name  = "ENV"
      value = "pre-production"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = local.log_group_name
      stream_name = local.log_stream_name
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}

resource "aws_codebuild_project" "test" {
  name          = "${var.prefix_name}-${var.service_name}-test"
  description   = "Test"
  build_timeout = 60
  service_role  = module.assume-role-dev.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_CUSTOM_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.docker_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode
  }

  logs_config {
    cloudwatch_logs {
      group_name  = local.log_group_name
      stream_name = local.log_stream_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.test.yml"
  }
}

resource "aws_codebuild_project" "plan_production" {
  name          = "${var.prefix_name}-${var.service_name}-plan-production"
  description   = "Plan production changes"
  build_timeout = 60
  service_role  = module.ci-assume-role-production.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.docker_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode

    environment_variable {
      name  = "ENV"
      value = "production"
    }

    environment_variable {
      name  = "PLAN"
      value = "true"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = local.log_group_name
      stream_name = local.log_stream_name
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}

resource "aws_codebuild_project" "production" {
  name          = "${var.prefix_name}-${var.service_name}-production"
  description   = "Production"
  build_timeout = 60
  service_role  = module.ci-assume-role-production.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.docker_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode

    environment_variable {
      name  = "ENV"
      value = "production"
    }

  }

  logs_config {
    cloudwatch_logs {
      group_name  = local.log_group_name
      stream_name = local.log_stream_name
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}
