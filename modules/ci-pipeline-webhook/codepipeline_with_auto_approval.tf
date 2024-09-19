resource "aws_codepipeline" "codepipeline" {
  name     = var.name
  pipeline_type = "V2"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.artifacts.bucket
    type     = "S3"

    encryption_key {
      id   = aws_kms_key.artifacts.arn
      type = "KMS"
    }
  }

  trigger {
    provider_type  = "CodeStarSourceConnection"
    git_configuration {
      source_action_name = "Source"
      push {
        branches {
          includes = ["main"]
        }
        file_paths {
          excludes = ["README.md", 
                      ".github/*.yml",
                      ".github/workflows/*.yml", 
                      "workflows/*.yml",
                      "documentation/*.md",
                      "documentation/diagrams/*.drawio",
                      "diagrams/*.drawio",
                      "diagrams/*.png"]
        }
      } 
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
        ConnectionArn    = var.codestar_connection_arn
        FullRepositoryId = var.github_repo_id
        BranchName       = var.git_branch_name
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
        name            = "Plan"
        owner           = "AWS"
        category        = "Build"
        provider        = "CodeBuild"
        version         = "1"
        run_order       = 1
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
        name      = "Approve"
        owner     = "AWS"
        category  = "Approval"
        provider  = "Manual"
        version   = "1"
        run_order = 2

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
