#
# SSH Access
# -------------------------------------------------------------------

resource "aws_security_group" "green_management" {
  name        = "management_access"
  vpc_id      = "${module.green_vpc.vpc_id}"
  description = "Group used to allow SSH access"

  tags {
    Name = "green VPC management_access SG"
  }
}

resource "aws_security_group_rule" "green_management_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["86.11.193.129/32"]

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.green_management.id}"
}

resource "aws_security_group" "blue_management" {
  name        = "management_access"
  vpc_id      = "${module.blue_vpc.vpc_id}"
  description = "Group used to allow SSH access"

  tags {
    Name = "blue VPC management_access SG"
  }
}

resource "aws_security_group_rule" "blue_management_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["86.11.193.129/32"]

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.blue_management.id}"
}

#
# HTTP Access
#
# -----------------------------------------------------------------------

resource "aws_security_group" "green_web" {
  name        = "web_access"
  vpc_id      = "${module.green_vpc.vpc_id}"
  description = "Group used to allow http access"

  tags {
    Name = "green VPC web_access SG"
  }
}

resource "aws_security_group_rule" "green_ingress_http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  protocol    = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.green_web.id}"
}

resource "aws_security_group" "blue_web" {
  name        = "web_access"
  vpc_id      = "${module.blue_vpc.vpc_id}"
  description = "Group used to allow http access"

  tags {
    Name = "blue VPC web_access SG"
  }
}

resource "aws_security_group_rule" "blue_ingress_http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
  protocol    = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.blue_web.id}"
}

#
# Output SSH SG IDs
# -------------------------------------------------------------------------

output "sg_green_management_id" {
  value = "${aws_security_group.green_management.id}"
}

output "sg_blue_management_id" {
  value = "${aws_security_group.blue_management.id}"
}

output "sg_green_web_id" {
  value = "${aws_security_group.green_web.id}"
}

output "sg_blue_web_id" {
  value = "${aws_security_group.blue_web.id}"
}
