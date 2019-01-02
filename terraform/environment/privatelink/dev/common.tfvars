environment = "dev"
dns = "true"
role = "ci"

dmz_vpc_network = "10.0.0.0/16"
blue_vpc_network = "10.100.0.0/16"
green_vpc_network = "10.200.0.0/16"

dmz_vpc_name = "dmz_vpc"
blue_vpc_name = "blue_vpc"
green_vpc_name = "green_vpc"


dmz_subnet_cidrs = {
  "dmz_subnet_a" = "10.0.1.0/24"
  "dmz_subnet_b" = "10.0.2.0/24"
}

blue_subnet_cidrs = {
  "blue_subnet_a" = "10.100.1.0/24"
  "blue_subnet_b" = "10.100.2.0/24"
}

green_subnet_cidrs = {
  "green_subnet_a" = "10.200.1.0/24"
  "green_subnet_b" = "10.200.2.0/24"
}

dmz_subnet_availability_zones = {
  "dmz_subnet_a" = "eu-west-1a"
  "dmz_subnet_b" = "eu-west-1a"
}

blue_subnet_availability_zones = {
  "blue_subnet_a" = "eu-west-1a"
  "blue_subnet_b" = "eu-west-1a"
}

green_subnet_availability_zones = {
  "green_subnet_a" = "eu-west-1a"
  "green_subnet_b" = "eu-west-1a"
}
