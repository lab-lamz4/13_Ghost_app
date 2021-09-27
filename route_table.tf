#---------------------------------------------------
# AWS Route table public
#---------------------------------------------------
resource "aws_route_table" "public_route_tables" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = "public_rt"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_vpc.vpc
  ]
}

#---------------------------------------------------
# AWS Route table private
#---------------------------------------------------
resource "aws_route_table" "private_route_tables" {
  vpc_id = aws_vpc.vpc.id

  
  tags = merge(
    {
      Name = "private_rt"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_vpc.vpc
  ]
}