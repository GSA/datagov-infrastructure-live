terraform {
  required_providers {
    # TODO https://github.com/GSA/datagov-deploy/issues/2032
    aws = "~>2.54"
  }
}


resource "aws_s3_bucket" "default" {
  bucket = var.bucket_name
  acl    = var.bucket_acl
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
