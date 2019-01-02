resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_network}"
  enable_dns_hostnames = "${var.dns}"

  tags = {
    Name = "${var.name}"
    Role = "${var.role}"
  }
}
