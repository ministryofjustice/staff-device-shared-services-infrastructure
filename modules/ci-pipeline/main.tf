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
  force_destroy = true
}

resource "aws_kms_key" "artifacts" {
  description = "${var.prefix_name}-artifacts-${var.service_name}"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "test-role"

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
        "${aws_codebuild_project.lint.id}",
        "${aws_codebuild_project.development.id}",
        "${aws_codebuild_project.staging.id}",
        "${aws_codebuild_project.production.id}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:*",
        "ssm:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_codepipeline" "codepipeline" {
  name     = var.service_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.artifacts.bucket
    type     = "S3"

    encryption_key {
      id   = aws_kms_key.artifacts.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        OAuthToken           = var.github_oauth_token
        Owner                = "emileswarts"
        Repo                 = "terraform-mvp"
        Branch               = "master"
        PollForSourceChanges = "true"
      }
    }
  }

  stage {
    name = "Lint"

    action {
      name            = "Lint"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.lint.name
      }
    }
  }

  stage {
    name = "Development"

    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.development.name
      }
    }
  }

  stage {
    name = "Staging"

    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.staging.name
      }
    }
  }


  stage {
    name = "Production"

    action {
      name     = "Approve"
      owner    = "AWS"
      category = "Approval"
      provider = "Manual"
      version  = "1"

      configuration = {
        CustomData = "Deploy to Production?"
      }
      run_order = 1
    }

    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.production.name
      }
    }
  }
}

resource "aws_iam_role" "codebuild" {
  name = "${var.prefix_name}-codebuild-${var.service_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "codebuild" {
  role = aws_iam_role.codebuild.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": ["*"],
      "Action": [
        "logs:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "codebuild:*",
        "kms:*",
        "ssm:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "development" {
  name          = "development"
  description   = "Development"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "FOO"
      value = "BAR"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.prefix_name}-log-group-development-${var.service_name}"
      stream_name = "${var.prefix_name}-log-stream-development-${var.service_name}"
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}

resource "aws_codebuild_project" "staging" {
  name          = "staging"
  description   = "Staging"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "FOO"
      value = "BAR"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.prefix_name}-log-group-staging-${var.service_name}"
      stream_name = "${var.prefix_name}-log-stream-staging-${var.service_name}"
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}

resource "aws_codebuild_project" "lint" {
  name          = "lint"
  description   = "Lint"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "FOO"
      value = "BAR"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.prefix_name}-log-group-lint-${var.service_name}"
      stream_name = "${var.prefix_name}-log-stream-lint-${var.service_name}"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.lint.yml"
  }
}

resource "aws_codebuild_project" "production" {
  name          = "production"
  description   = "Production"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "FOO"
      value = "BAR"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.prefix_name}-log-group-production-${var.service_name}"
      stream_name = "${var.prefix_name}-log-stream-production-${var.service_name}"
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}
