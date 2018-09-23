/**
 * A Terraform module that configures an s3 bucket for use with Terraform's remote state feature.
 *
 * Useful for creating a common bucket naming convention and attaching a bucket policy using the specified role.
 */

# bucket for storing tf state
resource "aws_s3_bucket" "tf_state_bucket" {
  bucket        = "tf-state-${var.module}"
  force_destroy = "true"

  versioning {
    enabled = "true"
  }

  tags = "${var.tags}"
}

# grant the role access to the bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = "${aws_s3_bucket.bucket.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal":{
        "AWS": "${data.aws_iam_role.role.arn}"
      },
      "Action": [ "s3:*" ],
      "Resource": [
        "${aws_s3_bucket.bucket.arn}",
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    }
  ]
}
EOF
}

# the created bucket 
output "bucket" {
  value = "${aws_s3_bucket.bucket.bucket}"
}
