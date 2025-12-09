resource "aws_cloudwatch_dashboard" "hospital_dashboard" {
  dashboard_name = "HospitalEventsDashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0,
        y    = 0,
        width  = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.lambda_consumer.function_name ],
            [ ".", "Errors", ".", "." ],
            [ "AWS/Lambda", "Duration", "FunctionName", aws_lambda_function.lambda_consumer.function_name ]
          ]
          period = 60
          stat   = "Sum"
          region = "us-east-1"
          title  = "Lambda Consumer Metrics"
        }
      },
      {
        type = "metric",
        x    = 12,
        y    = 0,
        width  = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/DynamoDB", "ConsumedReadCapacityUnits", "TableName", aws_dynamodb_table.hospital_events.name ],
            [ ".", "ConsumedWriteCapacityUnits", ".", "." ]
          ]
          period = 300
          stat   = "Sum"
          region = "us-east-1"
          title  = "DynamoDB Consumption"
        }
      }
    ]
  })
}
