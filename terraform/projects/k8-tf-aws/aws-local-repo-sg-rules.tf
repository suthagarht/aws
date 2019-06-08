resource "aws_security_group" "aws-repo-sg" {
  name   = "aws-repo-sg"
  vpc_id = "${data.terraform_remote_state.infra_vpc.vpc_id}"

  egress {
    from_port   = "0"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_ip_ranges.aws_repo_cidr.cidr_blocks}"]
  }

  tags = {
    CreateDate = "${data.aws_ip_ranges.aws_repo_cidr.create_date}"
    SyncToken  = "${data.aws_ip_ranges.aws_repo_cidr.sync_token}"
    Name       = "aws-repo-sg"
  }
}

resource "aws_security_group" "aws-ec2-cidr-sg" {
  name   = "aws-ec2-cidr-sg"
  vpc_id = "${data.terraform_remote_state.infra_vpc.vpc_id}"

  egress {
    from_port   = "0"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_ip_ranges.aws_ec2_cidr.cidr_blocks}"]
  }

  tags = {
    CreateDate = "${data.aws_ip_ranges.aws_ec2_cidr.create_date}"
    SyncToken  = "${data.aws_ip_ranges.aws_ec2_cidr.sync_token}"
    Name       = "aws-ec2-cidr-sg"
  }
}
