output "subnet_ids" {
  value       = ["${aws_subnet.subnet.*.id}"]
  description = "List containing the IDs of the created subnets."
}
