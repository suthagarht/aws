terraform {
  backend "s3" {}
}

data "terraform_remote_state" "privatelink_subnet" {
  backend = "s3"

  config {
    bucket = "skaws-terraform-state-dev"
    key    = "privatelink/privatelink.tfstate"
    region = "eu-west-2"
  }
}

module "dmz_subnet" {
  source                    = "../../modules/network/subnet"
  vpc_id                    = "${module.dmz_vpc.vpc_id}"
  default_tags              = "${map("aws_test", "privatelink_subnet")}"
  subnet_cidrs              = "${var.dmz_subnet_cidrs}"
  subnet_availability_zones = "${var.dmz_subnet_availability_zones}"
}

module "blue_subnet" {
  source                    = "../../modules/network/subnet"
  vpc_id                    = "${module.blue_vpc.vpc_id}"
  default_tags              = "${map("aws_test", "privatelink_subnet")}"
  subnet_cidrs              = "${var.blue_subnet_cidrs}"
  subnet_availability_zones = "${var.blue_subnet_availability_zones}"
}

module "green_subnet" {
  source                    = "../../modules/network/subnet"
  vpc_id                    = "${module.green_vpc.vpc_id}"
  default_tags              = "${map("aws_test", "privatelink_subnet")}"
  subnet_cidrs              = "${var.green_subnet_cidrs}"
  subnet_availability_zones = "${var.green_subnet_availability_zones}"
}
