module "vpc" {
  source = "../vpc"

  azs                = ["us-east-1c", "us-east-1d"]
  env                = "${var.env}"
  single_nat_gateway = true
  vpc_name           = "ckan-cloud-${var.env}"
}

resource "aws_iam_user" "management" {
  name          = "ckan-cloud-management-${var.env}"
  force_destroy = true
}

# TODO these are too broad

# TODO is this used?
resource "aws_iam_user_policy_attachment" "management_asg_rw" {
  user       = "${aws_iam_user.management.name}"
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
}

# TODO is this used?
resource "aws_iam_user_policy_attachment" "management_cf_rw" {
  user       = "${aws_iam_user.management.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
}

resource "aws_iam_user_policy_attachment" "management_dns_rw" {
  user       = "${aws_iam_user.management.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_user_policy_attachment" "management_ec2_rw" {
  user       = "${aws_iam_user.management.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_user_policy_attachment" "management_efs_rw" {
  user       = "${aws_iam_user.management.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
}

resource "aws_iam_user_policy_attachment" "management_eks_rw" {
  user       = "${aws_iam_user.management.name}"
  policy_arn = "arn:aws:iam::*:policy/EKSFullAccess"
}

# TODO is this used?
resource "aws_iam_user_policy_attachment" "management_iam_rw" {
  user       = "${aws_iam_user.management.name}"
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_user_policy_attachment" "management_rds_rw" {
  user       = "${aws_iam_user.management.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_user_policy_attachment" "management_s3_rw" {
  user       = "${aws_iam_user.management.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# TODO is this used?
resource "aws_iam_user_policy_attachment" "management_vpc_rw" {
  user       = "${aws_iam_user.management.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}
