terraform {
  required_providers {
    aws = "~>3.31"
  }
}


resource "aws_s3_bucket" "default" {
  bucket = var.bucket_name
  acl    = var.bucket_acl
}
