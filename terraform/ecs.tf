# Create the ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "websites"
}
