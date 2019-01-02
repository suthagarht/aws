data "terraform_remote_state" "jenkins_remote_state" {
  backend = "s3"

  config {
    bucket = "skaws-terraform-state-${var.environment}"
    key    = "privatelink/privatelink.tfstate"
    region = "eu-west-2"
  }
}
