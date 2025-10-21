provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo" {
  ami = "ami-0f9708d1cd2cfee41"
  instance_type = "t3.micro"
  key_name = "public-key-ec2"
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]

  user_data = <<-EOF
  #!/bin/bash
  sudo dnf update -y
  sudo dnf install -y docker
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker ec2-user
  sudo -u ec2-user docker pull ahihardik11/helloworld:latest
  sudo -u ec2-user docker run ahihardik11/helloworld:latest > file.txt
  EOF
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  # 👇 Ingress = inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # your IP
  }

  # 👇 Egress = outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # allow all outbound traffic
  }
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