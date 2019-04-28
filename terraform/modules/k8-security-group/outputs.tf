output "sg_ids" {
  description = "The security group IDs."
  value       = "${aws_security_group.sg.*.id}"
}

output "sg_vpc_id" {
  description = "The security group ID."
  value       = "${aws_security_group.sg.*.vpc_id}"
}
