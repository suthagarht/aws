data "terraform_remote_state" "dynamodb_remote_state" {
  backend = "s3"

  config {
    bucket = "skaws-terraform-state-${var.environment}"
    key    = "dynamodb/jenkins.tfstate"
    region = "eu-west-2"
  }
}
