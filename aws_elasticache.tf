resource "aws_elasticache_replication_group" "main_redis" {
  replication_group_id = "my-redis"
  replication_group_description = "test description"
  engine = "redis"
  engine_version = "2.8.23"
  node_type = "cache.m3.medium"
  port = 6379
  subnet_group_name = "my-redis"
  security_group_ids = ["sg-..."]
  automatic_failover_enabled = true
  parameter_group_name = "default.redis2.8"
  at_rest_encryption_enabled = false
  transit_encryption_enabled = false
  maintenance_window = "sun:06:00-sun:07:00"
  auto_minor_version_upgrade = false
  apply_immediately = true
}

resource "aws_elasticache_cluster" "main_redis_001" {
  cluster_id = "my-redis-001"
  replication_group_id = "${aws_elasticache_replication_group.main_redis.id}"
  availability_zone = "us-east-1b"
  apply_immediately = true
}

resource "aws_elasticache_cluster" "main_redis_002" {
  cluster_id = "my-redis-001"
  replication_group_id = "${aws_elasticache_replication_group.main_redis.id}"
  availability_zone = "us-east-1b"
  apply_immediately = true
}


/*
  


resource "aws_elasticache_cluster" "main_redis_002" {
  cluster_id = "my-redis-002"
  replication_group_id = "${aws_elasticache_replication_group.main_redis.id}"
  availability_zone = "us-east-1a"
  apply_immediately = true
}*/
