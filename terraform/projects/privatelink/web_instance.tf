module "green_web_nodes" {
  source                        = "../../modules/asg/privatelink"
  name                          = "green-web-instance"
  vpc_id                        = "${module.green_vpc.vpc_id}"
  default_tags                  = "${map("Project", "Privatelink", "aws_stackname", "green", "aws_environment", "dev")}"
  instance_subnet_ids           = "${module.green_subnet.subnet_id}"
  instance_security_group_ids   = ["${aws_security_group.green_management.id}", "${aws_security_group.green_web.id}"]
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  asg_max_size                  = "2"
  asg_min_size                  = "2"
  asg_desired_capacity          = "2"
}
