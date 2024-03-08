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


variable "envs" {
  type    = list(string)
  default = ["dev", "prd", ""]
}

module "vpc_list" {
  for_each = toset([for s in var.envs : s if s != ""])
  source   = "./custom_vpc"
  env      = each.key
}
