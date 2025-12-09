# API Gateway principal
resource "aws_api_gateway_rest_api" "hospital_api" {
  name        = "etapiJSV-hospital-dev"
  description = "API Gateway para microservicios hospital"
}

# Recursos (endpoints)
resource "aws_api_gateway_resource" "pacientes" {
  rest_api_id = aws_api_gateway_rest_api.hospital_api.id
  parent_id   = aws_api_gateway_rest_api.hospital_api.root_resource_id
  path_part   = "pacientes"
}

resource "aws_api_gateway_resource" "citas" {
  rest_api_id = aws_api_gateway_rest_api.hospital_api.id
  parent_id   = aws_api_gateway_rest_api.hospital_api.root_resource_id
  path_part   = "citas"
}

resource "aws_api_gateway_resource" "inventarios" {
  rest_api_id = aws_api_gateway_rest_api.hospital_api.id
  parent_id   = aws_api_gateway_rest_api.hospital_api.root_resource_id
  path_part   = "inventarios"
}

resource "aws_api_gateway_resource" "facturacion" {
  rest_api_id = aws_api_gateway_rest_api.hospital_api.id
  parent_id   = aws_api_gateway_rest_api.hospital_api.root_resource_id
  path_part   = "facturacion"
}

# Métodos POST
resource "aws_api_gateway_method" "post_pacientes" {
  rest_api_id   = aws_api_gateway_rest_api.hospital_api.id
  resource_id   = aws_api_gateway_resource.pacientes.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_citas" {
  rest_api_id   = aws_api_gateway_rest_api.hospital_api.id
  resource_id   = aws_api_gateway_resource.citas.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_inventarios" {
  rest_api_id   = aws_api_gateway_rest_api.hospital_api.id
  resource_id   = aws_api_gateway_resource.inventarios.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_facturacion" {
  rest_api_id   = aws_api_gateway_rest_api.hospital_api.id
  resource_id   = aws_api_gateway_resource.facturacion.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integraciones con Lambda
resource "aws_api_gateway_integration" "pacientes_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.hospital_api.id
  resource_id             = aws_api_gateway_resource.pacientes.id
  http_method             = aws_api_gateway_method.post_pacientes.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_pacientes.invoke_arn
}

resource "aws_api_gateway_integration" "citas_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.hospital_api.id
  resource_id             = aws_api_gateway_resource.citas.id
  http_method             = aws_api_gateway_method.post_citas.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_citas.invoke_arn
}

resource "aws_api_gateway_integration" "inventarios_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.hospital_api.id
  resource_id             = aws_api_gateway_resource.inventarios.id
  http_method             = aws_api_gateway_method.post_inventarios.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_inventarios.invoke_arn
}

resource "aws_api_gateway_integration" "facturacion_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.hospital_api.id
  resource_id             = aws_api_gateway_resource.facturacion.id
  http_method             = aws_api_gateway_method.post_facturacion.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_facturacion.invoke_arn
}

# Deployment y Stage
resource "aws_api_gateway_deployment" "hospital_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.pacientes_lambda,
    aws_api_gateway_integration.citas_lambda,
    aws_api_gateway_integration.inventarios_lambda,
    aws_api_gateway_integration.facturacion_lambda
  ]
  rest_api_id = aws_api_gateway_rest_api.hospital_api.id
}

resource "aws_api_gateway_stage" "dev" {
  rest_api_id   = aws_api_gateway_rest_api.hospital_api.id
  deployment_id = aws_api_gateway_deployment.hospital_api_deployment.id
  stage_name    = "dev"
}

# Output con la URL del API
output "api_gateway_url" {
  value = "https://${aws_api_gateway_rest_api.hospital_api.id}.execute-api.${var.aws_region}.amazonaws.com/dev"
}

# Permisos para que API Gateway invoque cada Lambda
resource "aws_lambda_permission" "apigw_pacientes" {
  statement_id  = "AllowAPIGatewayInvokePacientes"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_pacientes.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hospital_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_citas" {
  statement_id  = "AllowAPIGatewayInvokeCitas"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_citas.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hospital_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_inventarios" {
  statement_id  = "AllowAPIGatewayInvokeInventarios"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_inventarios.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hospital_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_facturacion" {
  statement_id  = "AllowAPIGatewayInvokeFacturacion"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_facturacion.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hospital_api.execution_arn}/*/*"
}
