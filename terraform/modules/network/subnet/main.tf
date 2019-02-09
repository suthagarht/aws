resource "aws_subnet" "subnet" {
  count             = "${length(keys(var.subnet_cidrs))}"
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${element(values(var.subnet_cidrs), count.index)}"
  availability_zone = "${lookup(var.subnet_availability_zones, element(keys(var.subnet_cidrs), count.index))}"

  tags = "${merge(var.default_tags, map("Name", element(keys(var.subnet_cidrs), count.index)))}"

  lifecycle {
    create_before_destroy = true
  }
}
