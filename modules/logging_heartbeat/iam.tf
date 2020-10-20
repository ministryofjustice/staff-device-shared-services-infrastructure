resource "aws_iam_role" "logging_heartbeat_role" {
  name               = "logging_heartbeat_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "logging_heartbeat" {
  role       = aws_iam_role.logging_heartbeat_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
}

resource "aws_iam_instance_profile" "logging_heartbeat" {
  name = "test_profile"
  role = aws_iam_role.logging_heartbeat_role.name
}
