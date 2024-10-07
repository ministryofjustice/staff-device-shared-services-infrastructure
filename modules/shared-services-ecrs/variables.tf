variable "production_account_id" {
  type = string
}

variable "development_account_id" {
  type = string
}

variable "pre_production_account_id" {
  type = string
}

variable "prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}
