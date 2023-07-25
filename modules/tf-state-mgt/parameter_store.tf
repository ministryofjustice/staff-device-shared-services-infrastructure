resource "aws_kms_key" "peramater_store_key" {
  description             = "${var.prefix_name}-${var.service_name}-peramater-store-key"
  deletion_window_in_days = 10
  
  tags = merge(local.tags, {
    Name = "${var.prefix_name}-${var.service_name}"
  })
}

resource "aws_kms_alias" "peramater_store_key" {
  name          = "alias/${var.prefix_name}-${var.service_name}"
  target_key_id = aws_kms_key.peramater_store_key.id
}
