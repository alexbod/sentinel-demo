resource "aws_sqs_queue" "q" {
  name = "examplequeue_super_test"
}


resource "aws_sqs_queue_policy" "test" {
  queue_url = "${aws_sqs_queue.q.id}"

  policy = "${data.template_file.user_service_queue_policy.rendered}"
  
/*
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.q.arn}"
    }
  ]
}
POLICY
*/
}

