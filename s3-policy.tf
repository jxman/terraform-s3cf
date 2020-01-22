# File in the variables needed for the policy file to be applied
data "template_file" "bucket_policy" {
  template = "${file("bucket_policy.json")}"
  vars = {
    origin_access_identity_arn = "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
    bucket                     = "${aws_s3_bucket.www_site.arn}"
  }
}

# Add the IAM role for CF access to the S3 Bucket
resource "aws_s3_bucket_policy" "www_site" {
  bucket = "www.${var.site_name}"
  policy = "${data.template_file.bucket_policy.rendered}"
}