resource "aws_iam_role" "metric_stream_to_firehose" {
  name               = "metric_stream_to_firehose_role"
  assume_role_policy = data.aws_iam_policy_document.streams_assume_role.json
}

resource "aws_iam_role_policy" "metric_stream_to_firehose_policy" {
  name   = "metric_stream_to_firehose_policy"
  role   = aws_iam_role.metric_stream_to_firehose.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "firehose:PutRecord",
          "firehose:PutRecordBatch"
        ],
        "Resource": [
          "arn:aws:firehose:us-east-1:*:deliverystream/firehose-to-otel"
        ]
      }
    ]
  })
}


  resource "aws_iam_role" "firehose_to_s3" {
    name               = "firehose_to_s3_role"
    assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
  }

  resource "aws_iam_role_policy" "firehose_to_s3" {
    name   = "firehose_to_s3_policy"
    role   = aws_iam_role.firehose_to_s3.id
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "GluePermissions",
          "Effect": "Allow",
          "Action": [
            "glue:GetTable",
            "glue:GetTableVersion",
            "glue:GetTableVersions"
          ],
          "Resource": [
            "arn:aws:glue:us-east-1:*:catalog",
            "arn:aws:glue:us-east-1:*:database/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
            "arn:aws:glue:us-east-1:*:table/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
          ]
        },
        {
          "Sid": "GlueSchemaPermissions",
          "Effect": "Allow",
          "Action": [
            "glue:GetSchemaByDefinition"
          ],
          "Resource": [
            "arn:aws:glue:us-east-1:*:registry/*",
            "arn:aws:glue:us-east-1:*:schema/*"
          ]
        },
        {
          "Sid": "GlueSchemaVersion",
          "Effect": "Allow",
          "Action": [
            "glue:GetSchemaVersion"
          ],
          "Resource": "*"
        },
        {
          "Sid": "S3Permissions",
          "Effect": "Allow",
          "Action": [
            "s3:*"
          ],
          "Resource": [
            "${data.aws_s3_bucket.bucket.arn}",
            "${data.aws_s3_bucket.bucket.arn}/*"
          ]
        },
        {
          "Sid": "LambdaPermissions",
          "Effect": "Allow",
          "Action": [
            "lambda:InvokeFunction",
            "lambda:GetFunctionConfiguration"
          ],
          "Resource": "arn:aws:lambda:us-east-1:*:function:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
        },
        {
          "Sid": "KMSForS3",
          "Effect": "Allow",
          "Action": [
            "kms:GenerateDataKey",
            "kms:Decrypt"
          ],
          "Resource": [
            "arn:aws:kms:us-east-1:*:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
          ],
          "Condition": {
            "StringEquals": {
              "kms:ViaService": "s3.us-east-1.amazonaws.com"
            },
            "StringLike": {
              "kms:EncryptionContext:aws:s3:arn": [
                "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*",
                "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
              ]
            }
          }
        },
        {
          "Sid": "LogsPermissions",
          "Effect": "Allow",
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams"
          ],
          "Resource": [
            "arn:aws:logs:us-east-1:*:log-group:/aws/kinesisfirehose/*:log-stream:*",
            "arn:aws:logs:us-east-1:*:log-group:/aws/kinesisfirehose/firehose-to-otel:log-stream:*"
          ]
        },
        {
          "Sid": "KinesisPermissions",
          "Effect": "Allow",
          "Action": [
            "kinesis:DescribeStream",
            "kinesis:GetShardIterator",
            "kinesis:GetRecords",
            "kinesis:ListShards"
          ],
          "Resource": "arn:aws:kinesis:us-east-1:*:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
        },
        {
          "Sid": "KMSForKinesis",
          "Effect": "Allow",
          "Action": [
            "kms:Decrypt"
          ],
          "Resource": [
            "arn:aws:kms:us-east-1:*:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
          ],
          "Condition": {
            "StringEquals": {
              "kms:ViaService": "kinesis.us-east-1.amazonaws.com"
            },
            "StringLike": {
              "kms:EncryptionContext:aws:kinesis:arn": "arn:aws:kinesis:us-east-1:*:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
            }
          }
        }
      ]
    })
  }
