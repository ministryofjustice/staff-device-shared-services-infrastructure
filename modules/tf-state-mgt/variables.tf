variable "prefix_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "github_repo_id" {
  type = string
}

variable "dev_assume_role_arn" {
  type = string
  default = "no-environment-defined"
}

variable "pre_production_assume_role_arn" {
  type = string
  default = "no-environment-defined"
}

variable "production_assume_role_arn" {
  type = string
  default = "no-environment-defined"
}
