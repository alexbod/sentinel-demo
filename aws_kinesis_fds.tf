resource "aws_kinesis_firehose_delivery_stream" "test_stream" {
  name        = "terraform-kinesis-firehose-test-stream"
  destination = "http_endpoint"

  s3_configuration {
    role_arn           = "${aws_iam_role.firehose.arn}"
    bucket_arn         = "${aws_s3_bucket.bucket.arn}"
    buffer_size        = 10
    buffer_interval    = 400
    compression_format = "GZIP"
  }

  http_endpoint_configuration {
    url                = "https://aws-api.newrelic.com/firehose/v1"
    name               = "New Relic"
    access_key         = "my-key"
    buffering_size     = 15
    buffering_interval = 600
    role_arn           = "${aws_iam_role.firehose.arn}"
    s3_backup_mode     = "FailedDataOnly"

    request_configuration {
      content_encoding = "GZIP"

      common_attributes {
        name  = "testname"
        value = "testvalue"
      }

      common_attributes {
        name  = "testname2"
        value = "testvalue2"
      }
    }
  }
}
