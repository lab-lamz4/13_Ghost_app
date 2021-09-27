#---------------------------------------------------
# AWS security group
#---------------------------------------------------

resource "aws_security_group" "sg_alb" {
  name                   = "alb"
  description            = "defines access to alb"
  vpc_id                 = aws_vpc.vpc.id

  ingress = [
    {
      description      = "HTTP from ALL"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [var.vpc_cidr_block]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [var.vpc_cidr_block]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = merge(
    {
      Name = "alb"
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

resource "aws_security_group" "sg_ec2_pool" {
  name                   = "ec2_pool"
  description            = "allows access for ec2 instances"
  vpc_id                 = aws_vpc.vpc.id

  ingress = [
    {
      description      = "SSH from ALL"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "2049 from vpc"
      from_port        = 2049
      to_port          = 2049
      protocol         = "tcp"
      cidr_blocks      = [var.vpc_cidr_block]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "2368 from alb"
      from_port        = 2368
      to_port          = 2368
      protocol         = "tcp"
      cidr_blocks      = null
      security_groups  = [aws_security_group.sg_alb.id]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
    }

  ]

  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]


  tags = merge(
    {
      Name = "ec2_pool"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_vpc.vpc,
    aws_security_group.sg_alb
  ]
}

resource "aws_security_group" "sg_fargate_pool" {
  name                   = "fargate_pool"
  description            = "allows access for fargate instances"
  vpc_id                 = aws_vpc.vpc.id

  ingress = [
    {
      description      = "2049 from vpc"
      from_port        = 2049
      to_port          = 2049
      protocol         = "tcp"
      cidr_blocks      = [var.vpc_cidr_block]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "2368 from alb"
      from_port        = 2368
      to_port          = 2368
      protocol         = "tcp"
      cidr_blocks      = null
      security_groups  = [aws_security_group.sg_alb.id]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
    }

  ]

  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]


  tags = merge(
    {
      Name = "fargate_pool"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_vpc.vpc,
    aws_security_group.sg_alb
  ]
}

resource "aws_security_group" "sg_mysql" {
  name                   = "mysql"
  description            = "defines access to ghost db"
  vpc_id                 = aws_vpc.vpc.id

  ingress = [
    {
      description      = "3306 from ec2"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = null
      security_groups  = [aws_security_group.sg_ec2_pool.id]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
    },
    {
      description      = "3306 from fargate_pool"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = null
      security_groups  = [aws_security_group.sg_fargate_pool.id]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
    }

  ]

  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]


  tags = merge(
    {
      Name = "mysql"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_vpc.vpc,
    aws_security_group.sg_ec2_pool,
    aws_security_group.sg_fargate_pool
  ]
}

resource "aws_security_group" "sg_efs" {
  name                   = "efs"
  description            = "defines access to efs mount points"
  vpc_id                 = aws_vpc.vpc.id

  ingress = [
    {
      description      = "2049 from ec2"
      from_port        = 2049
      to_port          = 2049
      protocol         = "tcp"
      cidr_blocks      = null
      security_groups  = [aws_security_group.sg_ec2_pool.id]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
    },
    {
      description      = "2049 from fargate_pool"
      from_port        = 2049
      to_port          = 2049
      protocol         = "tcp"
      cidr_blocks      = null
      security_groups  = [aws_security_group.sg_fargate_pool.id]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
    }

  ]

  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [var.vpc_cidr_block]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]


  tags = merge(
    {
      Name = "efs"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_vpc.vpc,
    aws_security_group.sg_ec2_pool,
    aws_security_group.sg_fargate_pool
  ]
}

resource "aws_security_group" "sg_vpc_endpoint" {
  name                   = "vpc_endpoint"
  description            = "defines access to vpc endpoints"
  vpc_id                 = aws_vpc.vpc.id

  ingress = [
    {
      description      = "443 from vpc"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = [var.vpc_cidr_block]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]


  tags = merge(
    {
      Name = "vpc_endpoint"
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
