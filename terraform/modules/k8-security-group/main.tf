##########################################
/*
*         SECURITY GROUP MODULE
*/
##########################################

##########################################
/*
*   Get ID of created Security Group
*/
##########################################
# Not needed but classy
#locals {
#  sg_id = "${element(concat(coalescelist(aws_security_group.sg.*.id, aws_security_group.sg_prefix.*.id), list("")), 0)}"
#}

##########################################
/* 
*   SECURITY GROUP - START
*/
##########################################

resource "aws_security_group" "sg" {
  count = "${var.create_sg ? 1 : 0}"

  name        = "${var.sg_name}"
  description = "${var.sg_description}"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", format("%s", var.sg_tag_name)))}"
}

##########################################
/*
*   SECURITY GROUP - END
*/
##########################################

##########################################
/*
*   SECURITY GROUP INGRESS RULE - START
*/
##########################################

resource "aws_security_group_rule" "sg_ingress_rule" {
  count = "${var.create_ingress_rule ? length(var.ingress_rules) : 0 }"

  security_group_id = "${aws_security_group.sg.id}"
  type              = "ingress"

  cidr_blocks = ["${var.ingress_cidr_blocks}"]
  description = "${element(var.rules[var.ingress_rules[count.index]], 3)}"

  from_port = "${element(var.rules[var.ingress_rules[count.index]], 0)}"
  to_port   = "${element(var.rules[var.ingress_rules[count.index]], 1)}"
  protocol  = "${element(var.rules[var.ingress_rules[count.index]], 2)}"
}

##########################################
/*
*   SECURITY GROUP INGRESS RULE - END
*/
##########################################

##########################################
/*
*   SECURITY GROUP EGRESS RULE - START
*/
##########################################

resource "aws_security_group_rule" "sg_egress_rule" {
  count = "${var.create_egress_rule ? length(var.egress_rules) : 0 }"

  security_group_id = "${aws_security_group.sg.id}"
  type              = "egress"

  cidr_blocks = ["${var.egress_cidr_blocks}"]
  description = "${element(var.rules[var.egress_rules[count.index]], 3)}"

  from_port = "${element(var.rules[var.egress_rules[count.index]], 0)}"
  to_port   = "${element(var.rules[var.egress_rules[count.index]], 1)}"
  protocol  = "${element(var.rules[var.egress_rules[count.index]], 2)}"
}

##########################################
/*
*   SECURITY GROUP EGRESS RULE - END
*/
##########################################

