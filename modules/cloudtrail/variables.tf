variable "region" {
  type = string
}

variable "prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "enable_cloudtrail_log_shipping_to_cloudwatch" {
  type = bool
}
