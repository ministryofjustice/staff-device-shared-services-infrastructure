resource "aws_ecr_repository" "admin_ecr" {
  name = var.prefix

  provider = ""

  tags = var.tags
}

data "aws_caller_identity" "current" {}

resource "aws_ecr_repository_policy" "admin_docker_dhcp_repository_policy" {
  repository = aws_ecr_repository.admin_ecr.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "1",
            "Effect": "Allow",
            "Principal":{
              "AWS": ["${data.aws_caller_identity.current.account_id}", "${var.shared_services_account_id}"]
            },
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = aws_ecr_repository.admin_ecr.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire older versions of untagged images, keeping the latest 15",
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": 15
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}

EOF
}
