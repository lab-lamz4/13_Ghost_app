resource "aws_ecr_repository" "ecr_repository" {
  name                 = "ecr-ghost"
  image_tag_mutability = "MUTABLE"
  tags = merge(
    {
      Name = "ecr-ghost"
    },
    var.tags
  )
}