resource "aws_iam_role" "this" {
  name = "${var.prefix_name}-assume-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
            "arn:aws:iam::068084030754:root",
            "arn:aws:iam::473630360727:root",
            "arn:aws:iam::037161842252:root"
          ]
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
    actions = [
      "s3:*"
    ]
    resources = [
      "${var.s3_bucket_arn}/*",
      "${var.s3_bucket_arn}"
    ]
  }
  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = [
      "*",
    ]
  }
}

