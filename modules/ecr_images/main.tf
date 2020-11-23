resource "aws_ecr_repository" "this" {
  for_each = var.repositories
  name     = each.value
}
