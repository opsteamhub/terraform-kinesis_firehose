

resource "aws_iam_role" "metric_stream_to_firehose" {
  name               = "metric_stream_to_firehose_role"
  assume_role_policy = data.aws_iam_policy_document.streams_assume_role.json
}

# data "aws_iam_policy_document" "metric_stream_to_firehose" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "firehose:PutRecord",
#       "firehose:PutRecordBatch",
#     ]
#     resources = [aws_kinesis_firehose_delivery_stream.https.arn]
#   }
# }

# resource "aws_iam_role_policy" "metric_stream_to_firehose" {
#   name   = "default"
#   role   = aws_iam_role.metric_stream_to_firehose.id
#   policy = data.aws_iam_policy_document.metric_stream_to_firehose.json
# }



resource "aws_iam_role" "firehose_to_s3" {
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}


resource "aws_iam_role_policy" "firehose_to_s3" {
  name   = "default"
  role   = aws_iam_role.firehose_to_s3.id
  policy = data.aws_iam_policy_document.firehose_to_s3.json
}


# resource "aws_kinesis_firehose_delivery_stream" "https" {
#   name        = "otel-promemetheus"
#   destination = "http_endpoint"
#   http_endpoint_configuration {
#     url                = "https://otel-test.ops.team"
#     name               = "HTTPS endpoint opentelemetry"
#     access_key         = "SimplesVet"
#     buffering_size     = 15
#     buffering_interval = 300
#     role_arn           = aws_iam_role.firehose_to_s3.arn
#     s3_backup_mode     = "FailedDataOnly"
#     s3_configuration {
#       role_arn           = aws_iam_role.firehose_to_s3.arn
#       bucket_arn         = aws_s3_bucket.bucket.arn
#       buffering_size     = 10
#       buffering_interval = 400
#       compression_format = "GZIP"
#     }
#     request_configuration {
#       content_encoding = "GZIP"
#     }
#   }
# }