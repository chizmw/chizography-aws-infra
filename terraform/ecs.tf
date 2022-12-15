# Create the ECS cluster
resource "aws_ecs_cluster" "ecs_cluster_websites" {
  # checkov:skip=CKV_AWS_65: ADD REASON
  name = "websites"
}


# Create nginx reverse proxy service in ECS cluster
resource "aws_ecs_service" "nginx" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.ecs_cluster_websites.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1
}

# Create ECS task definition for nginx reverse proxy
resource "aws_ecs_task_definition" "nginx" {
  family                = "nginx"
  container_definitions = <<DEFINITION
[
  {
    "name": "nginx",
    "image": "nginx:latest",
    "memory": 256,
    "cpu": 256,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ],
    "essential": true
  }
]
DEFINITION
}

# create ECR for any docker images we use in the websites
resource "aws_ecr_repository" "websites" {
  name                 = "websites"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
  }
}
