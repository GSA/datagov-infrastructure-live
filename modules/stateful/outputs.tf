output "instance_private_dns" {
  value = "${aws_instance.default.*.private_dns}"
}
