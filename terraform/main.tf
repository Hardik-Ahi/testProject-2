provider "aws" {
  region = var.AWS_REGION
}

resource "aws_instance" "demo" {
  ami = var.AWS_EC2_AMI
  instance_type = var.AWS_EC2_TYPE
  key_name = aws_key_pair.keyPair.key_name
  vpc_security_group_ids = [ aws_security_group.allow_traffic.id ]

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y docker
  sudo service docker start
  sudo systemctl enable docker
  sudo usermod -aG docker ec2-user
  sudo -u ec2-user docker pull ${var.AWS_ID}.dkr.ecr.${var.AWS_REGION}.amazonaws.com/${var.AWS_ECR_REPO}:latest
  sudo -u ec2-user docker run -d -p 9090:80 ${var.AWS_ID}.dkr.ecr.${var.AWS_REGION}.amazonaws.com/${var.AWS_ECR_REPO}:latest
  EOF
}

resource "aws_security_group" "allow_traffic" {
  name        = "allow_traffic"
  description = "Allow all inbound traffic"
}


output "ip" {
  value = aws_instance.demo.public_ip
}

output "id" {
  value = aws_instance.demo.id
}

resource "aws_key_pair" "keyPair" {
  key_name = "public-key-ec2"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBkEfAiTo4isYALYxDm5Uv04VZ3TLwfI1luOTMugIee ahiha@AcerNitro5"
}

resource "aws_security_group_rule" "ingress" {
  type = "ingress"
  protocol = -1
  security_group_id = aws_security_group.allow_traffic.id
  from_port = 0  # start of port range
  to_port = 65535  # end of port range
  cidr_blocks = [ "0.0.0.0/0" ]
  ipv6_cidr_blocks = [ "::/0" ]
}

resource "aws_security_group_rule" "egress" {
  type = "egress"
  protocol = -1
  security_group_id = aws_security_group.allow_traffic.id
  from_port = 0  # start of port range
  to_port = 65535  # end of port range
  cidr_blocks = [ "0.0.0.0/0" ]
  ipv6_cidr_blocks = [ "::/0" ]
}