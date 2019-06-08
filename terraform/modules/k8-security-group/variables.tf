variable "create_sg" {
  description = "Define whether to create the security group."
  default     = true
}

variable "create_ingress_rule" {
  description = "Define whether to create ingress security group rules."
  default     = false
}

variable "create_egress_rule" {
  description = "Define whether to create egress security group rules."
  default     = false
}

variable "sg_name" {
  description = "The security group name."
  type        = "string"
}

variable "sg_description" {
  description = "The security group description."
  type        = "string"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = "string"
}

variable "tags" {
  description = "Tags used."
  type        = "map"
  default     = {}
}

variable "sg_tag_name" {
  description = "Security group name used for tagging."
  type        = "string"
}

variable "egress_rules" {
  description = "A list of egress rule names."
  type        = "list"
  default     = []
}

variable "ingress_rules" {
  description = "A list of ingress rule names."
  type        = "list"
  default     = []
}

#variable "ingress_cidr_blocks" {
#  description = "CIDR Blocks in a list."
#  type        = "list"
#  default     = []
#}
#
#variable "egress_cidr_blocks" {
#  description = "CIDR Blocks in a list."
#  type        = "list"
#  default     = []
#}

variable "rules" {
  description = "A map consisting of all the rules"
  type        = "map"
}
