##########################################################################
/*
* K8 CLUSTER POLICY START
*/
##########################################################################

data "template_file" "k8_cluster_policy_template" {
  template = "${file("${path.module}/../../policies/k8-cluster-policy.tpl")}"
}

resource "aws_iam_policy" "k8_cluster_iam_policy" {
  name        = "k8_cluster_iam_policy"
  path        = "/"
  description = "Allow access to k8 cluster"
  policy      = "${data.template_file.k8_cluster_policy_template.rendered}"
}

##########################################################################
/*
* K8 CLUSTER POLICY END
*/
#########################################################################

##########################################################################
/*
* K8 SERVICE POLICY START
*/
##########################################################################

data "template_file" "k8_service_policy_template" {
  template = "${file("${path.module}/../../policies/k8-service-policy.tpl")}"
}

resource "aws_iam_policy" "k8_service_policy" {
  name        = "k8_service_iam_policy"
  path        = "/"
  description = "Allow access to k8 cluster services"
  policy      = "${data.template_file.k8_service_policy_template.rendered}"
}

##########################################################################
/*
* K8 CLUSTER POLICY END
*/
#########################################################################

resource "aws_iam_role" "k8-cluster-role" {
  name = "k8-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "k8-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.k8-cluster-role.name}"
}

resource "aws_iam_role_policy_attachment" "k8-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.k8-cluster-role.name}"
}
