variable "dmz_subnet_cidrs" {
  type        = "map"
  description = "dmz subnet cidrs"
}

variable "blue_subnet_cidrs" {
  type        = "map"
  description = "blue subnet cidrs"
}

variable "green_subnet_cidrs" {
  type        = "map"
  description = "green subnet cidrs"
}

variable "dmz_subnet_availability_zones" {
  type        = "map"
  description = "dmz subnet az"
}

variable "blue_subnet_availability_zones" {
  type        = "map"
  description = "blue subnet az"
}

variable "green_subnet_availability_zones" {
  type        = "map"
  description = "green subnet az"
}
