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
  bucket = "test-bucket-test"
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
