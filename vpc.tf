#---------------------------------------------------------------
# AWS VPC
#---------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block = cidrsubnet(var.vpc_cidr_block, 0, 0)

  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = merge(
    {
      Name = "cloudx"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = []
}