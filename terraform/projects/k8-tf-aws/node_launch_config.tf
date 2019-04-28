# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_region" "current" {}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  k8-cluster-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace

hostname = $(curl http://169.254.169.254/latest/meta-data/hostname)

cat << EOF > /root/config_map_aws_auth.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.k8-cluster-node-iam-role.arn}
      username: system:node:"$${hostname}"
      groups:
        - system:bootstrappers
        - system:nodes

EOF

/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.k8-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.k8-cluster.certificate_authority.0.data}' '${var.cluster_name}'

kubectl apply -f /root/config_map_aws_auth.yaml

USERDATA
}

resource "aws_launch_configuration" "k8-cluster-node-lc" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.k8-cluster-node-profile.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "m4.large"
  name_prefix                 = "k8-cluster-node"
  key_name                    = "${var.key_name}"

  #security_groups             = ["${aws_security_group.k8-cluster-node-security-group.*.id}"]
  security_groups = ["${data.terraform_remote_state.infra_vpc.node_sg_ids}"]

  #  user_data_base64 = "${base64encode(local.k8-cluster-node-userdata)}"
  user_data = "${local.k8-cluster-node-userdata}"

  lifecycle {
    create_before_destroy = true
  }
}
