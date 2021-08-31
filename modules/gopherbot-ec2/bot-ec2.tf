locals {
  bot-prefix = "/robots/${var.robot-name}"
}

resource "aws_ssm_parameter" "bot-encryption-key" {
  name        = "${local.bot-prefix}/encryption-key"
  description = "The robot's brain encryption key"
  type        = "SecureString"
  value       = var.encryption-key
}

resource "aws_ssm_parameter" "bot-repository" {
  name        = "${local.bot-prefix}/encryption-key"
  description = "The robot's configuration repository"
  type        = "String"
  value       = var.repository
}
