#-----------------------------------------------------------
# IAM Role
#-----------------------------------------------------------
resource "aws_iam_role" "iam_role" {
  name        = "ghost_app_role"
  description = "EC2 & Fargate access to services"

  assume_role_policy = file("additional_files/assume_role_policy.json")

  force_detach_policies = true
  path                  = "/"

  tags = merge(
    {
      Name = "ghost_app_role"
    },
    var.tags
  )

  depends_on = []
}

resource "aws_iam_role" "iam_role_ex" {
  name        = "ghost_ecs_ex"
  description = "EC2 & Fargate execution"

  assume_role_policy = file("additional_files/assume_role_policy_ex.json")

  force_detach_policies = true
  path                  = "/"

  tags = merge(
    {
      Name = "ghost_app_role"
    },
    var.tags
  )

  depends_on = []
}

resource "aws_iam_role_policy_attachment" "iam_role_ex" {
  role       = aws_iam_role.iam_role_ex.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#-----------------------------------------------------------
# IAM role policy
#-----------------------------------------------------------
resource "aws_iam_role_policy" "iam_role_policy" {
  name        = "ghost_app_role_policy"

  role   = aws_iam_role.iam_role.id
  policy = file("additional_files/policy.json")

  depends_on = [
    aws_iam_role.iam_role
  ]
}

#-----------------------------------------------------------
# IAM profile 
#-----------------------------------------------------------

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.iam_role.name
}
