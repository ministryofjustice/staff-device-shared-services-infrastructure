resource "aws_kms_key" "peramater_store_key" {
  description             = "${var.prefix_name}-${var.service_name}-peramater-store-key"
  deletion_window_in_days = 10
  tags                    = local.tags
}
