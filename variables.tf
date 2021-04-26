variable "is-production" {
  type    = bool
  default = "true"
}

variable "owner-email" {
  type    = string
  default = "emile.swarts@digital.justice.gov.uk"
}

variable "dev_assume_role_arn" {
  type = string
}

variable "pre_production_assume_role_arn" {
  type = string
}

variable "production_assume_role_arn" {
  type = string
}

variable "production_account_id" {
  type = string
}

variable "production_kinesis_destination_arn" {
  type = string
}

variable "pre_production_kinesis_destination_arn" {
  type = string
}

variable "development_kinesis_destination_arn" {
  type = string
}

variable "enable_cloudtrail_log_shipping_to_cloudwatch" {
  type = bool
}
