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

variable "ost_vpc_id" {
  type = string
}

variable "ost_aws_account_id" {
  type = string
}

variable "ost_vpc_cidr_block" {
  type = string
}