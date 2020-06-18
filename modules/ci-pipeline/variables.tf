variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable github_repo_name {
  type = string
}

variable github_organisation_name {
  type = string
}

variable "github_oauth_token" {
  type = string
}

variable "prefix_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "dev_assume_role_arn" {
  type = string
}