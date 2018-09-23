variable "name" {
  type        = "string"
  description = "A name tag for the VPC"
}

variable "role" {
  type        = "string"
  description = "A role tag for the VPC"
}

variable "environment" {
  description = "This variable states the environment name."
  type        = "string"
}

variable "vpc_network" {
  description = "This variable states the Jenkins VPC network CIDR block."
  type        = "string"
}

variable "dns" {
  description = "This variable states whether to enable or disable host DNS."
  type        = "string"
  default     = "true"
}
