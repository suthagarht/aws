data "terraform_remote_state" "infra_vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "k8-tf-aws/k8-tf-aws-vpc.tfstate"
    region = "${var.aws_region}"
  }
}

data "external" "myipaddr" {
  program = ["bash", "-c", "curl -s 'https://ipinfo.io/json'"]
}

# Get an AMI ID to use for the worker nodes
data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

# Generate AWS CIDR Block
data "aws_ip_ranges" "aws_repo_cidr" {
  regions  = ["${var.aws_region}"]
  services = ["amazon"]
}

# Generate AWS EC2 CIDR Block
data "aws_ip_ranges" "aws_ec2_cidr" {
  regions  = ["${var.aws_region}"]
  services = ["ec2"]
}
