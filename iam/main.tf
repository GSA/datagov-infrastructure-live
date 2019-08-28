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

resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = "${aws_iam_group.developers.name}"
  policy_arn = "${aws_iam_policy.enforce_mfa.arn}"
}

resource "aws_iam_policy" "enforce_mfa" {
  name        = "enforce_mfa"
  description = "Enforces MFA and allows human users to manage their own credentials."

  # https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_aws_my-sec-creds-self-manage.html
  policy = "${file("files/aws_sec_creds_self_manage.json")}"
}
