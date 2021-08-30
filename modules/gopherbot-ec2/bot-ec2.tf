locals {
  floyd-prefix = "/robots/floyd"
}

resource "aws_ssm_parameter" "floyd-encryption-key" {
  name        = "${floyd-prefix}/encryption-key"
  description = "Floyd's brain encryption key"
  type        = "SecureString"
  value       = local.floyd-encryption-key

  tags = {
    environment = "production"
  }
}

resource "aws_ssm_parameter" "floyd-repository" {
  name        = "${floyd-prefix}/encryption-key"
  description = "Floyd's brain encryption key"
  type        = "String"
  value       = local.floyd-encryption-key

  tags = {
    environment = "production"
  }
}
