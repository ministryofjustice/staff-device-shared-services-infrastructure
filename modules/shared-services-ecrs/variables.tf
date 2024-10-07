variable "production_account_id" {
  type = string
}

variable "development_account_id" {
  type = string
}

variable "pre-production_account_id" {
  type = map(string)
}

variable "prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}
