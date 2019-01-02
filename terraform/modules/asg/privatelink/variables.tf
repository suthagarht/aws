variable "name" {
  type        = "string"
  description = "A name tag for the VPC"
}

variable "role" {
  type        = "string"
  description = "A role tag for the VPC"
}

variable "vpc_network" {
  description = "This variable states the Jenkins VPC network CIDR block."
  type        = "string"
}

variable "dns" {
  description = "This variable states whether to enable or disable host DNS."
  type        = "string"
}
