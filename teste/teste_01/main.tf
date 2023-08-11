module "firehose_to_opentelemetry" {

  source = "../.."
  # metric_stream_name = "otel_stack_monitoring"
  # firehose_name = "otel_stack_monitoring"
  # url_endpoint_configuration = "https://otel-2-test.ops.team"

  s3_bucket_name = "otel-poc"

  config = {
    "firehose01" = {


      cloudwatch_metric_stream = {
        name = "otel-monitoring"

        output_format = "json"

        include_filter = [
          {
            namespace    = "AWS/EC2"
            metric_names = ["CPUUtilization", "NetworkOut"]
          },

          {
            namespace    = "AWS/EBS"
            metric_names = []
          },

          {
            namespace    = "AWS/RDS"
            metric_names = []
          }
        ]
      }


      kinesis_firehose_delivery_stream = {

        destination = "http_endpoint"

        name = "Teste123"

        http_endpoint_configuration = {
          url = "https://www.abc123.com.br"

          name = "name002"

          access_key = "my-key123"

          buffering_size     = 30
          buffering_interval = 500


        }

      },
      # "firehose02" = {

      # }

    }
  }
}


output "my_config" {
  value = module.firehose_to_opentelemetry.my_config
}

output "firehose_data" {
  value = module.firehose_to_opentelemetry.firehose_data
}


output "cloudwatch_data" {
  value = module.firehose_to_opentelemetry.cloudwatch_data
}