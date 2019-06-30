# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_region" "current" {}

# # EKS currently documents this required userdata for EKS worker nodes to
# # properly configure Kubernetes applications on the EC2 instance.
# # We utilize a Terraform local here to simplify Base64 encoding this
# # information into the AutoScaling Launch Configuration.
# # More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
# locals {
#   k8-cluster-node-userdata = <<USERDATA
# #!/bin/bash
# set -o xtrace
# 
# hostname = $(curl http://169.254.169.254/latest/meta-data/hostname)
# 
# cat << EOF > /root/config_map_aws_auth.yaml
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   name: aws-auth
#   namespace: kube-system
# data:
#   mapRoles: |
#     - rolearn: ${aws_iam_role.k8-cluster-node-iam-role.arn}
#       username: system:node:"{{EC2PrivateDNSName}}"
#       groups:
#         - system:bootstrappers
#         - system:nodes
# 
# EOF
# 
# 
# USERDATA
# }

resource "aws_launch_configuration" "k8-cluster-node-lc" {
  associate_public_ip_address = false
  iam_instance_profile        = "${aws_iam_instance_profile.k8-cluster-node-profile.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "m4.large"
  name_prefix                 = "k8-cluster-node"
  key_name                    = "${var.key_name}"

  #security_groups             = ["${aws_security_group.k8-cluster-node-security-group.*.id}"]
  security_groups = [
    "${data.terraform_remote_state.infra_vpc.node_sg_ids}",
    "${aws_security_group.aws-repo-sg.id}",
  ]

  #"${aws_security_group.aws-ec2-cidr-sg.id}",
  #"${aws_security_group.aws-ec2-endpoint-sg.id}",

  #  user_data_base64 = "${base64encode(local.k8-cluster-node-userdata)}"
  # user_data = "${local.k8-cluster-node-userdata}"
  user_data_base64 = "${base64encode(join("", data.template_file.userdata.*.rendered))}"
  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.tpl")}"

  vars {
    cluster_endpoint           = "${aws_eks_cluster.k8-cluster.endpoint}"
    certificate_authority_data = "${aws_eks_cluster.k8-cluster.certificate_authority.0.data}"
    cluster_name               = "${var.cluster_name}"
    bootstrap_extra_args       = "${var.bootstrap_extra_args}"
  }
}

data "template_file" "config_map_aws_auth" {
  template = "${file("${path.module}/config_map_aws_auth.tpl")}"

  vars {
    aws_iam_role_arn = "${aws_iam_role.k8-cluster-node-iam-role.arn}"
  }
}
