module "firehose_to_opentelemetry" {

  source = "../.."
  # metric_stream_name = "otel_stack_monitoring"
  # firehose_name = "otel_stack_monitoring"
  # url_endpoint_configuration = "https://otel-2-test.ops.team"

  config = {
    "teste01" = {
    }
  }
}



output "my_config" {
  value = module.firehose_to_opentelemetry.my_config
}