variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "github_repo_name" {
  type = string
}

variable "github_organisation_name" {
  type = string
}

variable "git_branch_name" {
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

variable "pre_production_assume_role_arn" {
  type = string
}

variable "production_assume_role_arn" {
  type = string
}

variable docker_image {
  type    = string
  default = "aws/codebuild/standard:4.0"
}

variable "privileged_mode" {
  type    = bool
  default = false
}

variable "name" {
  type = string
}