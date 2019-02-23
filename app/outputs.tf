output "web_sg_id" {
  value = "${aws_security_group.web-sg.id}"
}

output "harvester_sg_id" {
  value = "${aws_security_group.harvester-sg.id}"
}

output "solr_server" {
  value = "${aws_security_group.harvester-sg.id}"
}

output "web_alb_dns" {
  value = "${aws_alb.web_alb.dns_name}"
}
