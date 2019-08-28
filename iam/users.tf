resource "aws_iam_user" "test" {
  name          = "test_iam"
  force_destroy = true
}

resource "aws_iam_user_group_membership" "test" {
  user = "${aws_iam_user.test.name}"

  groups = [
    "${aws_iam_group.developers.name}",
  ]
}
