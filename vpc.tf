module "vpc" {
  # source  = "terraform-aws-modules/vpc/aws"
  # version = "2.78.0"
  source = "./modules/vpc"

  name = module.label.id

  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr                 = local.cidr_block

  azs = [
    "${data.aws_region.current_region.id}a",
    "${data.aws_region.current_region.id}b",
    "${data.aws_region.current_region.id}c"
  ]

  private_subnets = [
    cidrsubnet(local.cidr_block, 8, 1),
    cidrsubnet(local.cidr_block, 8, 2),
    cidrsubnet(local.cidr_block, 8, 3)
  ]

  map_public_ip_on_launch = false
}
