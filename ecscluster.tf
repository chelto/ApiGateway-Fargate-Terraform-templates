provider "aws" {
  profile = "default"
  region  = var.region
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id
  tags = {
    subnet_type = "private"
  }
}

data "aws_route_table" "selected" {
  for_each  = data.aws_subnet_ids.private.ids
  subnet_id = each.value
}

#create dns name
resource "aws_service_discovery_private_dns_namespace" "private_dns" {
  name        = "${var.name_prefix}-dns"
  description = "service discovery endpoint"
  vpc         = var.vpc_id
  tags        = var.default_tags
}

#attach dns name to ecsservice discovery
resource "aws_service_discovery_service" "service_discovery" {
  name = "${var.name_prefix}-discovery"
  tags = var.default_tags
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.private_dns.id
    dns_records {
      ttl  = 10
      type = "A"
    }
    dns_records {
      ttl  = 10
      type = "SRV"
    }
    routing_policy = "MULTIVALUE"
  }
  health_check_custom_config {
    failure_threshold = 3
  }
}

#create ecr repo for ecs docker images
resource "aws_ecr_repository" "ecr" {
  name                 = "${var.name_prefix}-discovery"
  image_tag_mutability = "MUTABLE"
  tags                 = var.default_tags
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "sidecar" {
  name               = "${var.name_prefix}-cluster"
  capacity_providers = ["FARGATE"]
  tags               = var.default_tags
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}



#create ecs service and bind to cluster for manager
resource "aws_ecs_service" "sidecar" {
  name            = "${var.name_prefix}-service"
  cluster         = aws_ecs_cluster.sidecar.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = data.aws_subnet_ids.private.ids
    security_groups  = [aws_security_group.sidecar_security_group.id]
    assign_public_ip = false
  }
  service_registries {
    registry_arn   = aws_service_discovery_service.service_discovery.arn
    container_name = "${var.name_prefix}-task"
    container_port = var.controller_port
  }
}

