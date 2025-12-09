# Lambda Pacientes
resource "aws_lambda_function" "lambda_pacientes" {
  function_name = "lambda-pacientes"
  role          = "arn:aws:iam::730335546358:role/LabRole"
  handler       = "lambda-pacientes.handler"
  runtime       = "nodejs18.x"
  filename      = "${path.module}/lambda-pacientes.zip"

  source_code_hash = filebase64sha256("${path.module}/lambda-pacientes.zip")

  environment {
    variables = {
      SQS_URL = aws_sqs_queue.hospital_queue.id
    }
  }
}

# Lambda Citas
resource "aws_lambda_function" "lambda_citas" {
  function_name = "lambda-citas"
  role          = "arn:aws:iam::730335546358:role/LabRole"
  handler       = "lambda-citas.handler"
  runtime       = "nodejs18.x"
  filename      = "${path.module}/lambda-citas.zip"

  source_code_hash = filebase64sha256("${path.module}/lambda-citas.zip")

  environment {
    variables = {
      SQS_URL = aws_sqs_queue.hospital_queue.id
    }
  }
}

# Lambda Inventarios
resource "aws_lambda_function" "lambda_inventarios" {
  function_name = "lambda-inventarios"
  role          = "arn:aws:iam::730335546358:role/LabRole"
  handler       = "lambda-inventarios.handler"
  runtime       = "nodejs18.x"
  filename      = "${path.module}/lambda-inventarios.zip"

  source_code_hash = filebase64sha256("${path.module}/lambda-inventarios.zip")

  environment {
    variables = {
      SQS_URL = aws_sqs_queue.hospital_queue.id
    }
  }
}

# Lambda Facturación
resource "aws_lambda_function" "lambda_facturacion" {
  function_name = "lambda-facturacion"
  role          = "arn:aws:iam::730335546358:role/LabRole"
  handler       = "lambda-facturacion.handler"
  runtime       = "nodejs18.x"
  filename      = "${path.module}/lambda-facturacion.zip"

  source_code_hash = filebase64sha256("${path.module}/lambda-facturacion.zip")

  environment {
    variables = {
      SQS_URL = aws_sqs_queue.hospital_queue.id
    }
  }
}

# Tabla DynamoDB para almacenar eventos
resource "aws_dynamodb_table" "hospital_events" {
  name         = "hospital-events"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "dev"
    Project     = "sanavi"
  }
}


# Lambda Consumer (procesa mensajes de SQS y guarda en DynamoDB)
resource "aws_lambda_function" "lambda_consumer" {
  function_name = "lambda-consumer"
  role          = "arn:aws:iam::730335546358:role/LabRole"
  handler       = "lambda-consumer.handler"
  runtime       = "nodejs18.x"
  filename      = "${path.module}/lambda-consumer.zip"

  source_code_hash = filebase64sha256("${path.module}/lambda-consumer.zip")

  environment {
    variables = {
      SQS_URL      = aws_sqs_queue.hospital_queue.id
      DYNAMO_TABLE = aws_dynamodb_table.hospital_events.name
    }
  }
}

# Trigger de SQS → Lambda Consumer
resource "aws_lambda_event_source_mapping" "sqs_consumer_mapping" {
  event_source_arn = aws_sqs_queue.hospital_queue.arn
  function_name    = aws_lambda_function.lambda_consumer.arn
  batch_size       = 10
  enabled          = true
}

# Permisos IAM para que LabRole pueda escribir en DynamoDB
#resource "aws_iam_role_policy" "labrole_dynamo" {
#  role = "LabRole"

#  policy = jsonencode({
#    Version = "2012-10-17",
#    Statement = [
#      {
#        Effect   = "Allow",
#        Action   = ["dynamodb:PutItem"],
#        Resource = aws_dynamodb_table.hospital_events.arn
#      }
#    ]
#  })
#}
