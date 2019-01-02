variable "dmz_vpc_name" {
  type        = "string"
  description = "A name tag for the DMZ VPC"
}

variable "blue_vpc_name" {
  type        = "string"
  description = "A name tag for the Blue VPC"
}

variable "green_vpc_name" {
  type        = "string"
  description = "A name tag for the Green VPC"
}

variable "role" {
  type        = "string"
  description = "A role tag for the VPC"
}

variable "environment" {
  description = "This variable states the environment name."
  type        = "string"
}

variable "dmz_vpc_network" {
  description = "This variable states the DMZ VPC network CIDR block."
  type        = "string"
}

variable "blue_vpc_network" {
  description = "This variable states the Blue VPC network CIDR block."
  type        = "string"
}

variable "green_vpc_network" {
  description = "This variable states the Green VPC network CIDR block."
  type        = "string"
}                                                                     

variable "dns" {
  description = "This variable states whether to enable or disable host DNS."
  type        = "string"
  default     = "true"
}
