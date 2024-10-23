# outputs.tf no módulo "terraform-kinesis_firehose"

output "kinesis_firehose_delivery_stream_names" {
  value       = [for kfd in aws_kinesis_firehose_delivery_stream.kinesis_firehose_delivery_stream : kfd.name]
  description = "Nomes do Kinesis Firehose Delivery Stream"
}

output "cloudwatch_metric_stream_names" {
  value       = [for cms in aws_cloudwatch_metric_stream.cloudwatch_metric_stream : cms.name]
  description = "Nomes do CloudWatch Metric Stream"
}

output "http_endpoint_urls" {
  value       = [for kfd in aws_kinesis_firehose_delivery_stream.kinesis_firehose_delivery_stream : kfd.destination]
  description = "URLs dos endpoints HTTP configurados"
}
