data "aws_iam_user" "ci"{
  user_name = "datagov-ci"
}

resource "aws_iam_user_policy_attachment" "ci" {
  user      = data.aws_iam_user.ci.user_name
  policy_arn = aws_iam_policy.ci.arn
}

resource "aws_iam_policy" "ci" {
  name        = "datagov-terraform"
  description = "Policy allowing access to EC2, RDS, and IAM to automate creation of data.gov environments using terraform in CI."

  policy = file("files/aws_iam_policy_ci_terraform.json")
}
