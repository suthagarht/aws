### The EKS Cluster
-----------------------------------------------------------------------------------------------------

resource "aws_eks_cluster" "demo" {
  name            = "${var.cluster-name}"
  role_arn        = "${aws_iam_role.eks-iam-role.arn}"

    vpc_config {
    subnet_ids = ["${aws_subnet.default.*.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eks-k8-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.eks-k8-AmazonEKSServicePolicy",
  ]
}
