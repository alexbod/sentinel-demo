policy "forbid-public-sqs-queues" {
    enforcement_level = "hard-mandatory"
}

/*
module "timezone" {
  source = "./modules/timezone.sentinel"
}

policy "test_modules" {
    enforcement_level = "hard-mandatory"
}


policy "require_logging_for_api_gateway" {
    enforcement_level = "hard-mandatory"
}

policy "require-PGP-key-for-IAM-access-keys" {
    enforcement_level = "advisory"
}

policy "require-KMS-keys-rotation" {
    enforcement_level = "advisory"
}

policy "require-object-versioning-for-s3-buckets" {
    enforcement_level = "advisory"
}

policy "require-vpc-flow-logs" {
    enforcement_level = "advisory"
}*/
