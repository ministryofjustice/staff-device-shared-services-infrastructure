resource "aws_iam_role" "this" {
  name = "${var.prefix_name}-assume-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = merge(var.tags, {
    Name = "${var.prefix_name}-assume-role"
  })
}

resource "aws_iam_role_policy" "this" {
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = [var.account_role_arns]
  }

  statement {
    actions = [
      "s3:*"
    ]
    resources = [
      "var.s3_bucket_arn/*",
      "var.s3_bucket_arn"
    ]
  }
}

