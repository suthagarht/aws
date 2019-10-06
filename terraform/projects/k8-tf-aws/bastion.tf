# Bastion Security Group
module "k8-cluster-bastion-sg" {
  source              = "../../modules/k8-security-group"
  sg_name             = "k8-cluster-bastion-security-group"
  sg_description      = "Bastion Scurity Group."
  sg_tag_name         = "K8_Bastion_SG"
  vpc_id              = "${data.terraform_remote_state.infra_vpc.bastion_vpc_id}"
  create_sg           = true
  create_ingress_rule = true
  create_egress_rule  = true

  ingress_rules = [
    "k8-cluster-bastion-incoming-ssh",
  ]

  egress_rules = [
    "bastion-to-eks-nodes-ssh",
  ]

  rules = {
    k8-cluster-bastion-incoming-ssh = [22, 22, "tcp", "k8-cluster-bastion-incoming", "${format("%s/32",data.external.myipaddr.result.ip)}"]
    bastion-to-eks-nodes-ssh        = [22, 22, "tcp", "bastion-to-eks-nodes-ssh", "${var.vpc_cidr}"]
  }

  tags = {
    Env = "Dev"
  }
}

module "k8-cluster-bastion-asg" {
  source             = "../../modules/k8-asg"
  asg_name           = "k8-bastion-asg"
  desired_capacity   = "1"
  max_size           = "1"
  min_size           = "1"
  asg_subnets        = "${data.terraform_remote_state.infra_vpc.bastion_public_subnet_ids}"
  launch_config_name = "k8-bastion-lc"
  ami_id             = "${data.aws_ami.latest_aws_ami.id}"
  instance_type      = "t2.micro"
  key_name           = "${var.key_name}"
  security_groups    = "${module.k8-cluster-bastion-sg.sg_ids}"
}
