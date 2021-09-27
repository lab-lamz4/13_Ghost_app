#---------------------------------------------------
# Create AWS ECS cluster
#---------------------------------------------------
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ghost-ecs-cluster"

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = "80"
    base              = 1
  }

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = "20"
    base              = null
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    {
      Name = "ghost-ecs-cluster"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = []
}

#---------------------------------------------------
# Create AWS ECS task definition
#---------------------------------------------------
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                = "ghost-app"

  container_definitions = templatefile("./additional_files/ecs/container_definitions.json", {
    db_url_tpl  = aws_db_instance.default.address,
    image       = aws_ecr_repository.ecr_repository.repository_url,
    ssm_arn     = aws_ssm_parameter.secret.arn
  })

  task_role_arn      = aws_iam_role.iam_role.arn
  execution_role_arn = aws_iam_role.iam_role.arn
  network_mode       = "awsvpc"
  cpu                      = 256
  memory                   = 1024
  requires_compatibilities = ["FARGATE"]

  volume {
    name = "web-storage"

    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.efs_file_system.id
      root_directory          = "/"
      # authorization_config {
      #   access_point_id = aws_efs_access_point.test.id
      #   iam             = "ENABLED"
      # }
    }
  }

  tags = merge(
    {
      Name = "ecs-task-ghost"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_subnet.public_subnets,
    aws_security_group.sg_ec2_pool,
    aws_efs_file_system.efs_file_system,
    aws_iam_instance_profile.ec2_profile,
    aws_vpc_endpoint_subnet_association.ssm,
    aws_vpc_endpoint_subnet_association.dkr,
    aws_vpc_endpoint_subnet_association.api,
    aws_vpc_endpoint_subnet_association.cwatch,
    aws_vpc_endpoint_route_table_association.s3
  ]
}

#---------------------------------------------------
# Create AWS ECS service
#---------------------------------------------------
resource "aws_ecs_service" "ecs_service" {
  name            = "ghost_service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.id
  desired_count   = 1

  launch_type         = "FARGATE"
  platform_version    = "LATEST"
  scheduling_strategy = "REPLICA"

  force_new_deployment               = true

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    subnets           = aws_subnet.private_subnets.*.id
    security_groups   = [aws_security_group.sg_fargate_pool.id]
    assign_public_ip  = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group_ecs.arn
    container_name   = "ghost-app"
    container_port   = 2368
  }

  tags = merge(
    {
      Name = "ecs-service-ghost"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = false
    ignore_changes        = []
  }

  depends_on = [
    aws_ecs_cluster.ecs_cluster,
    aws_ecs_task_definition.ecs_task_definition
  ]
}
