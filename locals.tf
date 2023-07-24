locals {
  cidr_block = "10.0.0.0/16"

  ## vpc module requires the tags map without the "Name" value
  ## It uses the "name" attribute internally and concatenates with other attributes 
  tags_minus_name = { for k, v in module.label.tags: k => v if !contains(["Name"], k) }
}
