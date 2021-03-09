# jumpbox

Creates a statelss EC2 instance configured with basic tools for a jumpbox host.
The jumpbox has an IAM role applied so that it can query ec2 instances for
dynamic Ansible inventory.
