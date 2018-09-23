provider "aws" {
  region = "eu-west-2"
}

module "jenkins_tf_remote_state" {
  source = "tf_state_bucket"
  module = "jenkins"
  tags   = "${map("team", "my-team", "contact-email", "my-team@my-company.com", "application", "my-app", "environment", "dev", "customer", "my-customer")}"
}

output "bucket" {
  value = "${module.tf_remote_state.bucket}"
}
