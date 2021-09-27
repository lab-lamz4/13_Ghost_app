#---------------------------------------------------
# AWS ALB
#---------------------------------------------------
resource "aws_lb" "alb" {
  name        = "ghost-alb"

  security_groups = [aws_security_group.sg_alb.id]
  subnets         = aws_subnet.public_subnets.*.id
  internal        = false

  load_balancer_type               = "application"
  ip_address_type                  = "ipv4"


  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  tags = merge(
    {
      Name = "ghost-alb"
    },
    var.tags
  )

  depends_on = [
      aws_vpc.vpc,
      aws_subnet.public_subnets
  ]
}

#---------------------------------------------------
# AWS LB target group
#---------------------------------------------------
resource "aws_lb_target_group" "alb_target_group_ec2" {
  name        = "ghost-ec2"

  port                 = "2368"
  protocol             = "HTTP"
  vpc_id               = aws_vpc.vpc.id
  target_type          = "instance"
#   slow_start           = 120

  health_check {
      enabled             = true
      port                = 2368
      protocol            = "HTTP"
      interval            = 10
      path                = "/"
      healthy_threshold   = 3
      unhealthy_threshold = 3
      timeout             = 5
      matcher             = "200-299"
  }

  tags = merge(
    {
      Name = "ghost-ec2"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = []
}

resource "aws_lb_target_group" "alb_target_group_ecs" {
  name        = "ghost-fargate"

  port                 = "2368"
  protocol             = "HTTP"
  vpc_id               = aws_vpc.vpc.id
  target_type          = "ip"
#   slow_start           = 120

  health_check {
      enabled             = true
      port                = 2368
      protocol            = "HTTP"
      interval            = 10
      path                = "/"
      healthy_threshold   = 3
      unhealthy_threshold = 3
      timeout             = 5
      matcher             = "200-299"
  }

  tags = merge(
    {
      Name = "ghost-fargate"
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
# AWS LB listeners
#---------------------------------------------------
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    forward {
        target_group {
            arn     = aws_lb_target_group.alb_target_group_ec2.arn
            weight  = 50
        }
        target_group {
            arn     = aws_lb_target_group.alb_target_group_ecs.arn
            weight  = 50
        }
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_lb.alb,
    aws_lb_target_group.alb_target_group_ec2,
    aws_lb_target_group.alb_target_group_ecs
  ]
}
