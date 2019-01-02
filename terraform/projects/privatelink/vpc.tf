terraform {
  backend "s3" {}
}

provider "aws" {
  region = "eu-west-1"
}

module "dmz_vpc" {
  source      = "../../modules/network/vpc"
  vpc_network = "${var.dmz_vpc_network}"
  dns         = "${var.dns}"
  name        = "${var.dmz_vpc_name}"
  role        = "${var.role}"
}

module "blue_vpc" {
  source      = "../../modules/network/vpc"
  vpc_network = "${var.blue_vpc_network}"
  dns         = "${var.dns}"
  name        = "${var.blue_vpc_name}"
  role        = "${var.role}"
}

module "green_vpc" {
  source      = "../../modules/network/vpc"
  vpc_network = "${var.green_vpc_network}"
  dns         = "${var.dns}"
  name        = "${var.green_vpc_name}"
  role        = "${var.role}"
}
