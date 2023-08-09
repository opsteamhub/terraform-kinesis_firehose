resource "aws_kinesis_firehose_delivery_stream" "kinesis_firehose_delivery_stream" {
  for_each = { for k, v in var.config :
    k => v["kinesis_firehose_delivery_stream"] if v != null
  }

  name = each.value["name"]

  destination = each.value["destination"]

  tags = try(each.value["tags"], {})

  http_endpoint_configuration {
    url = try(each.value["http_endpoint_configuration"]["url"], null) # "https://www.x.com.br"

    name = try(each.value["http_endpoint_configuration"]["name"], null) #  "New teste"

    access_key = try(each.value["http_endpoint_configuration"]["access_key"], null) #  "my-key"

    buffering_size = try(each.value["http_endpoint_configuration"]["buffering_size"], null) #  15

    buffering_interval = try(each.value["http_endpoint_configuration"]["buffering_interval"], null) #  600

    role_arn = aws_iam_role.firehose_to_s3.arn

    s3_backup_mode = try(each.value["http_endpoint_configuration"]["s3_backup_mode"], null)

    retry_duration = try(each.value["http_endpoint_configuration"]["retry_duration"], null)

    s3_configuration {
      role_arn            = aws_iam_role.firehose_to_s3.arn
      bucket_arn          = data.aws_s3_bucket.bucket.arn
      prefix              = try(each.value["http_endpoint_configuration"]["s3_configuration"]["prefix"], null)
      buffering_size      = try(each.value["http_endpoint_configuration"]["s3_configuration"]["buffering_size"], null)
      buffering_interval  = try(each.value["http_endpoint_configuration"]["s3_configuration"]["buffering_interval"], null)
      compression_format  = try(each.value["http_endpoint_configuration"]["s3_configuration"]["compression_format"], null)
      error_output_prefix = try(each.value["http_endpoint_configuration"]["s3_configuration"]["error_output_prefix"], null)
      kms_key_arn         = try(each.value["http_endpoint_configuration"]["s3_configuration"]["kms_key_arn"], null)
    }

    # cloudwatch_logging_options = try(each.value["http_endpoint_configuration"]["cloudwatch_logging_options"], null)

    # processing_configuration = try(each.value["http_endpoint_configuration"]["processing_configuration"], null)

    # request_configuration = try(each.value["http_endpoint_configuration"]["request_configuration"], null)



  }

}