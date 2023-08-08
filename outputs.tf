# output "cloudwatch_metric_stream_arn" {
#   value = aws_cloudwatch_metric_stream.main.arn
# }

# output "s3_bucket_arn" {
#   value = aws_s3_bucket.bucket.arn
# }


output "my_config" {
  value = var.config
}