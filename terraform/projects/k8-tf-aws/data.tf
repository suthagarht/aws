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

data "external" "aws-ec2-endpoint" {
  #program = ["bash", "-c", "dig ec2.${var.aws_region}.amazonaws.com +short A"]
  #program = ["bash", "-c", "curl -s http://ip-api.com/json/ec2.eu-west-2.amazonaws.com"]
  program = ["bash", "-c", "curl -s http://ip-api.com/json/ec2.${var.aws_region}.amazonaws.com?fields=query"]

  #program = ["bash", "-c", "curl -s https://dns.google.com/resolve?name=ec2.eu-west-2.amazonaws.com&type=A"]
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
