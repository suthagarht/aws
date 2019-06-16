/**
* ## Module: This module incorporates the following network components
*
* - VPC
* - Subnets
* 
*/

# Resources
# --------------------------------------------------------------

terraform {
  backend "s3" {}
}

module "vpc" {
  source       = "../../modules/k8-network/vpc"
  name         = "${var.vpc_name}"
  cidr         = "${var.vpc_cidr}"
  default_tags = "${map("Project", var.stackname, "Name", var.vpc_name)}"
}

module "k8_public_subnet" {
  source                = "../../modules/k8-network/public_subnet"
  vpc_id                = "${module.vpc.vpc_id}"
  default_tags          = "${map("Project", var.stackname)}"
  route_table_public_id = "${module.vpc.route_table_public_id}"
  subnet_cidrs          = "${var.public_subnet_cidrs}"
}

module "k8_nat" {
  source = "../../modules/k8-network/nat"

  #subnet_ids        = "${matchkeys(values(module.k8_public_subnet.public_subnet_names_ids_map), keys(module.k8_public_subnet.public_subnet_names_ids_map), var.public_subnet_nat_gateway_enable)}"
  subnet_ids = "${module.k8_public_subnet.public_subnet_ids}"

  #subnet_ids_length = "${length(var.public_subnet_nat_gateway_enable)}"
  subnet_ids_length = "${length(var.public_subnet_cidrs)}"
}

module "k8_private_subnet" {
  source                     = "../../modules/k8-network/private_subnet"
  vpc_id                     = "${module.vpc.vpc_id}"
  default_tags               = "${map("Project", var.stackname)}"
  subnet_cidrs               = "${var.private_subnet_cidrs}"
  subnet_nat_gateways        = "${module.k8_nat.nat_gateway_ids}"
}

# Outputs
# --------------------------------------------------------------

output "vpc_id" {
  value       = "${module.vpc.vpc_id}"
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = "${module.k8_public_subnet.public_subnet_ids}"
  description = "List containing the IDs of the created subnets."
}

output "private_subnet_ids" {
  value       = "${module.k8_private_subnet.private_subnet_ids}"
  description = "List containing the IDs of the created subnets."
}

output "vpc_cidr" {
  value       = "${module.vpc.vpc_cidr}"
  description = "The CIDR block of the VPC"
}

output "internet_gateway_id" {
  value       = "${module.vpc.internet_gateway_id}"
  description = "The ID of the Internet Gateway"
}

output "route_table_public_id" {
  value       = "${module.vpc.route_table_public_id}"
  description = "The ID of the public routing table"
}
