provider "aws" {
  region = "us-east-1"
}


resource "aws_api_gateway_rest_api" "test" {
  name        = "MyDemoAPI"
  description = "This is my API for demonstration purposes"
}
