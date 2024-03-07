terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.1"
    }
  }
}

#configure the aws Provider
provider "aws" {
  region = "us-west-2"
}

# create a VPC
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main"
  }
}

# create a Public Subnet
resource "aws_subnet" "Public_subnet_1" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.101.0/24"

  tags = {
    Name = "Hangramit_public_subnet_1"
  }
}
# resource "aws_subnet" "Hangramit_private_subnet_1" {
#   vpc_id     = aws_vpc.default.id
#   cidr_block = "10.0.100.0/24"

#   tags = {
#     Name = "Hangramit_private_subnet_1"
#   }
# }

data "aws_subnet" "private_subnet_1" {
  id = "subnet-0b1919704ec1ec558"
}
