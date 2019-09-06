resource "aws_iam_group" "datagov_ckan_multi" {
  name = "datagov-ckan-multi"
}

# TODO these permissions are way too broad.

resource "aws_iam_group_policy_attachment" "datagov_ckan_multi_ec2_full" {
  group      = "${aws_iam_group.datagov_ckan_multi.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "datagov_ckan_multi_efs_full" {
  group      = "${aws_iam_group.datagov_ckan_multi.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
}

resource "aws_iam_group_policy_attachment" "datagov_ckan_multi_eks_cluster" {
  group      = "${aws_iam_group.datagov_ckan_multi.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_group_policy_attachment" "datagov_ckan_multi_eks_cni" {
  group      = "${aws_iam_group.datagov_ckan_multi.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_group_policy_attachment" "datagov_ckan_multi_eks_service" {
  group      = "${aws_iam_group.datagov_ckan_multi.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_group_policy_attachment" "datagov_ckan_multi_rds_full" {
  group      = "${aws_iam_group.datagov_ckan_multi.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_group_policy_attachment" "datagov_ckan_multi_route53_full" {
  group      = "${aws_iam_group.datagov_ckan_multi.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_group_policy_attachment" "datagov_ckan_multi_s3_full" {
  group      = "${aws_iam_group.datagov_ckan_multi.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
