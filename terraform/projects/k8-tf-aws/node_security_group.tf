module "k8-cluster-node-sg" {
  source              = "../../modules/k8-security-group"
  sg_name             = "k8-cluster-node-security-group"
  sg_description      = "Security Group for all nodes in the cluster."
  sg_tag_name         = "K8_Node_SG"
  vpc_id              = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  create_sg           = true
  create_ingress_rule = true
  create_egress_rule  = false

  ingress_rules = [
    "k8-cluster-node-ingress-self",
    "k8-cluster-node-ingress-cluster",
  ]

  rules = {
    k8-cluster-node-ingress-self    = [0, 65535, "all", "k8-cluster-node-ingress-self", "0.0.0.0/0"]
    k8-cluster-node-ingress-cluster = [1025, 65535, "tcp", "k8-cluster-node-ingress-cluster", "0.0.0.0/0"]
  }

  tags = {
    Env = "Dev"
  }
}

output "node_sg_ids" {
  value       = "${module.k8-cluster-node-sg.sg_ids}"
  description = "k8 cluster node SG IDs"
}
