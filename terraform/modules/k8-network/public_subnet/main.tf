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

variable "route_table_public_id" {
  type        = "string"
  description = "The ID of the route table in the VPC"
}

variable "subnet_cidrs" {
  type        = "list"
  description = "A list of the CIDRs for the subnets being created."
}

# Resources
#--------------------------------------------------------------

# Declare the data source
data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count  = "${length(var.subnet_cidrs)}"
  vpc_id = "${var.vpc_id}"

  cidr_block        = "${element(var.subnet_cidrs, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  #tags = "${merge(var.default_tags, map("Name", element(var.subnet_cidrs, count.index)))}"
  tags = "${merge(var.default_tags, map("Name", format("k8-subnet-%s", data.aws_availability_zones.available.names[count.index])))}"

  lifecycle {
    create_before_destroy = true
  }

  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.subnet_cidrs)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${var.route_table_public_id}"
}

# Outputs
#--------------------------------------------------------------

output "public_subnet_ids" {
  value       = ["${aws_subnet.public.*.id}"]
  description = "List containing the IDs of the created subnets."
}

output "public_subnet_names_ids_map" {
  value       = "${zipmap(aws_subnet.public.*.tags.Name, aws_subnet.public.*.id)}"
  description = "Map containing the pair name-id for each subnet created."
}

output "public_subnet_names" {
  value       = ["${aws_subnet.public.*.tags.Name}"]
  description = "List containing public subnet names."
}
