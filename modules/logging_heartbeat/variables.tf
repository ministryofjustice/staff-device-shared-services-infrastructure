variable "tags" {
  type = map(string)
}

variable "retention_in_days" {
  type    = number
  default = 90
}
