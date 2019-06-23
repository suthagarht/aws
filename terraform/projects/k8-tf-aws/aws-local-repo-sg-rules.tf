resource "aws_security_group" "aws-repo-sg" {
  name   = "aws-repo-sg"
  vpc_id = "${data.terraform_remote_state.infra_vpc.k8_cluster_vpc_id}"

  egress {
    from_port   = "0"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws-repo-sg"
  }
}

## The below works however. There is an ever changing list
## Also we will make the nodes priivate
#resource "aws_security_group" "aws-repo-sg" {
#  name   = "aws-repo-sg"
#  vpc_id = "${data.terraform_remote_state.infra_vpc.k8_cluster_vpc_id}"
#
#  egress {
#    from_port   = "0"
#    to_port     = "80"
#    protocol    = "tcp"
#    cidr_blocks = ["${data.aws_ip_ranges.aws_repo_cidr.cidr_blocks}"]
#  }
#
#  tags = {
#    CreateDate = "${data.aws_ip_ranges.aws_repo_cidr.create_date}"
#    SyncToken  = "${data.aws_ip_ranges.aws_repo_cidr.sync_token}"
#    Name       = "aws-repo-sg"
#  }
#}
#
#resource "aws_security_group" "aws-ec2-cidr-sg" {
#  name   = "aws-ec2-cidr-sg"
#  vpc_id = "${data.terraform_remote_state.infra_vpc.k8_cluster_vpc_id}"
#
#  egress {
#    from_port   = "0"
#    to_port     = "443"
#    protocol    = "tcp"
#    cidr_blocks = ["${data.aws_ip_ranges.aws_ec2_cidr.cidr_blocks}"]
#  }
#
#  tags = {
#    CreateDate = "${data.aws_ip_ranges.aws_ec2_cidr.create_date}"
#    SyncToken  = "${data.aws_ip_ranges.aws_ec2_cidr.sync_token}"
#    Name       = "aws-ec2-cidr-sg"
#  }
#}
#
#resource "aws_security_group" "aws-ec2-endpoint-sg" {
#  name   = "aws-ec2-endpoint-sg"
#  vpc_id = "${data.terraform_remote_state.infra_vpc.k8_cluster_vpc_id}"
#
#  egress {
#    from_port   = "0"
#    to_port     = "443"
#    protocol    = "tcp"
#    cidr_blocks = ["${format("%s/32",data.external.aws-ec2-endpoint.result.query)}"]
#  }
#
#  tags = {
#    Name = "aws-ec2-endpoint-sg"
#  }
#}

