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

resource "aws_launch_configuration" "bot-template" {
  name          = "robot-template"
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = var.instance-type
  user_data     = filebase64("${path.module}/bootstrap.sh")

  iam_instance_profile        = aws_iam_instance_profile.bot_profile.name
  enable_monitoring           = false
  associate_public_ip_address = true
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
  launch_configuration = aws_launch_configuration.bot-template.name
}
