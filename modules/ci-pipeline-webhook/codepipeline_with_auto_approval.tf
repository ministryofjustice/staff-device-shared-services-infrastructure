resource "aws_codepipeline" "codepipeline" {
  name     = var.name
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
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
       //ConnectionArn        = "arn:aws:codestar-connections:eu-west-2:683290208331:connection/0e285e0a-2a55-42f1-9c0b-cf7115be6253" // using an existing connection temporarily until we create a new connection for all of our repos
        ConnectionArn        = var.codestar_connection_arn
        FullRepositoryId     = var.github_repo_name
        BranchName           = var.git_branch_name
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
        ProjectName = aws_codebuild_project.test.name
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
    name = "Pre_Production"

    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.pre-production.name
      }
    }
  }

  dynamic "stage" {
    for_each = var.production_plan ? [1] : []

    content {
      name = "Production-Plan"

      action {
        name     = "Plan"
        owner    = "AWS"
        category = "Build"
        provider = "CodeBuild"
        version  = "1"
        run_order  = 1
        input_artifacts = ["source_output"]

        configuration = {
          ProjectName = aws_codebuild_project.plan_production.name
        }
      }
    }
  }


  dynamic "stage" {
    for_each = var.manual_production_deploy ? [1] : []

    content {
      name = "Production-Approve"

      action {
        name     = "Approve"
        owner    = "AWS"
        category = "Approval"
        provider = "Manual"
        version  = "1"
        run_order  = 2

        configuration = {
          CustomData = "Deploy to ${aws_codebuild_project.production.name}?"
        }
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
      run_order       = 3

      configuration = {
        ProjectName = aws_codebuild_project.production.name
      }
    }
  }
}
