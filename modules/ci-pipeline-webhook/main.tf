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

  tags = merge(local.tags, {
    Environment = "development"
    Name        = "${var.prefix_name}-${var.service_name}-development"
  })
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

  tags = merge(local.tags, {
    Environment = "pre-production"
    Name        = "${var.prefix_name}-${var.service_name}-pre-production"
  })
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

  tags = merge(local.tags, {
    Environment = "test"
    Name        = "${var.prefix_name}-${var.service_name}-test"
  })
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

  tags = merge(local.tags, {
    Environment = "production"
    Name        = "${var.prefix_name}-${var.service_name}-plan-production"
  })
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

  tags = merge(local.tags, {
    Environment = "production"
    Name        = "${var.prefix_name}-${var.service_name}-production"
  })
}
