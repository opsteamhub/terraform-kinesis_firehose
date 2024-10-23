module "firehose_to_opentelemetry" {

  source = "../.."
  # metric_stream_name = "otel_stack_monitoring"
  # firehose_name = "otel_stack_monitoring"
  # url_endpoint_configuration = "https://otel-2-test.ops.team"

  s3_bucket_name = ""

  config = {
    "firehose01" = {


      cloudwatch_metric_stream = {
        name = "streams-to-firehose"

        output_format = "json"

        include_filter = [
          {
            namespace    = "AWS/WAFV2"
            metric_names = [] #Todas as Metricas.

          },
          # {
          #   namespace    = "AWS/S3"
          #   metric_names = ["NumberOfObjects"]

          # }
        ]
      }


      kinesis_firehose_delivery_stream = {

        destination = "http_endpoint"

        name = "firehose-to-otel"

        http_endpoint_configuration = {
          url = ""

          name = "HTTP endpoint"

          access_key = ""

          buffering_size     = 5
          buffering_interval = 60

          cloudwatch_logging_options = {
            enabled         = true
            log_group_name  = "/aws/kinesisfirehose/firehose-to-otel"
            log_stream_name = "DestinationDelivery"
          }
        }

      },
      # "firehose02" = {

      # }

    }
  }
}


# output "my_config" {
#   value = module.firehose_to_opentelemetry.my_config
# }

# output "firehose_data" {
#   value = module.firehose_to_opentelemetry.firehose_data
# }


# output "cloudwatch_data" {
#   value = module.firehose_to_opentelemetry.cloudwatch_data
# }

# output "log_groups_created_by_module" {
#   value = aws_cloudwatch_log_group.firehose_log_group[*].name
# }
