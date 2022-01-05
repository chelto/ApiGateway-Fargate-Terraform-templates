

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.name_prefix}-task_v2-5-4"
  tags                     = var.default_tags
  task_role_arn            = var.controller_task_role_arn != null ? var.controller_task_role_arn : aws_iam_role.fargate_task_role.arn
  execution_role_arn       = var.ecs_execution_role_arn != null ? var.ecs_execution_role_arn : aws_iam_role.fargate_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.controller_cpu
  memory                   = var.controller_memory
  container_definitions = jsonencode([
  {
      command = var.command_args
      image     = "${aws_ecr_repository.ecr.repository_url}:latest"
      account_id = local.account_id
      region = var.region
      log_group = "/ecs/${var.name_prefix}"
      memory = var.controller_memory
      memoryReservation = var.controller_memory
      cpu = var.controller_cpu 
      ecs_cluster_fargate = aws_ecs_cluster.sidecar.arn
      cluster_region = var.region
      side_controller_port = var.controller_port
      agent_security_groups = aws_security_group.sidecar_security_group.id
      execution_role_arn = aws_iam_role.fargate_task_role.arn 
      name = "${var.name_prefix}-task"
      essential = true
      portMappings = [
        {
          containerPort = var.controller_port
        }
      ]
      logConfiguration= {
        logDriver = "awslogs"
        options = {
            awslogs-group = "/ecs/${var.name_prefix}"
            awslogs-region= var.region
            awslogs-stream-prefix = "controller"
        }
      }
      
      }
    ])
}

