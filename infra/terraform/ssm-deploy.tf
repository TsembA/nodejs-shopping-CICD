# FILE: infra/terraform/ssm-deploy.tf

resource "aws_ssm_document" "docker_compose_deploy" {
  name            = "NodejsShopping-DockerDeploy-v1"
  document_type   = "Command"
  document_format = "JSON"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Deploy Nodejs Shopping via docker-compose"

    parameters = {
      Image = {
        type        = "String"
        description = "Docker image tag to deploy"
      }
    }

    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "deploy"
        inputs = {
          runCommand = [
            "set -eu",

            "APP_DIR=/opt/nodejs-shopping",
            "mkdir -p $$APP_DIR",
            "cd $$APP_DIR",

            # Fetch secret (SINGLE LINE – Terraform safe)
            "SESSION_SECRET=$$(aws secretsmanager get-secret-value --secret-id nodejs-shopping/prod/session-secret --query SecretString --output text)",

            # Write env file
            "echo \"SESSION_SECRET=$$SESSION_SECRET\" > .env",
            "echo \"IMAGE={{ Image }}\" >> .env",

            # Deploy
            "docker-compose pull",
            "docker-compose up -d --force-recreate"
          ]
        }
      }
    ]
  })
}
