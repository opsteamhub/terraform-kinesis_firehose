

resource "aws_iam_role" "metric_stream_to_firehose" {
  name               = "metric_stream_to_firehose_role"
  assume_role_policy = data.aws_iam_policy_document.streams_assume_role.json
  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "firehose:PutRecord",
            "firehose:PutRecordBatch"
          ],
          "Resource" : [
            "arn:aws:firehose:us-east-1:*:deliverystream/otel-prometheus"
          ]
        }
      ]
    })
  }
}

resource "aws_iam_role" "firehose_to_s3" {
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}

resource "aws_iam_role_policy" "firehose_to_s3" {
  name = "default"
  role = aws_iam_role.firehose_to_s3.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Action" : [
          "glue:GetTable",
          "glue:GetTableVersion",
          "glue:GetTableVersions"
        ],
        "Resource" : [
          "arn:aws:glue:us-east-1:*:catalog",
          "arn:aws:glue:us-east-1:*:database/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
          "arn:aws:glue:us-east-1:*:table/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
        ]
      },
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Action" : [
          "glue:GetSchemaByDefinition"
        ],
        "Resource" : [
          "arn:aws:glue:us-east-1:*:registry/*",
          "arn:aws:glue:us-east-1:*:schema/*"
        ]
      },
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Action" : [
          "glue:GetSchemaVersion"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : [
          "${data.aws_s3_bucket.bucket.arn}",
          "${data.aws_s3_bucket.bucket.arn}/*"
        ]
      },
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction",
          "lambda:GetFunctionConfiguration"
        ],
        "Resource" : "arn:aws:lambda:us-east-1:*:function:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ],
        "Resource" : [
          "arn:aws:kms:us-east-1:*:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
        ],
        "Condition" : {
          "StringEquals" : {
            "kms:ViaService" : "s3.us-east-1.amazonaws.com"
          },
          "StringLike" : {
            "kms:EncryptionContext:aws:s3:arn" : [
              "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*",
              "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
            ]
          }
        }
      },
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Action" : [
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:us-east-1:*:log-group:/aws/kinesisfirehose/*:log-stream:*",
          "arn:aws:logs:us-east-1:*:log-group:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%:log-stream:*"
        ]
      },
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Action" : [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListShards"
        ],
        "Resource" : "arn:aws:kinesis:us-east-1:*:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt"
        ],
        "Resource" : [
          "arn:aws:kms:us-east-1:*:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
        ],
        "Condition" : {
          "StringEquals" : {
            "kms:ViaService" : "kinesis.us-east-1.amazonaws.com"
          },
          "StringLike" : {
            "kms:EncryptionContext:aws:kinesis:arn" : "arn:aws:kinesis:us-east-1:*:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
          }
        }
      }
    ]
    }

  )
}