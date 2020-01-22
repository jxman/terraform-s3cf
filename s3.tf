# Create the logs bucket
resource "aws_s3_bucket" "logs" {
  bucket = "${var.site_name}-site-logs"
  acl    = "log-delivery-write"
}

# Create the www site bucket
resource "aws_s3_bucket" "www_site" {
  bucket = "www.${var.site_name}"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.logs.bucket}"
    target_prefix = "www.${var.site_name}/"
  }

  website {
    index_document = "index.html"
  }

  replication_configuration {
    role = "${aws_iam_role.replication.arn}"

    rules {
      id     = "Full Replication Rule"
      prefix = ""
      status = "Enabled"

      destination {
        bucket        = "${aws_s3_bucket.destination.arn}"
        storage_class = "STANDARD"
      }
    }


  }

}
