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

variable "vpc_cidr" {
  type        = "string"
  description = "VPC IP address range, represented as a CIDR block"
}

variable "remote_state_bucket" {
  type        = "string"
  description = "S3 bucket we store our terraform state in"
}

variable "public_subnet_cidrs" {
  type        = "list"
  description = "List containing public subnet names and CIDR associated"
}
