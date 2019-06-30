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

# EKS Cluster VPC
module "vpc" {
  source       = "../../modules/k8-network/vpc"
  name         = "${var.vpc_name}"
  cidr         = "${var.vpc_cidr}"
  default_tags = "${map("Project", var.stackname, "Name", var.vpc_name)}"
}

# EKS Cluster Bastion VPC
module "bastion_vpc" {
  source       = "../../modules/k8-network/vpc"
  name         = "${var.bastion_vpc_name}"
  cidr         = "${var.bastion_vpc_cidr}"
  default_tags = "${map("Project", var.stackname, "Name", var.bastion_vpc_name)}"
}

# EKS Cluster Bastion Public Subnet
module "bastion_public_subnet" {
  source                = "../../modules/k8-network/public_subnet"
  component             = "bastion"
  vpc_id                = "${module.bastion_vpc.vpc_id}"
  default_tags          = "${map("Project", var.stackname)}"
  route_table_public_id = "${module.bastion_vpc.route_table_public_id}"
  subnet_cidrs          = "${var.bastion_public_subnet_cidrs}"
  internet_gateway_id   = "${module.bastion_vpc.internet_gateway_id}"
}

# EKS Cluster Public Subnet
module "k8_public_subnet" {
  source                = "../../modules/k8-network/public_subnet"
  component             = "k8-cluster"
  vpc_id                = "${module.vpc.vpc_id}"
  default_tags          = "${map("Project", var.stackname)}"
  route_table_public_id = "${module.vpc.route_table_public_id}"
  subnet_cidrs          = "${var.public_subnet_cidrs}"
  internet_gateway_id   = "${module.vpc.internet_gateway_id}"
}

# EKS Cluster NAT
module "k8_nat" {
  source = "../../modules/k8-network/nat"

  #subnet_ids        = "${matchkeys(values(module.k8_public_subnet.public_subnet_names_ids_map), keys(module.k8_public_subnet.public_subnet_names_ids_map), var.public_subnet_nat_gateway_enable)}"
  subnet_ids = "${module.k8_public_subnet.public_subnet_ids}"

  #subnet_ids_length = "${length(var.public_subnet_nat_gateway_enable)}"
  subnet_ids_length = "${length(var.public_subnet_cidrs)}"
}

# EKS Cluster Private Subnet
module "k8_private_subnet" {
  source              = "../../modules/k8-network/private_subnet"
  vpc_id              = "${module.vpc.vpc_id}"
  default_tags        = "${map("Project", var.stackname)}"
  subnet_cidrs        = "${var.private_subnet_cidrs}"
  subnet_nat_gateways = "${module.k8_nat.nat_gateway_ids}"
}

# EKS Bastion to Private Peer 
module "bastion_cluster_peer" {
  source             = "../../modules/k8-network/peering"
  target_vpc_id      = "${module.vpc.vpc_id}"
  source_vpc_id      = "${module.bastion_vpc.vpc_id}"
  peering_acceptance = true

  #  target_route_table    = "${module.vpc.route_table_public_id}"
  #  source_route_table    = "${module.bastion_vpc.route_table_public_id}"
  #  target_cidr           = "${module.vpc.vpc_cidr}"
  #  source_cidr           = "${module.bastion_vpc.vpc_cidr}"
  peering_connection_id = "${module.bastion_cluster_peer.peering_id}"
}

# Outputs
# --------------------------------------------------------------

output "k8_cluster_vpc_id" {
  value       = "${module.vpc.vpc_id}"
  description = "The ID of the k8-cluster VPC."
}

output "bastion_vpc_id" {
  value       = "${module.bastion_vpc.vpc_id}"
  description = "The ID of the Bastion VPC."
}

output "k8_cluster_public_subnet_ids" {
  value       = "${module.k8_public_subnet.public_subnet_ids}"
  description = "List containing the IDs of the created subnets."
}

output "bastion_public_subnet_ids" {
  value       = "${module.bastion_public_subnet.public_subnet_ids}"
  description = "List containing the IDs of the created subnets."
}

output "private_subnet_ids" {
  value       = "${module.k8_private_subnet.private_subnet_ids}"
  description = "List containing the IDs of the created subnets."
}

output "k8_cluster_vpc_cidr" {
  value       = "${module.vpc.vpc_cidr}"
  description = "The CIDR block of the k8-cluster VPC"
}

output "bastion_vpc_cidr" {
  value       = "${module.bastion_vpc.vpc_cidr}"
  description = "The CIDR block of the bastion VPC"
}

output "internet_gateway_id" {
  value       = "${module.vpc.internet_gateway_id}"
  description = "The ID of the Internet Gateway"
}

output "k8_cluster_route_table_public_id" {
  value       = "${module.vpc.route_table_public_id}"
  description = "The ID of the public routing table"
}

output "bastion_route_table_public_id" {
  value       = "${module.bastion_vpc.route_table_public_id}"
  description = "The ID of the bastion  public routing table"
}

output "bastion_cluster_peer_id" {
  value       = "${module.bastion_cluster_peer.peering_id}"
  description = "The Bastion to Cluster Peering ID."
}
