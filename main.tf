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

resource "aws_s3_bucket" "tf_backend" {
  bucket = "tf-backend-02-20240308"
  tags = {
    Name = "tf_backend"
  }
}

resource "aws_s3_bucket_ownership_controls" "tf_backend_ownership" {
  bucket = aws_s3_bucket.tf_backend.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "tf_backend_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.tf_backend_ownership]

  bucket = aws_s3_bucket.tf_backend.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "tf_backend_versioning" {
  bucket = aws_s3_bucket.tf_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}
