resource "aws_iam_role" "k8-cluster-node-iam-role" {
  name = "eks-k8-cluster-node-iam-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "k8-cluster-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.k8-cluster-node-iam-role.name}"
}

resource "aws_iam_role_policy_attachment" "k8-cluster-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.k8-cluster-node-iam-role.name}"
}

resource "aws_iam_role_policy_attachment" "k8-cluster-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.k8-cluster-node-iam-role.name}"
}

resource "aws_iam_instance_profile" "k8-cluster-node-profile" {
  name = "eks-k8-cluster-node-profile"
  role = "${aws_iam_role.k8-cluster-node-iam-role.name}"
}
