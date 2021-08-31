variable "encryption-key" {
  type = string
}

variable "deploy-key" {
  type = string
}

module "floyd-gopherbot" {
  source         = "../modules/gopherbot-ec2"
  robot-name     = "floyd"
  encryption-key = var.encryption-key
  repository     = "git@github.com:parsley42/floyd-gopherbot.git"
  deploy-key     = var.deploy-key
}
