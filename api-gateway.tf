
resource "aws_api_gateway_rest_api" "test" {
  name        = "MyDemoAPI"
  description = "This is my API for demonstration purposes"
}

resource "aws_api_gateway_resource" "test" {
  rest_api_id = "${aws_api_gateway_rest_api.test.id}"
  parent_id   = "${aws_api_gateway_rest_api.test.root_resource_id}"
  path_part   = "mytestresource"
}

resource "aws_api_gateway_method" "test" {
  rest_api_id   = "${aws_api_gateway_rest_api.test.id}"
  resource_id   = "${aws_api_gateway_resource.test.id}"
  http_method   = "GET"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "test" {
  rest_api_id = "${aws_api_gateway_rest_api.test.id}"
  resource_id = "${aws_api_gateway_resource.test.id}"
  http_method = "${aws_api_gateway_method.test.http_method}"
  type        = "MOCK"

  request_templates = {
    "application/xml" = <<EOF
{
   "body" : $input.json('$')
}
EOF
  }
}

resource "aws_api_gateway_deployment" "test" {

  rest_api_id = "${aws_api_gateway_rest_api.test.id}"
  stage_name  = "dev"
}

resource "aws_api_gateway_stage" "test" {
  stage_name    = "prod"
  rest_api_id   = "${aws_api_gateway_rest_api.test.id}"
  deployment_id = "${aws_api_gateway_deployment.test.id}"
}

resource "aws_api_gateway_method_settings" "s" {
  rest_api_id = "${aws_api_gateway_rest_api.test.id}"
  stage_name  = "${aws_api_gateway_stage.test.stage_name}"
  method_path = "${aws_api_gateway_resource.test.path_part}/${aws_api_gateway_method.test.http_method}"

  settings {
    metrics_enabled = true
    logging_level   = "OFF"/**/
  }
}





/*
resource "aws_api_gateway_rest_api" "test" {
  name        = "MyDemoAPI"
  description = "This is my API for demonstration purposes"
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = "${aws_api_gateway_rest_api.test.id}"
  stage_name  = "test"

  # Force re-deployments if any dependencies change
  # https://github.com/hashicorp/terraform/issues/6613
  # https://github.com/terraform-providers/terraform-provider-aws/issues/162
  stage_description = <<DESCRIPTION
${aws_api_gateway_resource.example.id}
${aws_api_gateway_method.example.id}
${aws_api_gateway_integration.example.id}
DESCRIPTION

  depends_on = [
    "aws_api_gateway_integration.example",
  ]
}*/
  
