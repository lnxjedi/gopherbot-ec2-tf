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
