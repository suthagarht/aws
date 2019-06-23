### IAM Policy
#-------------------------------------------------------------------------------------------------

## Template file
data "template_file" "policy_template" {
  template = "${file("${path.module}/../../policies/k8-cluster-polict.tpl")}"
}

resource "aws_iam_role" "eks-iam-role" {
  name               = "k8-cluster"
  assume_role_policy = "${dta.template_file.policy_template.rendered}"
}

resource "aws_iam_role_policy_attachment" "eks-k8-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks-iam-role.name}"
}

resource "aws_iam_role_policy_attachment" "eks-k8-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eks-iam-role.name}"
}
