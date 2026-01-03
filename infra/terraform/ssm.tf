############################################
# SSM Document – Docker Compose Deployment
############################################
resource "aws_ssm_document" "deploy" {
  name          = "NodejsShopping-DockerDeploy"
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Deploy NodeJS app via docker-compose"

    parameters = {
      IMAGE = {
        type        = "String"
        description = "Docker image to deploy"
      }
    }

    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "deploy"

        inputs = {
          runCommand = [
            "set -e",

            # Install Docker
            "apt-get update -y",
            "apt-get install -y docker.io docker-compose",
            "systemctl enable docker",
            "systemctl start docker",

            # App directory
            "mkdir -p /opt/app",
            "cd /opt/app",

            # Write docker-compose.yml
            "cat > docker-compose.yml <<'EOF'",
            file("${path.module}/../app/docker-compose.yml"),
            "EOF",

            # Runtime env
            "echo IMAGE={{ IMAGE }} > .env",

            # Deploy
            "docker compose pull",
            "docker compose up -d"
          ]
        }
      }
    ]
  })
}

############################################
# SSM Association – Auto Deploy
############################################
resource "aws_ssm_association" "deploy_app" {
  name = aws_ssm_document.deploy.name

  parameters = {
    IMAGE = [var.image]
  }

  targets {
    key    = "InstanceIds"
    values = [aws_instance.app.id]
  }

  depends_on = [
    aws_instance.app,
    aws_ssm_document.deploy
  ]
}
