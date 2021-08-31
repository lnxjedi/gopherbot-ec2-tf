module "floyd-gopherbot" {
  source         = "../modules/gopherbot-ec2"
  encryption-key = local.encryption-key
  repository     = "git@github.com:parsley42/floyd-gopherbot.git"
  protocol       = "slack"
  deploy-key     = local.deploy-key
}
