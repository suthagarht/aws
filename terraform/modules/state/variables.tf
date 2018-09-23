# the role that will be used to access the tf remote state
# variable "role" {}

# the module that will be using this remote state
variable "module" {}

# tags
variable "tags" {
  type = "map"
}
