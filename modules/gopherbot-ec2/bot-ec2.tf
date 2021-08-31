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
  name = "robot-template"
  image_id = data.aws_ami.amazon-linux-2.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = var.instance-type
  # user_data = filebase64("${path.module}/example.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.bot_profile.name
  }
  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = true
    subnet_id = var.subnet-id
  }
  tag_specifications {
    resource_type = "instance"
    tags = var.tags
  }
}

#   block_device_mappings {
#     device_name = "/dev/sda1"

#     ebs {
#       volume_size = 20
#     }
#   }

#   capacity_reservation_specification {
#     capacity_reservation_preference = "open"
#   }

#   cpu_options {
#     core_count       = 4
#     threads_per_core = 2
#   }

#   credit_specification {
#     cpu_credits = "standard"
#   }

#   disable_api_termination = true

#   ebs_optimized = true

#   elastic_gpu_specifications {
#     type = "test"
#   }

#   elastic_inference_accelerator {
#     type = "eia1.medium"
#   }

# instance_market_options {
#   market_type = "spot"
# }


  # kernel_id = "test"

  # key_name = "test"

  # license_specification {
  #   license_configuration_arn = "arn:aws:license-manager:eu-west-1:123456789012:license-configuration:lic-0123456789abcdef0123456789abcdef"
  # }

  # metadata_options {
  #   http_endpoint               = "enabled"
  #   http_tokens                 = "required"
  #   http_put_response_hop_limit = 1
  # }

  # placement {
  #   availability_zone = "us-west-2a"
  # }

  # ram_disk_id = "test"

  # vpc_security_group_ids = ["sg-12345678"]
