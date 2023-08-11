output "my_config" {
  value = var.config
}

output "cloudwatch_data" {
  value = { for k, v in aws_cloudwatch_metric_stream.cloudwatch_metric_stream : k => try(v, null) }
}

output "firehose_data" {
  value = {
    for k, v in aws_kinesis_firehose_delivery_stream.kinesis_firehose_delivery_stream :
    k => {
      arn         = v.arn
      destination = v.destination
      name        = v.name
    }
  }
  sensitive = false
}