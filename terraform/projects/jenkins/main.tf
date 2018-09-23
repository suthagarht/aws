terraform {
  backend "s3" {}
}

provider "aws" {
  region = "eu-west-2"
}

module "jenkins_vpc" {
  source      = "../../modules/network/vpc"
  vpc_network = "${var.vpc_network}"
  dns         = "${var.dns}"
  name        = "${var.name}"
  role        = "${var.role}"
}
