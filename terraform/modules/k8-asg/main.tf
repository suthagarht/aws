# Variables
# ---------------------------------------------
variable "launch_config_name" {
  type        = "string"
  description = "Specify the launch config name."
}

variable "ami_id" {
  type        = "string"
  description = "Specify AWS AMI ID."
}

variable "instance_type" {
  type        = "string"
  description = "The AWS Instance type."
}

variable "security_groups" {
  type        = "list"
  description = "List of security groups for the instance."
  default     = []
}

variable "desired_capacity" {
  type        = "string"
  description = "The desired number of instances."
}

variable "max_size" {
  type        = "string"
  description = "The maximum number of instances."
}

variable "min_size" {
  type        = "string"
  description = "The minimum number of instances."
}

variable "asg_name" {
  type        = "string"
  description = "The autoscaling group name."
}

variable "asg_subnets" {
  type        = "list"
  description = "The subnets where the ASG is located."
}

variable "key_name" {
  type        = "string"
  description = "The SSH key name"
}

# Resources
# ---------------------------------------------

# Autoscaling
resource "aws_autoscaling_group" "asg" {
  desired_capacity     = "${var.desired_capacity}"
  launch_configuration = "${aws_launch_configuration.launch_config.id}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  name                 = "${var.asg_name}"
  vpc_zone_identifier  = ["${var.asg_subnets}"]

  tag {
    key                 = "Name"
    value               = "${var.asg_name}"
    propagate_at_launch = true
  }
}

# Launch Config
resource "aws_launch_configuration" "launch_config" {
  name                        = "${var.launch_config_name}"
  image_id                    = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  security_groups             = ["${var.security_groups}"]
  key_name                    = "${var.key_name}"
  associate_public_ip_address = "false"
}

# Output
# ---------------------------------------------

output "launch_config_id" {
  value       = "${aws_launch_configuration.launch_config.id}"
  description = "Launch config ID"
}

output "launch_config_name" {
  value       = "${aws_launch_configuration.launch_config.name}"
  description = "Launch config Name"
}
