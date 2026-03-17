terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr # Requirement: Not 10.0.0.0/16 [cite: 486]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "terraform-challenge-vpc" }
}