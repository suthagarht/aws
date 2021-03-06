provider "aws" {
  region = "${var.aws_region}"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
  default     = ""
}

variable "vpc_name" {
  type        = "string"
  description = "A name tag for the VPC"
}

variable "bastion_vpc_name" {
  type        = "string"
  description = "A name tag for the Bastion VPC"
}

variable "key_name" {
  type        = "string"
  description = "The SSH ket pair name"
}

variable "cluster_name" {
  type        = "string"
  description = "The EKS Cluster name"
}

variable "vpc_cidr" {
  type        = "string"
  description = "VPC IP address range, represented as a CIDR block"
}

variable "bastion_vpc_cidr" {
  type        = "string"
  description = "Bastion VPC IP address range, represented as a CIDR block"
}

variable "remote_state_bucket" {
  type        = "string"
  description = "S3 bucket we store our terraform state in"
}

variable "public_subnet_cidrs" {
  type        = "list"
  description = "List containing public subnet names and CIDR associated"
}

variable "bastion_public_subnet_cidrs" {
  type        = "list"
  description = "List containing bastion public subnet names and CIDR associated"
}

variable "private_subnet_cidrs" {
  type        = "list"
  description = "List containing private subnet names and CIDR associated"
}

variable "bootstrap_extra_args" {
  type    = "string"
  default = ""
}

#variable "public_subnet_nat_gateway_enable" {
#  type        = "list"
#  description = "List of public subnet names where we want to create a NAT Gateway"
#}

