// FILE: infra/terraform/ssm.tf
// changed

resource "aws_ssm_document" "deploy" {
  name          = "NodejsShopping-DockerDeploy"
  document_type = "Command"

  depends_on = [
    aws_cloudwatch_log_group.ssm // added
  ]

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Deploy NodeJS app via docker-compose"

    mainSteps = [{
      action = "aws:runShellScript"
      name   = "deploy"

      inputs = {
        runCommand = [
          "set -euxo pipefail",

          "apt-get update -y",
          "apt-get install -y docker.io docker-compose-plugin",

          "systemctl enable docker",
          "systemctl start docker",

          "mkdir -p /opt/app",
          "cd /opt/app",

          "cat > docker-compose.yml <<'EOF'",
          "version: '3.8'",
          "services:",
          "  app:",
          "    image: ${var.image}",
          "    container_name: nodejs-shopping-app",
          "    ports:",
          "      - \"80:3000\"",
          "    environment:",
          "      PORT: \"3000\"",
          "      MONGODB_URI: \"mongodb://mongo:27017/shop\"",
          "  mongo:",
          "    image: mongo:6",
          "    container_name: mongo",
          "    volumes:",
          "      - mongo-data:/data/db",
          "volumes:",
          "  mongo-data:",
          "EOF",

          "docker compose pull",
          "docker compose up -d"
        ]

        cloudWatchOutputConfig = {
          cloudWatchLogGroupName  = "/ssm/nodejs-shopping"
          cloudWatchOutputEnabled = true
        }
      }
    }]
  })
}
