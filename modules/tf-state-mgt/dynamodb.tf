resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name     = "${var.prefix_name}-client-${var.service_name}-tf-lock-table"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
}

resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.dynamodb_terraform_state_lock.id}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = 70
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.dynamodb_terraform_state_lock.id}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_write_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_write_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_write_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 70
  }
}
