resource "aws_instance" "catalog-jumpbox" {
  ami                         = "${var.jumpbox_ami}"
  instance_type               = "${var.jumpbox_instance_type}"
  vpc_security_group_ids      = [ "${aws_security_group.jumpbox-sg.id}" ] 
  subnet_id                   = "${data.terraform_remote_state.vpc.public_subnets[0]}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true


  tags {
    Name = "catalog-jumpbox"
  }
}
