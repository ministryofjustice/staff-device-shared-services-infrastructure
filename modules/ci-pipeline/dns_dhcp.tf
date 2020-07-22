resource "aws_s3_bucket" "dns_dhcp_artifacts" {
  bucket        = "${var.prefix_name}-build-dns-dhcp-artifacts-bucket"
  acl           = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.dns_dhcp_artifacts.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "dns_dhcp_artifacts" {
  bucket = aws_s3_bucket.dns_dhcp_artifacts.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "dynamodb_terraform_dns_dhcp_state_lock" {
  name           = "${var.prefix_name}-client-${var.service_name}-tf-dns-dhcp-lock-table"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_kms_key" "dns_dhcp_artifacts" {
  description = "${var.prefix_name}-dns-dhcp-artifacts-${var.service_name}"
}

resource "aws_iam_role_policy" "dns_dhcp_codepipeline_policy" {
  name = "${var.prefix_name}-dns-dhcp-codepipeline-${var.service_name}"
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
        "${aws_s3_bucket.dns_dhcp_artifacts.arn}*"
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
        "${aws_codebuild_project.dns_dhcp_test.id}",
        "${aws_codebuild_project.dns_dhcp_development.id}",
        "${aws_codebuild_project.dns_dhcp_pre_production.id}",
        "${aws_codebuild_project.dns_dhcp_production.id}"
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

data "aws_ssm_parameter" "dns_dhcp_github_oauth_token" {
  name = "/ci/dns-dhcp-github-oauth-token"
}

resource "aws_codepipeline" "dns_dhcp_codepipeline" {
  name     = "${var.prefix_name}-${var.service_name}-dns-dhcp-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.dns_dhcp_artifacts.bucket
    type     = "S3"

    encryption_key {
      id   = aws_kms_key.dns_dhcp_artifacts.arn
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
        OAuthToken           = data.aws_ssm_parameter.dns_dhcp_github_oauth_token.value
        Owner                = var.github_organisation_name
        Repo                 = var.dns_dhcp_github_repo_name
        Branch               = "main"
        PollForSourceChanges = "true"
      }
    }
  }

  stage {
    name = "Test"

    action {
      name            = "Test"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.dns_dhcp_test.name
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
        ProjectName = aws_codebuild_project.dns_dhcp_development.name
      }
    }
  }

  stage {
    name = "Pre_Production"

    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.dns_dhcp_pre_production.name
      }
    }
  }

  stage {
    name = "Production"

    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.dns_dhcp_production.name
      }
    }
  }
}

locals {
  dns_dhcp_log_group_name  = "${var.prefix_name}-dns-dhcp-log-group-${var.service_name}"
  dns_dhcp_log_stream_name = "${var.prefix_name}-dns-dhcp-log-streem-${var.service_name}"
}

resource "aws_codebuild_project" "dns_dhcp_development" {
  name          = "${var.prefix_name}-${var.service_name}-dns-dhcp-development"
  description   = "DNS DHCP Development"
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

    environment_variable {
      name  = "ENV"
      value = "development"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = local.dns_dhcp_log_group_name
      stream_name = local.dns_dhcp_log_stream_name
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}

resource "aws_codebuild_project" "dns_dhcp_pre_production" {
  name          = "${var.prefix_name}-${var.service_name}-dns-dhcp-pre-production"
  description   = "DNS DHCP Pre Production"
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

    environment_variable {
      name  = "ENV"
      value = "pre-production"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = local.dns_dhcp_log_group_name
      stream_name = local.dns_dhcp_log_stream_name
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}

resource "aws_codebuild_project" "dns_dhcp_test" {
  name          = "${var.prefix_name}-${var.service_name}-dns-dhcp-test"
  description   = "DNS DHCP Test"
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
  }

  logs_config {
    cloudwatch_logs {
      group_name  = local.dns_dhcp_log_group_name
      stream_name = local.dns_dhcp_log_stream_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.test.yml"
  }
}

resource "aws_codebuild_project" "dns_dhcp_production" {
  name          = "${var.prefix_name}-${var.service_name}-dns-dhcp-production"
  description   = "DNS DHCP Production"
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

    environment_variable {
      name  = "ENV"
      value = "production"
    }

  }

  logs_config {
    cloudwatch_logs {
      group_name  = local.dns_dhcp_log_group_name
      stream_name = local.dns_dhcp_log_stream_name
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}
