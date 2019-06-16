/**
* ## Modules: k8-network/public_subnet
*
* This module creates all resources necessary for an AWS public
* subnet.
*
* Subnet CIDR and AZ are specified in the maps `subnet_cidrs` and
* `subnet_availability_zones`, where the key is the name of the
* subnet and must be the same in both maps.
*
* For instance, to create two public subnets named "my_subnet_a"
* and "my_subnet_b" on eu-west-1a and eu-west-1b, you can do:
*
*```
* subnet_cidrs = {
*   "my_subnet_a" = "10.0.0.0/24"
*   "my_subnet_b" = "10.0.1.0/24"
* }
*
* subnet_availability_zones = {
*   "my_subnet_a" = "eu-west-1a"
*   "my_subnet_b" = "eu-west-1b"
* }
*```
*/

variable "default_tags" {
  type        = "map"
  description = "Additional resource tags"
  default     = {}
}

variable "vpc_id" {
  type        = "string"
  description = "The ID of the VPC in which the public subnet is created."
}

variable "subnet_cidrs" {
  type        = "list"
  description = "A list of the CIDRs for the subnets being created."
}

variable "subnet_nat_gateways" {
  type        = "list"
  description = "A list containing the NAT gateway IDs."
}

#variable "subnet_nat_gateways_length" {
#  type        = "string"
#  description = "Provide the number of elements in the map subnet_nat_gateways."
#  default     = "0"
#}

# Resources
#--------------------------------------------------------------

# Declare the data source
data "aws_availability_zones" "available" {}

resource "aws_subnet" "private" {
  count  = "${length(var.subnet_cidrs)}"
  vpc_id = "${var.vpc_id}"

  cidr_block        = "${element(var.subnet_cidrs, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"


  #tags = "${merge(var.default_tags, map("Name", element(var.subnet_cidrs, count.index)))}"
  tags = "${merge(var.default_tags, map("Name", format("k8-private-subnet-%s", data.aws_availability_zones.available.names[count.index])))}"

  lifecycle {
    create_before_destroy = true
  }

  map_public_ip_on_launch = false
}

# Routing table
resource "aws_route_table" "private" {
  count  = "${length(var.subnet_cidrs)}"
  vpc_id = "${var.vpc_id}"

  tags = "${merge(var.default_tags, map("Name", format("k8-private-subnet-%s", data.aws_availability_zones.available.names[count.index])))}"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route_table_association" "private" {
  count          = "${length(var.subnet_cidrs)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}


# NAT
resource "aws_route" "nat" {
  count                  = "${length(var.subnet_cidrs)}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(var.subnet_nat_gateways, count.index)}"
}


# Outputs
#--------------------------------------------------------------

output "private_subnet_ids" {
  value       = ["${aws_subnet.private.*.id}"]
  description = "List of private subnet IDs"
}

output "private_subnet_names_ids_map" {
  value       = "${zipmap(aws_subnet.private.*.tags.Name, aws_subnet.private.*.id)}"
  description = "Map containing the name of each subnet created and ID associated"
}

output "private_subnet_route_table_ids" {
  value       = ["${aws_route_table.private.*.id}"]
  description = "List of route_table IDs"
}

output "private_subnet_names_route_tables_map" {
  value       = "${zipmap(aws_route_table.private.*.tags.Name, aws_route_table.private.*.id)}"
  description = "Map containing the name of each subnet and route_table ID associated"
}
