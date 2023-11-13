variable "prefix_name" {
  type = string
}

#variable "account_ids" {
#  type = list(string)
#}

variable "s3_bucket_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}
