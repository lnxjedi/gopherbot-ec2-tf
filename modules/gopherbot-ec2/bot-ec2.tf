locals {
  bot-prefix = "/robots/${var.robot-name}"
}

resource "aws_ssm_parameter" "encryption-key" {
  name        = "${local.bot-prefix}/GOPHER_ENCRYPTION_KEY"
  description = "The robot's brain encryption key"
  type        = "SecureString"
  value       = var.encryption-key
}

resource "aws_ssm_parameter" "repository" {
  name        = "${local.bot-prefix}/GOPHER_CUSTOM_REPOSITORY"
  description = "The robot's configuration repository"
  type        = "String"
  value       = var.repository
}

resource "aws_ssm_parameter" "protocol" {
  name        = "${local.bot-prefix}/GOPHER_PROTOCOL"
  description = "The robot's chat connection protocol"
  type        = "String"
  value       = var.protocol
}

resource "aws_ssm_parameter" "deploy-key" {
  name        = "${local.bot-prefix}/GOPHER_CUSTOM_REPOSITORY"
  description = "The robot's read-only ssh deploy key"
  type        = "String"
  value       = var.deploy-key
}
