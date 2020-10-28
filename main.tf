provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_vpc" "second_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "second_vpc"
  }
}

resource "aws_vpc" "third_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "second_vpc"
  }
}

# Terraform template to have VPC flow logs be sent to AWS Lambda

resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  name = "vpc-flow-log-group"
  retention_in_days = 1
}

resource "aws_flow_log" "vpc_flow_log" {
  # log_group_name needs to exist before hand
  # until we have a CloudWatch Log Group Resource
  log_group_name = "${aws_cloudwatch_log_group.vpc_flow_log_group.name}"
  iam_role_arn = "${aws_iam_role.vpc_flow_logs_role.arn}"
  vpc_id = "${aws_vpc.main.id}"
  traffic_type = "ALL"
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "vpc_flow_logs_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "vpc_flow_logs_policy"
  role = "${aws_iam_role.vpc_flow_logs_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

/*
resource "aws_iam_role" "cloudwatch_lambda_role" {
  name = "cloudwatch_lambda_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch_lambda_policy" {
  name = "cloudwatch_lambda_policy"
  role = "${aws_iam_role.cloudwatch_lambda_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSLambdaCloudwatchPolicy",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:CreateNetworkInterface"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_lambda_function" "flowlogs" {
    s3_key = "XXXXXXXXXX"
    function_name = "flowlogs"
    role = "${aws_iam_role.cloudwatch_lambda_role.arn}"
    handler = "XXXXXXXX"
    s3_bucket = "XXXXXXX"
    runtime = "java8"
    vpc_config {
    	subnet_ids = [ "subnet-XXXXXX" ]
    	security_group_ids = [ "sg-XXXXXX" ]
   	}
}

resource "aws_lambda_permission" "flowlog_permission" {
  statement_id = "vpc_flow_log_activation"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.flowlogs.arn}"
  principal = "logs.us-east-1.amazonaws.com"
  source_arn = "${aws_cloudwatch_log_group.vpc_flow_log_group.arn}"
}

resource "aws_cloudwatch_log_subscription_filter" "flowlog_subscription_filter" {
  depends_on = ["aws_lambda_permission.flowlog_permission"]
  name = "cloudwatch_flowlog_lambda_subscription"
  log_group_name = "${aws_cloudwatch_log_group.vpc_flow_log_group.name}"
  filter_pattern = ""
  destination_arn = "${aws_lambda_function.flowlogs.arn}"
}
*/



/*
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
*/
/*
  module "vpc_flow_logs" {
  source = "trussworks/vpc-flow-logs/aws"

  vpc_name       = "VPC Test"
  vpc_id         = 74D93920-ED26-11E3-AC10-0800200C9A66
  logs_retention = local.cloudwatch_logs_retention
}
*/


variable "versioning_enabled" {
  default     = "true"
  type        = "string"
  description = "Enable versioning. Versioning is a means of keeping multiple variants of an object in the same bucket."
}

    

      
      
resource "aws_s3_bucket" "b" {
  bucket = "test-bucket-testhadsiouyadoh182u32813"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
  
  
  versioning {
    enabled = "${var.versioning_enabled}"
  }
  /*
  
  versioning {
    enabled = true
  }
  
  
  versioning_inputs = [
    {
      enabled    = true
      mfa_delete = null
    },
  ]
  
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
  
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:us-east-1:753646501470:key/00c892e8-40c4-4048-a650-0f755876503d"
        sse_algorithm     = "aws:kms"
      }
    }
  }
  */
  
}

/*
terraform {
  required_version = ">= 0.11.7"
}

variable "aws_region" {
  description = "AWS region"
  default = "us-east-1"
}

variable "bucket_name" {
   description = "Name of the bucket to create"
  default = "Some bucket"
}

variable "bucket_acl" {
   description = "ACL for S3 bucket: private, public-read, public-read-write, etc"
   default = "private"
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}"
  acl    = "${var.bucket_acl}" 
  
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:us-east-1:753646501470:key/00c892e8-40c4-4048-a650-0f755876503d"
        sse_algorithm     = "aws:kms"
      }
    }
  }
 
  versioning {
    enabled = true
    mfa_delete = true
  }
  
  logging {
    target_bucket = "test-bucket"
  }
  
}

output "sse" {
  value = "${aws_s3_bucket.bucket.server_side_encryption_configuration.0.rule.0.apply_server_side_encryption_by_default.0.sse_algorithm}"
}

//
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-2757f631"
  instance_type = "t2.micro"
  count = 1
}

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket"
  acl    = "public-read"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}*/
