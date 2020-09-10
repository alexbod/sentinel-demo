provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-2757f631"
  instance_tyoe = "t2.micro"
  count = 1
}
