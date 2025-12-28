locals {
  ssm_document_name = "NodejsShopping-DockerComposeDeploy-v1"
}

resource "aws_ssm_document" "docker_compose_deploy" {
  name          = local.ssm_document_name
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Deploy Nodejs Shopping via docker-compose"

    parameters = {
      Image = {
        type        = "String"
        description = "Docker image to deploy from GHCR"
      }
    }

    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "deploy"
        inputs = {
          runCommand = [
            "set -euo pipefail",

            "export AWS_REGION=us-west-1",
            "export IMAGE='{{ Image }}'",

            "mkdir -p /opt/nodejs-shopping",
            "cd /opt/nodejs-shopping",

            # Ensure docker-compose exists
            "command -v docker-compose >/dev/null 2>&1 || (echo 'docker-compose missing' && exit 1)",

            # Fetch GHCR credentials
            "SECRET_JSON=$(aws secretsmanager get-secret-value --region $AWS_REGION --secret-id ghcr/nodejs-shopping --query SecretString --output text)",
            "GHCR_USER=$(echo \"$SECRET_JSON\" | jq -r .username)",
            "GHCR_TOKEN=$(echo \"$SECRET_JSON\" | jq -r .token)",

            "[ -n \"$GHCR_USER\" ] || (echo 'GHCR username empty' && exit 1)",
            "[ -n \"$GHCR_TOKEN\" ] || (echo 'GHCR token empty' && exit 1)",

            "echo \"$GHCR_TOKEN\" | docker login ghcr.io -u \"$GHCR_USER\" --password-stdin",

            # Write docker-compose file (idempotent)
            "cat > docker-compose.yml << 'EOF'\nversion: \"3.8\"\n\nservices:\n  app:\n    image: ${IMAGE}\n    container_name: nodejs-shopping-app\n    ports:\n      - \"80:3000\"\n    environment:\n      PORT: \"3000\"\n      MONGODB_URI: \"mongodb://mongo:27017/shop\"\n      SESSION_SECRET: \"prod-secret\"\n    depends_on:\n      - mongo\n    restart: unless-stopped\n\n  mongo:\n    image: mongo:6\n    container_name: nodejs-shopping-mongo\n    volumes:\n      - mongo-data:/data/db\n    restart: unless-stopped\n\nvolumes:\n  mongo-data:\nEOF",

            # Deploy
            "docker-compose pull",
            "docker-compose up -d"
          ]
        }
      }
    ]
  })
}
