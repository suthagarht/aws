data "aws_ami" "web_ami" {
  most_recent      = true

  filter {
    name   = "platform"
    values = ["Amazon Linux"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }


  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
