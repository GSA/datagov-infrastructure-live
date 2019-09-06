resource "aws_iam_user" "default" {
  name          = "${var.name}"

  # Ensure we can delete the user if non-terraform MFA or login profiles are
  # created.
  force_destroy = true
}

resource "aws_iam_user_group_membership" "default" {
  user = "${aws_iam_user.default.name}"
  groups = "${var.groups}"
}
