resource "aws_cloudwatch_metric_alarm" "lambda_consumer_errors" {
  alarm_name          = "LambdaConsumerErrors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarma si el Lambda consumidor tiene errores"
  dimensions = {
    FunctionName = aws_lambda_function.lambda_consumer.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "dynamo_consumption" {
  alarm_name          = "DynamoDBHighConsumption"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ConsumedReadCapacityUnits"
  namespace           = "AWS/DynamoDB"
  period              = 300
  statistic           = "Sum"
  threshold           = 100
  alarm_description   = "Alarma si DynamoDB consume más de 100 RCUs en 5 minutos"
  dimensions = {
    TableName = aws_dynamodb_table.hospital_events.name
  }
}


resource "aws_cloudwatch_metric_alarm" "dynamo_write_consumption" {
  alarm_name          = "DynamoDBHighWriteConsumption"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ConsumedWriteCapacityUnits"
  namespace           = "AWS/DynamoDB"
  period              = 300
  statistic           = "Sum"
  threshold           = 100
  alarm_description   = "Alarma si DynamoDB consume más de 100 WCUs en 5 minutos"
  dimensions = {
    TableName = aws_dynamodb_table.hospital_events.name
  }
}
