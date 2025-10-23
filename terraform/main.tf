provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo" {
  ami = "ami-0f9708d1cd2cfee41"
  instance_type = "t3.micro"
  key_name = "public-key-ec2"
  vpc_security_group_ids = [ aws_security_group.allow_traffic.id ]

  user_data = <<-EOF
  #!/bin/bash
  sudo dnf update -y
  sudo dnf install -y docker
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker ec2-user
  sudo -u ec2-user docker pull ahihardik11/html:latest
  sudo -u ec2-user docker run -p 9090:80 ahihardik11/html:latest
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

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  security_group_id = aws_security_group.allow_traffic.id
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
}