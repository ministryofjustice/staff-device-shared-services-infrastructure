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

  tags = merge(local.tags, {
    Name = "${var.prefix_name}-${var.service_name}-codepipeline-role"
  })
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

module "assume-role-dev" {
  source                = "../ci-assume-role"
  account_role_arn      = var.dev_assume_role_arn
  prefix_name           = "${var.prefix_name}-${var.service_name}-dev"
  dynamo_db_locking_arn = aws_dynamodb_table.dynamodb_terraform_state_lock.arn
  s3_bucket_arns        = local.s3_bucket_arns
  tags                  = local.tags
}

module "assume-role-pre-production" {
  source                = "../ci-assume-role"
  account_role_arn      = var.pre_production_assume_role_arn
  prefix_name           = "${var.prefix_name}-${var.service_name}-pre-prod"
  dynamo_db_locking_arn = aws_dynamodb_table.dynamodb_terraform_state_lock.arn
  s3_bucket_arns        = local.s3_bucket_arns
  tags                  = local.tags
}

module "ci-assume-role-production" {
  source                = "../ci-assume-role"
  account_role_arn      = var.production_assume_role_arn
  prefix_name           = "${var.prefix_name}-${var.service_name}-production"
  dynamo_db_locking_arn = aws_dynamodb_table.dynamodb_terraform_state_lock.arn
  s3_bucket_arns        = local.s3_bucket_arns
  tags                  = local.tags
}
