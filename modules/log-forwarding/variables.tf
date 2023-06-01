variable "prefix_name" {
  type = string
}

variable "subscriptions_config" {
  type = object({
    production = object({
      destination_arn = string
      log_groups      = list(string)
    })
    pre_production = object({
      destination_arn = string
      log_groups      = list(string)
    })
    development = object({
      destination_arn = string
      log_groups      = list(string)
    })
  })
}