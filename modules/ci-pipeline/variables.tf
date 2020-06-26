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

variable "ost_vpc_id" {
  type = string
}

variable "ost_aws_account_id" {
  type = string
}

variable "ost_vpc_cidr_block" {
  type = string
}