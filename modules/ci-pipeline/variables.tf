variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
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
