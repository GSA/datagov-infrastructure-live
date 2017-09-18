output "web_sg_id" {
  value = "${aws_security_group.web-sg.id}"
}

output "harvester_sg_id" {
  value = "${aws_security_group.harvester-sg.id}"
}
