resource "aws_cloudwatch_log_group" "firehose_log_group" {
  for_each = {
    for k, v in var.config :
    k => v["kinesis_firehose_delivery_stream"]["http_endpoint_configuration"]["cloudwatch_logging_options"] 
    if try(v["kinesis_firehose_delivery_stream"]["http_endpoint_configuration"]["cloudwatch_logging_options"]["log_group_name"], null) != null
  }

  name              = each.value["log_group_name"]
  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_log_stream" "firehose_log_stream" {
  for_each = aws_cloudwatch_log_group.firehose_log_group

  log_group_name = each.value.name
  name           = coalesce(try(each.value["log_stream_name"], null), var.log_stream_name)

  lifecycle {
    create_before_destroy = true
  }
}