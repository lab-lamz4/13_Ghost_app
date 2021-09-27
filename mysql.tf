#---------------------------------------------------------------
# AWS rds 
#---------------------------------------------------------------

resource "aws_db_instance" "default" {
  identifier           = "ghost-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = "ghost"
  username             = "ghost"
  password             = var.dbpassword
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  multi_az             = true
  
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.sg_mysql.id]

  tags = merge(
    {
      Name = "MySQLDB"
    },
    var.tags
  )
}

resource "aws_db_subnet_group" "default" {
  name        = "db-subnets"
  subnet_ids  = [for subnet in aws_subnet.privatedb_subnet: subnet.id]
  description = "Db multiaz subnets"

  tags = merge(
    {
      Name = "MySQLDB"
    },
    var.tags
  )
}

resource "aws_ssm_parameter" "secret" {
  name        = "/ghost/dbpassw"
  description = "Masterpassword for mysql"
  type        = "SecureString"
  value       = var.dbpassword

  tags = merge(
    {
      Name = "masterpassword"
    },
    var.tags
  )
}