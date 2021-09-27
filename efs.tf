#---------------------------------------------------
# AWS EFS file system
#---------------------------------------------------
resource "aws_efs_file_system" "efs_file_system" {
  encrypted        = false
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = merge(
    {
      Name = "efs_ghost"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = []
}

#---------------------------------------------------
# AWS EFS mount target
#---------------------------------------------------
locals {
  public_az_ids   = [
    for s in aws_subnet.private_subnets : s.id
  ]

  private_az_ids  = [
    for s in aws_subnet.public_subnets : s.id
  ]

  all_mp_subnets = concat(local.public_az_ids, local.private_az_ids)
}


resource "aws_efs_mount_target" "efs_mount_targets" {
  count = length(aws_subnet.public_subnets.*.id)

  file_system_id  = aws_efs_file_system.efs_file_system.id
  subnet_id       = aws_subnet.public_subnets.*.id[count.index]
  security_groups = [aws_security_group.sg_efs.id]

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_efs_file_system.efs_file_system
  ]
}

