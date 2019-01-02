variable "subnet_cidrs" {
  type        = "map"
  description = "A map of the CIDRs for the subnets being created."
}

variable "subnet_availability_zones" {
  type        = "map"
  description = "A map of which AZs the subnets should be created in."
}

variable "vpc_id" {
  type        = "string"
  description = "The vpc ID"
}

variable "default_tags" {
  type        = "map"
  description = "Additional resource tags"
  default     = {}
}
