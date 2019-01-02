# variables
#
#--------------------------------------------------------------------

variable "instance_default_policy" {
  type        = "string"
  description = "Name of the JSON file containing the default IAM role policy for the instance"
  default     = "default_policy.json"
}


variable "create_instance_key" {
  type        = "string"
  description = "Whether to create a key pair for the instance launch configuration"
  default     = false
}

variable "instance_key_name" {
  type        = "string"
  description = "Name of the instance key"
  default     = "sk-home"
}

variable "instance_public_key" {
  type        = "string"
  description = "The jumpbox default public key material"
  default     = ""
}

# Resources
#
#--------------------------------------------------------------------

## Select AMI
data "aws_ami" "web_ami" {
  most_recent      = true

  filter {
    name   = "platform"
    values = ["Amazon Linux"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }


  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

## Set role
resource "aws_iam_role" "node_iam_role" {
  name = "${var.name}"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

## Create an IAM role
resource "aws_iam_policy" "node_iam_policy_default" {
  name   = "${var.name}-default"
  path   = "/"
  policy = "${file("${path.module}/${var.instance_default_policy}")}"
}


## Link the default policy and role
resource "aws_iam_role_policy_attachment" "node_iam_role_policy_attachment_default" {
  role       = "${aws_iam_role.node_iam_role.name}"
  policy_arn = "${aws_iam_policy.node_iam_policy_default.arn}"
}

## Attach the role to the instance profile
resource "aws_iam_instance_profile" "node_instance_profile" {
  name = "${var.name}"
  role = "${aws_iam_role.node_iam_role.name}"
}

## SSH key to use
resource "aws_key_pair" "node_key" {
  count      = "${var.create_instance_key}"
  key_name   = "${var.instance_key_name}"
  public_key = "${var.instance_public_key}"
}
