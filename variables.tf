variable "is-production" {
  type    = bool
  default = "true"
}

variable "owner-email" {
  type    = string
  default = "lanwifi-devops@digital.justice.gov.uk"
}

variable "enable_cloudtrail_log_shipping_to_cloudwatch" {
  type = bool
  default = "true"
}
