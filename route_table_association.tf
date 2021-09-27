#---------------------------------------------------
# AWS Route Table Associations
#---------------------------------------------------

# private
resource "aws_route_table_association" "private_route_table_associations" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_route_tables.id

  depends_on = [
    aws_route_table.private_route_tables,
    aws_subnet.private_subnets
  ]
}

# private db
resource "aws_route_table_association" "privatedb_route_table_associations" {
  count = length(var.privatedb_subnet_cidrs)

  subnet_id      = element(aws_subnet.privatedb_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route_tables.id

  depends_on = [
    aws_route_table.private_route_tables,
    aws_subnet.privatedb_subnet
  ]
}

# public
resource "aws_route_table_association" "public_route_table_associations" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_route_tables.id

  depends_on = [
    aws_route_table.public_route_tables,
    aws_subnet.public_subnets
  ]
}
