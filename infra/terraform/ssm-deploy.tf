// FILE: infra/terraform/ssm-deploy.tf

locals {
  ssm_document_name = "NodejsShopping-DockerComposeDeploy-v1" // bump on logic change
}

resource "aws_ssm_document" "docker_compose_deploy" {
  name          = local.ssm_document_name
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Deploy Nodejs Shopping app using docker-compose from GitHub"

    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "deploy"
        inputs = {
          runCommand = [
            "set -euo pipefail",

            "APP_DIR=/opt/nodejs-shopping",
            "REPO_URL=https://github.com/tsemba/nodejs-shopping-cicd.git",

            # Ensure docker-compose exists (legacy binary)
            "if ! command -v docker-compose >/dev/null 2>&1; then",
            "  apt-get update -y",
            "  apt-get install -y docker-compose",
            "fi",

            # Clone repo if not exists
            "if [ ! -d \"$APP_DIR/.git\" ]; then",
            "  mkdir -p \"$APP_DIR\"",
            "  git clone \"$REPO_URL\" \"$APP_DIR\"",
            "fi",

            "cd \"$APP_DIR\"",

            # Pull latest code
            "git pull",

            # Pull images & restart stack
            "docker-compose pull",
            "docker-compose up -d",

            # Cleanup unused images
            "docker image prune -f"
          ]
        }
      }
    ]
  })
}
