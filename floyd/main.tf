variable "encryption-key" {
  type = string
}

variable "deploy-key" {
  type = string
}

data "aws_subnet" "floydnet" {
  filter {
    name   = "tag:Name"
    values = ["Management DMZ Subnet A"]
  }
}

module "floyd-gopherbot" {
  source         = "../modules/gopherbot-ec2"
  robot-name     = "floyd"
  encryption-key = var.encryption-key
  repository     = "git@github.com:parsley42/floyd-gopherbot.git"
  deploy-key     = var.deploy-key
  subnet-id      = data.aws_subnet.floydnet.id
}
