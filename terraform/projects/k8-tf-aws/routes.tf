# Route from Bastion VPC to Cluster VPC
resource "aws_route" "route_from_bastion_to_cluster" {
  route_table_id            = "${module.bastion_vpc.route_table_public_id}"
  destination_cidr_block    = "${module.vpc.vpc_cidr}"                      # Set a route to the cluster from bastion
  vpc_peering_connection_id = "${module.bastion_cluster_peer.peering_id}"
}

# Route from Cluster VPC to Bastion VPC
resource "aws_route" "route_from_cluster_to_bastion" {
  route_table_id            = "${module.vpc.route_table_public_id}"
  destination_cidr_block    = "${module.bastion_vpc.vpc_cidr}"            # Set a route to the bastion from cluster
  vpc_peering_connection_id = "${module.bastion_cluster_peer.peering_id}"
}

# EKS Bastion to Cluster Nodes Routes
resource "aws_route" "bastion_to_cluster_node_routes" {
  count                     = "${length(var.private_subnet_cidrs)}"
  route_table_id            = "${element(module.bastion_public_subnet.public_subnet_route_table_ids, 0)}"
  destination_cidr_block    = "${element(var.private_subnet_cidrs, count.index)}"
  vpc_peering_connection_id = "${module.bastion_cluster_peer.peering_id}"
  depends_on                = ["module.bastion_cluster_peer"]
}

# EKC Cluster Node to Bastion Routes
resource "aws_route" "cluster_node_to_bastion_routes" {
  count                     = "${length(var.private_subnet_cidrs)}"
  route_table_id            = "${element(module.k8_private_subnet.private_subnet_route_table_ids, count.index)}"
  destination_cidr_block    = "${element(var.bastion_public_subnet_cidrs, 0)}"
  vpc_peering_connection_id = "${module.bastion_cluster_peer.peering_id}"
  depends_on                = ["module.bastion_cluster_peer"]
}
