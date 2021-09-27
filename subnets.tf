#---------------------------------------------------------------
# AWS subnets (private) ECS
#---------------------------------------------------------------
resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidrs)

  cidr_block              = var.private_subnet_cidrs[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = length(var.azs) > 0 ? var.azs[count.index] : element(lookup(var.availability_zones, var.region), count.index)

  tags = merge(
    {
      Name = "private_${element(lookup(var.availability_zones, var.region), count.index)}"
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

#---------------------------------------------------------------
# AWS subnets (private) DB
#---------------------------------------------------------------
resource "aws_subnet" "privatedb_subnet" {
  count = length(var.privatedb_subnet_cidrs)

  cidr_block              = var.privatedb_subnet_cidrs[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = length(var.azs) > 0 ? var.azs[count.index] : element(lookup(var.availability_zones, var.region), count.index)

  tags = merge(
    {
      Name = "private_db_${element(lookup(var.availability_zones, var.region), count.index)}"
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

#---------------------------------------------------------------
# Add AWS subnets (public) EC2
#---------------------------------------------------------------
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidrs)

  cidr_block              = var.public_subnet_cidrs[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = length(var.azs) > 0 ? var.azs[count.index] : element(lookup(var.availability_zones, var.region), count.index)

  tags = merge(
    {
      Name = "public_${element(lookup(var.availability_zones, var.region), count.index)}"
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
