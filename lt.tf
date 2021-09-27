#---------------------------------------------------
# Launch AWS template
#---------------------------------------------------
resource "aws_launch_template" "lt" {
  name_prefix = "ghost_ec2_"
  description = "Launch template for ghost app"

  # image_id                             = "ami-087c17d1fe0178315"
  image_id                             = "ami-05ed15c5d0d793f9f"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"

  disable_api_termination = false
  # ebs_optimized           = true
  key_name                = "aws-learn"
  user_data               = base64encode(templatefile("additional_files/pub-host.yaml", { db_url_tpl = aws_db_instance.default.address}))

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [aws_security_group.sg_ec2_pool.id]
    ipv6_addresses              = null
  }

  iam_instance_profile {
    arn  = aws_iam_instance_profile.ec2_profile.arn
  }

  tags = merge(
    {
      Name = "ghost_ec2_lt_instance"
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
    aws_iam_instance_profile.ec2_profile,
    aws_vpc_endpoint_subnet_association.ssm,
    aws_vpc_endpoint_subnet_association.dkr,
    aws_vpc_endpoint_subnet_association.api,
    aws_vpc_endpoint_subnet_association.cwatch
  ]
}
