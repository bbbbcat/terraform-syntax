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


variable "names" {
  type    = list(string)
  default = ["손정현", "박윤상"]
}

module "personal_custome_vpc" {
  for_each = toset(var.names)
  source   = "./custom_vpc"
  env      = "personal_${each.key}"
}
