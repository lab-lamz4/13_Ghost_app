#---------------------------------------------------
# Create AWS ASG
#---------------------------------------------------
resource "aws_autoscaling_group" "asg" {
  name        = "ghost_asg"
  vpc_zone_identifier = aws_subnet.public_subnets.*.id
  max_size            = 2
  min_size            = 1
  desired_capacity    = 1

  health_check_grace_period = 500
  health_check_type         = "EC2"
  default_cooldown          = 20

  target_group_arns     = [aws_lb_target_group.alb_target_group_ec2.arn]

  force_delete              = true
  wait_for_capacity_timeout = 0

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tags = [
    {
      key                 = "Orchestration"
      value               = "Terraform"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "learning"
      propagate_at_launch = true
    }
  ]

  lifecycle {
    create_before_destroy = false
    ignore_changes        = []
  }

  depends_on = [
    aws_lb_target_group.alb_target_group_ec2,
    aws_launch_template.lt
  ]
}

resource "aws_autoscaling_policy" "cpu" {
  name                   = "ghost_asg_scaling_policy"
  autoscaling_group_name = "ghost_asg"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
  depends_on = [
    aws_autoscaling_group.asg
  ]
}