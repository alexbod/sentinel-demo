locals {
  private_config_map = { type = "PRIVATE", vpc_endpoint_ids = var.vpc_endpoint_ids }
  regional_config_map = { type = "REGIONAL", vpc_endpoint_ids = null }
}

/* ---------------------------
 * API GATEWAY
 * --------------------------- */
resource "aws_api_gateway_rest_api" "main" {
  name            = var.name

  dynamic "endpoint_configuration" {
    for_each = var.private == true ? list(local.private_config_map) : list(local.regional_config_map)

    content {
      types             = [endpoint_configuration.value["type"]]
      vpc_endpoint_ids  = endpoint_configuration.value["vpc_endpoint_ids"]
    }
  }

  api_key_source  = "HEADER"
  body            = var.body
  tags            = var.tags

  lifecycle {
    ignore_changes = [
      policy
    ]
  }
}

/* ---------------------------
 * SETTINGS
 * --------------------------- */
resource "aws_api_gateway_method_settings" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_deployment.deploy.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = true
  }
}

/* ---------------------------
 * MAIN STAGE
 * --------------------------- */
resource "aws_api_gateway_stage" "main" {
  stage_name            = "main"
  description           = "Main Stage for deploying functionality"
  rest_api_id           = aws_api_gateway_rest_api.main.id
  deployment_id         = aws_api_gateway_deployment.deploy.id
  xray_tracing_enabled  = var.xray_tracing_enabled

  variables             = var.variables

  access_log_settings {
    destination_arn = var.cloudwatch_log_arn
    format          = "\"{\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\",\"caller\":\"$context.identity.caller\",\"user\":\"$context.identity.user\",\"requestTime\":$context.requestTimeEpoch,\"httpMethod\":\"$context.httpMethod\",\"resourcePath\":\"$context.resourcePath\",\"status\":$context.status,\"protocol\":\"$context.protocol\",\"path\":\"$context.path\",\"stage\":\"$context.stage\",\"xrayTraceId\":\"$context.xrayTraceId\",\"userAgent\":\"$context.identity.userAgent\",\"responseLength\":$context.responseLength}\""
  }

  lifecycle {
    ignore_changes = [
      deployment_id
    ]
  }

  tags = var.tags

  depends_on = [aws_api_gateway_deployment.deploy]
}

/* ---------------------------
 * DEPLOYMENT
 * --------------------------- */
resource "aws_api_gateway_deployment" "deploy" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = "deploy"
  stage_description = "Deployed at ${timestamp()}"

  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(var.body)
    )))
  }

  lifecycle {
    create_before_destroy = true
  }
}
