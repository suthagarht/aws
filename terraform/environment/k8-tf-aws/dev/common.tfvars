aws_region = "eu-west-2"
stackname = "blue"
key_name = "dev00"
vpc_name = "k8-blue-vpc"
cluster_name = "k8-cluster"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
remote_state_bucket = "skaws-terraform-state-dev"