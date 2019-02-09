# variables
#
#--------------------------------------------------------------------

variable "instance_default_policy" {
  type        = "string"
  description = "Name of the JSON file containing the default IAM role policy for the instance"
  default     = "default_policy.json"
}

variable "name" {
  type        = "string"
  description = "Node suffix"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID"
}

variable "create_instance_key" {
  type        = "string"
  description = "Whether to create a key pair for the instance launch configuration"
  default     = false
}

variable "instance_key_name" {
  type        = "string"
  description = "Name of the instance key"
  default     = "sk-home"
}

variable "instance_public_key" {
  type        = "string"
  description = "The jumpbox default public key material"
  default     = ""
}

variable "instance_type" {
  type        = "string"
  description = "Instance type"
  default     = "t2.micro"
}

variable "instance_user_data" {
  type        = "string"
  description = "User_data provisioning script (default user_data.sh in module directory)"
  default     = "user_data.sh"
}

variable "instance_additional_user_data" {
  type        = "string"
  description = "Append additional user-data script"
  default     = ""
}

variable "instance_security_group_ids" {
  type        = "list"
  description = "List of security group ids to attach to the ASG"
}

variable "root_block_device_volume_size" {
  type        = "string"
  description = "The size of the instance root volume in gigabytes"
  default     = "10"
}

variable "instance_subnet_ids" {
  type        = "list"
  description = "List of subnet ids where the instance can be deployed"
}

variable "asg_availability_zones" {
  type        = "list"
  description = "List of availability zones for the auto scaling group."
  default     = ["eu-west-1a"]
}

variable "asg_desired_capacity" {
  type        = "string"
  description = "The autoscaling groups desired capacity"
  default     = "2"
}

variable "asg_max_size" {
  type        = "string"
  description = "The autoscaling groups max_size"
  default     = "2"
}

variable "asg_min_size" {
  type        = "string"
  description = "The autoscaling groups max_size"
  default     = "2"
}

variable "create_asg_notifications" {
  type        = "string"
  description = "Enable Autoscaling Group notifications"
  default     = true
}

variable "asg_notification_types" {
  type        = "list"
  description = "A list of Notification Types that trigger Autoscaling Group notifications. Acceptable values are documented in https://docs.aws.amazon.com/AutoScaling/latest/APIReference/API_NotificationConfiguration.html"

  default = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
  ]
}

variable "asg_notification_topic_arn" {
  type        = "string"
  description = "The Topic ARN for Autoscaling Group notifications to be sent to"
  default     = ""
}

variable "default_tags" {
  type        = "map"
  description = "Additional resource tags"
  default     = {}
}

# Resources
#
#--------------------------------------------------------------------

## Select AMI
data "aws_ami" "node_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

## Set role
resource "aws_iam_role" "node_iam_role" {
  name = "${var.name}"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

## Create an IAM role
resource "aws_iam_policy" "node_iam_policy_default" {
  name   = "${var.name}-default"
  path   = "/"
  policy = "${file("${path.module}/${var.instance_default_policy}")}"
}

## Link the default policy and role
resource "aws_iam_role_policy_attachment" "node_iam_role_policy_attachment_default" {
  role       = "${aws_iam_role.node_iam_role.name}"
  policy_arn = "${aws_iam_policy.node_iam_policy_default.arn}"
}

## Attach the role to the instance profile
resource "aws_iam_instance_profile" "node_instance_profile" {
  name = "${var.name}"
  role = "${aws_iam_role.node_iam_role.name}"
}

## SSH key to use
resource "aws_key_pair" "node_key" {
  count      = "${var.create_instance_key}"
  key_name   = "${var.instance_key_name}"
  public_key = "${var.instance_public_key}"
}

# Launch configuration
resource "aws_launch_configuration" "node_launch_configuration" {
  name_prefix   = "${var.name}-"
  image_id      = "${data.aws_ami.node_ami.id}"
  instance_type = "${var.instance_type}"
  user_data     = "${join("\n\n", list(file("${path.module}/${var.instance_user_data}"), var.instance_additional_user_data))}"

  security_groups = ["${var.instance_security_group_ids}"]

  iam_instance_profile        = "${aws_iam_instance_profile.node_instance_profile.name}"
  associate_public_ip_address = false
  key_name                    = "${var.instance_key_name}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "${var.root_block_device_volume_size}"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ASG Tags
resource "null_resource" "node_autoscaling_group_tags" {
  count = "${length(keys(var.default_tags))}"

  triggers {
    key                 = "${element(keys(var.default_tags), count.index)}"
    value               = "${element(values(var.default_tags), count.index)}"
    propagate_at_launch = true
  }
}

# ASG
resource "aws_autoscaling_group" "node_autoscaling_group" {
  name = "${var.name}"

  vpc_zone_identifier = [
    "${var.instance_subnet_ids}",
  ]

  availability_zones = ["${var.asg_availability_zones}"]

  desired_capacity          = "${var.asg_desired_capacity}"
  min_size                  = "${var.asg_min_size}"
  max_size                  = "${var.asg_max_size}"
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = "${aws_launch_configuration.node_launch_configuration.name}"

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  tags = ["${concat(
    list(map("key", "Name", "value", "${var.name}", "propagate_at_launch", true)),
    null_resource.node_autoscaling_group_tags.*.triggers)
  }"]

  lifecycle {
    create_before_destroy = true
  }
}
