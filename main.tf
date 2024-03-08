terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.1"
    }
  }
  backend "s3" {
    bucket = "tf-backend-02-20240308"
    key    = "terraform.tfstate"
    region = "us-west-2"
    # dynamodb_table = "terraform-lock"
  }
}

#configure the aws Provider
provider "aws" {
  region = "us-west-2"
}



module "main_vpc" {
  source = "./custom_vpc"
  env    = terraform.workspace
}

resource "aws_s3_bucket" "tf_backend" {
  count  = terraform.workspace == "default" ? 1 : 0
  bucket = "tf-backend-02-20240308"
  tags = {
    Name = "tf_backend"
  }
}

resource "aws_s3_bucket_ownership_controls" "tf_backend_ownership" {
  bucket = aws_s3_bucket.tf_backend[0].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "tf_backend_acl" {
  count      = terraform.workspace == "default" ? 1 : 0
  depends_on = [aws_s3_bucket_ownership_controls.tf_backend_ownership]

  bucket = aws_s3_bucket.tf_backend[0].id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "tf_backend_versioning" {
  bucket = aws_s3_bucket.tf_backend[0].id
  versioning_configuration {
    status = "Enabled"
  }
}
