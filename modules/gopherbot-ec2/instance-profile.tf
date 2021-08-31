data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_iam_instance_profile" "bot_profile" {
  name = "bot_profile"
  role = aws_iam_role.bot_role.name
}

resource "aws_iam_role" "bot_role" {
  name = "bot_role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
  inline_policy {
    name = "param-access-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow",
          Action   = ["ssm:DescribeParameters"]
          Resource = "*"
        },
        {
          Effect   = "Allow"
          Action   = ["ssm:GetParameters"]
          Resource = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/robots/${var.robot-name}/*"
        }
      ]
    })
  }
}