# Variables
#--------------------------------------------------------------

variable "target_vpc_id" {
  type        = "string"
  description = "Specify the VPC ID for which the connection is being made."
}

variable "source_vpc_id" {
  type        = "string"
  description = "Specify the VPC ID from which the request is being made."
}

variable "peering_acceptance" {
  description = "Specify how to accept the connection."
  default     = true
}

variable "target_route_table" {
  type        = "string"
  description = "The route table ID at the target VPC."
}

variable "target_cidr" {
  type        = "string"
  description = "The CIDR of the target VPC."
}

variable "peering_connection_id" {
  type        = "string"
  description = "The peering connection ID."
}

variable "source_route_table" {
  type        = "string"
  description = "The route table ID at the source VPC."
}

variable "source_cidr" {
  type        = "string"
  description = "The CIDR of the source VPC."
}

# Resources
#--------------------------------------------------------------
# VPC Peering connection
resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id = "${var.target_vpc_id}"
  vpc_id      = "${var.source_vpc_id}"
  auto_accept = "${var.peering_acceptance}"
}

# Add routes at the target after creating a peering connection
resource "aws_route" "target_route" {
  route_table_id            = "${var.target_route_table}"
  destination_cidr_block    = "${var.source_cidr}"           # Set a route to source in the target
  vpc_peering_connection_id = "${var.peering_connection_id}"
}

# Add routes at the source VPC
resource "aws_route" "source_route" {
  route_table_id            = "${var.source_route_table}"
  destination_cidr_block    = "${var.target_cidr}"           # Set a route to target in source
  vpc_peering_connection_id = "${var.peering_connection_id}"
}

# Output
#--------------------------------------------------------------

output "peering_id" {
  value       = "${aws_vpc_peering_connection.peering.id}"
  description = "The Peering connection ID."
}
