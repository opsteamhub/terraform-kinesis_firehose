# #------Cloudwatch Metric Streams------#
# variable "metric_stream_name" {
#   description = "Nome do CloudWatch Metric Stream"
#   default     = "otel-monitoring"
# }

# variable "role_name" {
#   description = "Nome para IAM role"
#   default     = "metric_stream_to_firehose_role"
# }

# #------Kinesis DataFirehose------#
# variable "firehose_name" {
#   description = "Nome do Delivery stream"
# }

# variable "url_endpoint_configuration" {
#   description = "Endpoint que irá receber as métricas"
#   type        = string
# }



variable "config" {
  description = "Define attributes to xxxxxxx"
  type = map(
    object(
      {
        # https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/resources/cloudwatch_metric_stream

        cloudwatch_metric_stream = optional(
          object(
            {
              firehose_arn = optional(string) # ARN of the Amazon Kinesis Firehose delivery stream to use for this metric stream.

              role_arn = optional(string) # ARN of the IAM role that this metric stream will use to access Amazon Kinesis Firehose resources.

              output_format = optional(string) #  Output format for the stream. Possible values are json and opentelemetry0.7.

              exclude_filter = optional( #   List of exclusive metric filters. If you specify this parameter, the stream sends metrics from all metric namespaces except for the namespaces and the conditional metric names that you specify here. If you don't specify metric names or provide empty metric names whole metric namespace is excluded. Conflicts with include_filter.
                list(
                  object(
                    {
                      namespace    = optional(string) # Name of the metric namespace in the filter.
                      metric_names = optional(string) # An array that defines the metrics you want to exclude for this metric namespace
                    }
                  )
                )
              )

              include_filter = optional( #   List of inclusive metric filters. If you specify this parameter, the stream sends only the conditional metric names from the metric namespaces that you specify here. If you don't specify metric names or provide empty metric names whole metric namespace is included. Conflicts with exclude_filter.
                list(
                  object(
                    {
                      namespace    = optional(string) #  Name of the metric namespace in the filter.
                      metric_names = optional(string) # An array that defines the metrics you want to include for this metric namespace
                    }
                  )
                )
              )
              name = optional(string) #   Friendly name of the metric stream. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix.

              name_prefix = optional(string) #   Creates a unique friendly name beginning with the specified prefix. Conflicts with name.

              tags = optional(map(string)) #   Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level.

              statistics_configuration = optional(string) #   For each entry in this array, you specify one or more metrics and the list of additional statistics to stream for those metrics. The additional statistics that you can stream depend on the stream's output_format. If the OutputFormat is json, you can stream any additional statistic that is supported by CloudWatch, listed in CloudWatch statistics definitions. If the OutputFormat is opentelemetry0.7, you can stream percentile statistics (p99 etc.). See details below.

              include_linked_accounts_metrics = optional(string) #   If you are creating a metric stream in a monitoring account, specify true to include metrics from source accounts that are linked to this monitoring account, in the metric stream. The default is false. For more information about linking accounts, see CloudWatch cross-account observability.

              statistics_configurations = optional(
                list(
                  object(
                    {
                      additional_statistics = optional(string) #  The additional statistics to stream for the metrics listed in include_metrics.
                      include_metric        = optional(string) #  An array that defines the metrics that are to have additional statistics streamed. See details below.
                    }
                  )
                )
              )
              include_metrics = optional(
                list(
                  object(
                    {
                      metric_name = optional(string) #  The name of the metric.
                      namespace   = optional(string) # The namespace of the metric.
                    }
                  )
                )
              )
            }
          )
        )

        # https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/resources/kinesis_firehose_delivery_stream
        kinesis_firehose_delivery_stream = optional(
          object(
            {
              name = optional(string) #  A name to identify the stream. This is unique to the AWS account and region the Stream is created in. When using for WAF logging, name must be prefixed with aws-waf-logs-.

              tags = optional(map(string)) #  A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level.

              kinesis_source_configuration = optional( #  Allows the ability to specify the kinesis stream that is used as the source of the firehose delivery stream.
                list(
                  object(
                    {
                      kinesis_stream_arn = optional(string) # The kinesis stream used as the source of the firehose delivery stream.

                      role_arn = optional(string) #The ARN of the role that provides access to the source Kinesis stream.
                    }
                  )
                )
              )

              server_side_encryption = optional( #   Encrypt at rest options. Server-side encryption should not be enabled when a kinesis stream is configured as the source of the firehose delivery stream.
                list(
                  object(
                    {
                      enabled = optional(string) # Whether to enable encryption at rest. Default is false.

                      key_type = optional(string) # Type of encryption key. Default is AWS_OWNED_CMK. Valid values are AWS_OWNED_CMK and CUSTOMER_MANAGED_CMK

                      key_arn = optional(string) # Amazon Resource Name (ARN) of the encryption key. Required when key_type is CUSTOMER_MANAGED_CMK.

                    }
                  )
                )
              )

              destination = optional(string) #   This is the destination to where the data is delivered. The only options are s3 (Deprecated, use extended_s3 instead), extended_s3, redshift, elasticsearch, splunk, http_endpoint and opensearch. is redshift). More details are given below.

              extended_s3_configuration = optional( # Enhanced configuration options for the s3 destination. More details are given below.
                list(
                  object(
                    {
                      data_format_conversion_configuration = optional(any) # Nested argument for the serializer, deserializer, and schema for converting data from the JSON format to the Parquet or ORC format before writing it to Amazon S3. More details given below.
                      processing_configuration = optional(                 #  The data processing configuration. More details are given below.
                        list(
                          object(
                            {
                              processing_configuration = optional(string) # The data processing configuration. More details are given below.

                              s3_backup_mode = optional(string) # The Amazon S3 backup mode. Valid values are Disabled and Enabled. Default value is Disabled.
                            }
                          )
                        )
                      )
                      s3_backup_mode = optional(string) #  The Amazon S3 backup mode. Valid values are Disabled and Enabled. Default value is Disabled.

                      s3_backup_configuration = optional(string)     # The configuration for backup in Amazon S3. Required if s3_backup_mode is Enabled. Supports the same fields as s3_configuration object.
                      dynamic_partitioning_configuration = optional( #  The configuration for dynamic partitioning. See Dynamic Partitioning Configuration below for more details. Required when using dynamic partitioning.
                        list(
                          object(
                            {
                              enabled        = optional(string) #Enables or disables dynamic partitioning. Defaults to false.
                              retry_duration = optional(string) # Total amount of seconds Firehose spends on retries. Valid values between 0 and 7200. Default is 300.
                            }
                          )
                        )
                      )
                    }
                  )
                )
              )

              redshift_configuration = optional(string) #   Configuration options if redshift is the destination. Using redshift_configuration requires the user to also specify a s3_configuration block. More details are given below.

              elasticsearch_configuration = optional(string) #  onfiguration options if elasticsearch is the destination. More details are given below.

              opensearch_configuration = optional(string) #   Configuration options if opensearch is the destination. More details are given below.

              splunk_configuration = optional(string) #   Configuration options if splunk is the destination. More details are given below.

              http_endpoint_configuration = optional(string) #   Configuration options if http_endpoint is the destination. requires the user to also specify a s3_configuration block. More details are given below.
            }
          )
        )

      }
    )
  )
}

