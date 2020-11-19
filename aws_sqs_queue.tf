resource "aws_sqs_queue" "terraform_queue" {
  name                              = "terraform-example-queue"
  kms_master_key_id                 = "alias/aws/sqs"
  kms_data_key_reuse_period_seconds = 300
}

resource "aws_sqs_queue" "terraform_queue_no_enc" {
  name                              = "terraform-example-queue-no-enc"
  #kms_master_key_id                 = "alias/aws/sqs"
  #kms_data_key_reuse_period_seconds = 300
}

resource "aws_sqs_queue" "terraform_queue_no_enc_one" {
  name                              = "terraform-example-queue-no-enc-one"
  kms_master_key_id                 = "alias/aws/sqs"
  kms_data_key_reuse_period_seconds = 300
}
