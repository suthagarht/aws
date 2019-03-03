data "terraform_remote_state" "infra_vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "k8-tf-aws/k8-tf-aws-vpc.tfstate"
    region = "${var.aws_region}"
  }
}
