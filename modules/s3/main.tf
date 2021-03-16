terraform {
  required_providers {
    # TODO https://github.com/GSA/datagov-deploy/issues/2032
    aws = "~>2.54"
  }
}


resource "aws_s3_bucket" "default" {
  bucket = var.bucket_name
  acl    = var.bucket_acl
  BucketEncryption:
    ServerSideEncryptionConfiguration:
      - ServerSideEncryptionByDefault:
          SSEAlgorithm: 'aws:kms'
          KMSMasterKeyID: KMS-KEY-ARN
}
