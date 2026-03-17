variable "aws_region" { default = "us-east-1" }
variable "vpc_cidr" { default = "10.20.0.0/16" }
variable "public_subnet_cidrs" { default = ["10.20.1.0/24", "10.20.2.0/24"] }
variable "private_subnet_cidrs" { default = ["10.20.3.0/24", "10.20.4.0/24"] }
variable "ami_id" { default = "ami-0440d3b780d96b29d" } # Amazon Linux 2023
variable "key_name" {}