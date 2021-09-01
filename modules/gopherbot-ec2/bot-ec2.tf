data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "robot" {
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = var.instance-type
  subnet_id                   = var.subnet-id
  iam_instance_profile        = aws_iam_instance_profile.bot_profile.name
  associate_public_ip_address = true
  tags                        = var.tags
}

resource "aws_launch_template" "bot-template" {
  name                                 = "robot-template"
  image_id                             = data.aws_ami.amazon-linux-2.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance-type
  # user_data = filebase64("${path.module}/example.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.bot_profile.name
  }
  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = var.subnet-id
  }
  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}

resource "aws_autoscaling_group" "immortal-bot" {
  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  launch_template {
    name    = aws_launch_template.bot-template.name
    version = "$Latest"
  }
}
