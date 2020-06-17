variable "github_oauth_token" {
  type = string
}

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