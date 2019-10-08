output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "iam_user_management" {
  value = "${aws_iam_user.management.name}"
}
