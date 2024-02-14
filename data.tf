data "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name
}

data "aws_iam_policy_document" "streams_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["streams.metrics.cloudwatch.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# data "aws_iam_policy_document" "firehose_to_s3" {
#   statement {
#     effect = "Allow"
#     actions = [
#         "glue:GetTable",
#         "glue:GetTableVersion",
#         "glue:GetTableVersions"
#     ]
#     resources = [
#       data.aws_s3_bucket.bucket.arn,
#       "${data.aws_s3_bucket.bucket.arn}/*",
#     ]
#   }
# }
