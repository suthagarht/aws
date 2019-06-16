resource "aws_eks_cluster" "k8-cluster" {
  name     = "${var.cluster_name}"
  role_arn = "${aws_iam_role.k8-cluster-role.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.k8-cluster-sg.id}"]
    subnet_ids         = ["${data.terraform_remote_state.infra_vpc.public_subnet_ids}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.k8-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.k8-cluster-AmazonEKSServicePolicy",
  ]
}
