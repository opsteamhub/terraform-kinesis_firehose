resource "aws_cloudwatch_metric_stream" "cloudwatch_metric_stream" {
  depends_on = [
    resource.aws_kinesis_firehose_delivery_stream.kinesis_firehose_delivery_stream
  ]

  for_each = { for k, v in var.config :
    k => v["cloudwatch_metric_stream"] if v != null
  }

  name = try(each.value["name"], null)

  role_arn = aws_iam_role.metric_stream_to_firehose.arn

  firehose_arn = aws_kinesis_firehose_delivery_stream.kinesis_firehose_delivery_stream[each.key].arn


  output_format = try(each.value["output_format"], "json")

  dynamic "include_filter" {
    for_each = each.value["include_filter"] != null ? each.value["include_filter"] : []
    content {
      namespace    = try(include_filter.value["namespace"], null)
      metric_names = try(include_filter.value["metric_names"], null)
    }
  }

}
