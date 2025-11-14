terraform {
  backend "s3" {
    bucket = "bucket-aws-aws-bucket"
    key = "root/state"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = var.AWS_REGION
}

resource "aws_iam_role_policy" "ecrAccessPolicy" {
  role = aws_iam_role.ecrAccess.name
  policy = data.aws_iam_policy_document.instance_ecr_access_policy.json
}

resource "aws_iam_role" "ecrAccess" {
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json  // just 'sts:AssumeRole' permission
  name = "ecrAccessRole"
}

resource "aws_iam_instance_profile" "instanceProfile" {
  role = aws_iam_role.ecrAccess.name
}

resource "aws_instance" "demo" {
  ami = var.AWS_EC2_AMI
  instance_type = var.AWS_EC2_TYPE
  key_name = aws_key_pair.keyPair.key_name
  vpc_security_group_ids = [ aws_security_group.allow_traffic.id ]
  iam_instance_profile = aws_iam_instance_profile.instanceProfile.name

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y docker
  sudo service docker start
  sudo systemctl enable docker
  sudo usermod -aG docker ec2-user
  sudo docker pull ahihardik11/html:latest
  sudo docker run -d -p 9090:80 ahihardik11/html:latest
  EOF
}

resource "aws_security_group" "allow_traffic" {
  name        = "allow_traffic"
  description = "Allow all inbound traffic"
}

resource "aws_key_pair" "keyPair" {
  key_name = "public-key-ec2"
  public_key = file("/ssh_key.pub")
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