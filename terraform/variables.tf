variable "AWS_ID" {
  default = "950332950980"
}

variable "AWS_REGION" {
  default = "ap-south-1"
}

variable "AWS_EC2_AMI" {
  default = "ami-0f9708d1cd2cfee41"
}

variable "AWS_EC2_TYPE" {
  default = "t3.micro"
}

variable "AWS_ECR_REPO" {
  default = "aws-test/first-repo"
}

// take these from OS environment variables
variable "AWS_ACCESS_KEY_ID" {
  type = string
  sensitive = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
  sensitive = true
}