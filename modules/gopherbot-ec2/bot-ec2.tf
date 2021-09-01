data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "bot-template" {
  name                                 = "robot-template"
  image_id                             = data.aws_ami.amazon-linux-2.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance-type
  update_default_version               = true
  user_data = filebase64("${path.module}/bootstrap.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.bot_profile.name
  }
  monitoring {
    enabled = false
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
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [var.subnet-id]
  # Allow the robot to find out who it is by introspection
  tag {
    key                 = "robot-name"
    value               = var.robot-name
    propagate_at_launch = true
  }
  tag {
    key = "Name"
    value = "${var.robot-name}-robot"
    propagate_at_launch = true
  }
  launch_template {
    name = aws_launch_template.bot-template.name
  }
}
