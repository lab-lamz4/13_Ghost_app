resource "aws_vpc_endpoint" "ssm" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.sg_vpc_endpoint.id]
  private_dns_enabled = true

  tags = merge(
    {
      Name = "ssm-endpoint"
    },
    var.tags
  )

  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_vpc_endpoint_subnet_association" "ssm" {
  count = length(aws_subnet.private_subnets.*.id)

  vpc_endpoint_id = aws_vpc_endpoint.ssm.id
  subnet_id       = aws_subnet.private_subnets.*.id[count.index]

  depends_on = [
    aws_vpc.vpc,
    aws_vpc_endpoint.ssm,
    aws_subnet.private_subnets
  ]
}

# resource "aws_vpc_endpoint_route_table_association" "ssm" {
#   route_table_id  = aws_route_table.private_route_tables.id
#   vpc_endpoint_id = aws_vpc_endpoint.ssm.id

#   depends_on = [
#     aws_route_table.private_route_tables,
#     aws_vpc_endpoint.ssm
#   ]
# }


resource "aws_vpc_endpoint" "dkr" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.ecr.dkr"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.sg_vpc_endpoint.id]
  private_dns_enabled = true

  tags = merge(
    {
      Name = "ecr-endpoint"
    },
    var.tags
  )

  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_vpc_endpoint_subnet_association" "dkr" {
  count = length(aws_subnet.private_subnets.*.id)
  
  vpc_endpoint_id = aws_vpc_endpoint.dkr.id
  subnet_id       = aws_subnet.private_subnets.*.id[count.index]

  depends_on = [
    aws_vpc.vpc,
    aws_vpc_endpoint.dkr,
    aws_subnet.private_subnets
  ]
}

resource "aws_vpc_endpoint" "api" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.ecr.api"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.sg_vpc_endpoint.id]
  private_dns_enabled = true

  tags = merge(
    {
      Name = "ecr-endpoint"
    },
    var.tags
  )

  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_vpc_endpoint_subnet_association" "api" {
  count = length(aws_subnet.private_subnets.*.id)
  
  vpc_endpoint_id = aws_vpc_endpoint.api.id
  subnet_id       = aws_subnet.private_subnets.*.id[count.index]

  depends_on = [
    aws_vpc.vpc,
    aws_vpc_endpoint.api,
    aws_subnet.private_subnets
  ]
}


# resource "aws_vpc_endpoint_route_table_association" "ecr" {
#   route_table_id  = aws_route_table.private_route_tables.id
#   vpc_endpoint_id = aws_vpc_endpoint.ecr.id

#   depends_on = [
#     aws_route_table.private_route_tables,
#     aws_vpc_endpoint.ecr
#   ]
# }

resource "aws_vpc_endpoint" "cwatch" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.logs"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.sg_vpc_endpoint.id]
  private_dns_enabled = true

  tags = merge(
    {
      Name = "CloudWatch-endpoint"
    },
    var.tags
  )

  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_vpc_endpoint_subnet_association" "cwatch" {
  count = length(aws_subnet.private_subnets.*.id)
  
  vpc_endpoint_id = aws_vpc_endpoint.cwatch.id
  subnet_id       = aws_subnet.private_subnets.*.id[count.index]

  depends_on = [
    aws_vpc.vpc,
    aws_vpc_endpoint.cwatch,
    aws_subnet.private_subnets
  ]
  
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  route_table_id  = aws_route_table.private_route_tables.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}