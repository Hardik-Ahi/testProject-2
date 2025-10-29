data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = [ 
      "sts:AssumeRole"
     ]
    principals {
      type = "Service"
      identifiers = [ "ec2.amazonaws.com" ]
    }
  }
}

data "aws_iam_policy_document" "instance_ecr_access_policy" {
  statement {
    actions = [ 
      "ecr:*"
     ]
    resources = [ "*" ]
  }
}