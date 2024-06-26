variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "github_repo_id" {
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

variable "docker_image" {
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

variable "manual_production_deploy" {
  type    = bool
  default = false
}

variable "production_plan" {
  type    = bool
  default = false
}
variable "codestar_connection_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "test_code_build_compute_type" {
  type    = string
  default = "BUILD_GENERAL1_SMALL"
}
