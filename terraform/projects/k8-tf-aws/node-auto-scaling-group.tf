resource "aws_autoscaling_group" "k8-cluster-asg" {
  desired_capacity     = 2
  launch_configuration = "${aws_launch_configuration.k8-cluster-node-lc.id}"
  max_size             = 2
  min_size             = 1
  name                 = "k8-cluster-node-asg"
  vpc_zone_identifier  = ["${data.terraform_remote_state.infra_vpc.subnet_ids}"]

  tag {
    key                 = "Name"
    value               = "k8-cluster-node-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
