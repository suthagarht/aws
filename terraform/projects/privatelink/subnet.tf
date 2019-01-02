terraform {
  backend "s3" {}
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
