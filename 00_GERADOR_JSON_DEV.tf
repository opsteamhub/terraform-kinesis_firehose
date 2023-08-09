resource "local_file" "configs" {
  for_each = { for k, v in var.config :
    k => v
  }
  content  = jsonencode(each.value)
  filename = "used-configs/${each.key}-${formatdate("YYYY-MM-DD-hh-mm", timestamp())}.json"
}