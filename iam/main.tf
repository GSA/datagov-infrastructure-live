provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "datagov-terraform-state"
    key            = "sandbox/iam/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "datagov-lock-table"
  }
}

# https://github.com/18F/aws-admin/blob/035c2dc740fe80cf0e6d5a9cb800cf39bd18d34b/terraform/iam/base.tf#L121-L131
resource "aws_iam_account_password_policy" "tts_iam_password_policy" {
  minimum_password_length        = 16
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 10
}
