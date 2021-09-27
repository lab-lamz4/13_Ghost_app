#---------------------------------------------------------------
# AWS route Internet GW
#---------------------------------------------------------------
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public_route_tables.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_route_table.public_route_tables,
    aws_internet_gateway.internet_gateway
  ]
}