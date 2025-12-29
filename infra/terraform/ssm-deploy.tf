resource "aws_ssm_document" "docker_compose_deploy" {
  name          = "NodejsShopping-DockerDeploy-v1"
  document_type = "Command"
  document_format = "JSON"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Deploy Nodejs Shopping via docker-compose"

    parameters = {
      Image = {
        type        = "String"
        description = "Docker image tag to deploy"
      }
      SessionSecret = {
        type        = "String"
        description = "Session secret for app"
      }
    }

    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "deploy"
        inputs = {
          runCommand = [
            "set -e",

            "mkdir -p /opt/nodejs-shopping",
            "cd /opt/nodejs-shopping",

            # Write docker-compose.prod.yml
            "cat > docker-compose.yml << 'EOF'\nversion: \"3.8\"\n\nservices:\n  app:\n    image: {{ Image }}\n    container_name: nodejs-shopping-app\n    ports:\n      - \"80:3000\"\n    environment:\n      PORT: \"3000\"\n      MONGODB_URI: \"mongodb://mongo:27017/shop\"\n      SESSION_SECRET: \"{{ SessionSecret }}\"\n    depends_on:\n      - mongo\n    restart: unless-stopped\n\n  mongo:\n    image: mongo:6\n    container_name: nodejs-shopping-mongo\n    volumes:\n      - mongo-data:/data/db\n    restart: unless-stopped\n\nvolumes:\n  mongo-data:\nEOF",

            "docker-compose pull",
            "docker-compose up -d"
          ]
        }
      }
    ]
  })
}
