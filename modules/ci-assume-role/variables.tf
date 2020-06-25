variable "account_role_arn" {
  type = string
}
variable "prefix_name" {
  type = string
}
variable "dynamo_db_locking_arn" {
  type = string
}
variable "s3_bucket_arns" {
  type = list(string)
}
