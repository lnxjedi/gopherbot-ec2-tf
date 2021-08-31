terraform {
  backend "remote" {
    organization = "LinuxJedi"
    workspaces {
      name = "floyd-ec2"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
