resource "aws_codestarconnections_connection" "nvvs-github-connection" {
  name          = "nvvs github connection"
  provider_type = "GitHub"
  tags          = module.label.tags
}
resource "aws_codestarconnections_connection" "staff-infrastructure-moj" {
  name          = "staff-infrastructure-moj"
  provider_type = "GitHub"
  tags          = module.label.tags
}
