##################################################
/*
* Provide the remote station access to
* eks
*/
###################################################

resource "aws_security_group" "k8-cluster-sg" {
  name        = "k8-eks-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = ["module.vpc"]

  tags = {
    Name = "k8-cluster-sg"
  }
}

# OPTIONAL: Allow inbound traffic from your local workstation external IP
#           to the Kubernetes. You will need to replace A.B.C.D below with
#           your real IP. Services like icanhazip.com can help you find this.
resource "aws_security_group_rule" "k8-cluster-ingress-workstation-https" {
  cidr_blocks       = ["${format("%s/32",data.external.myipaddr.result.ip)}"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.k8-cluster-sg.id}"
  to_port           = 443
  type              = "ingress"
}

############################################################
/*
*                END REMOTE ACCESS
*/
############################################################


############################################################
/*
*                OUTPUTS
*/
############################################################

output "cluster-sg-id" {
  value       = "${aws_security_group.k8-cluster-sg.id}"
  description = " The ID of the security group"
}

output "cluster-sg-arn" {
  value       = "${aws_security_group.k8-cluster-sg.arn}"
  description = "The ARN of the security group"
}

output "cluster-sg-vpc-id" {
  value       = "${aws_security_group.k8-cluster-sg.vpc_id}"
  description = " The VPC ID."
}

output "cluster-sg-name" {
  value       = "${aws_security_group.k8-cluster-sg.name}"
  description = " The name of the security group"
}

output "cluster-sg-ingress" {
  value       = "${aws_security_group.k8-cluster-sg.ingress}"
  description = " The ingress rules"
}

output "cluster-sg-egress" {
  value       = "${aws_security_group.k8-cluster-sg.egress}"
  description = " The egress rules"
}
