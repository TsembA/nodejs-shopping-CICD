# FILE: infra/terraform/ssm-deploy.tf

resource "aws_ssm_document" "docker_deploy" {
  name          = "NodejsShopping-DockerDeploy"
  document_type = "Command"

  lifecycle {
    create_before_destroy = true // added
  }

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Deploy Nodejs Shopping Docker container from GHCR"

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

            # Explicit region for AWS CLI inside SSM
            "export AWS_REGION=us-west-1",

            # Ensure jq exists (idempotent)
            "command -v jq >/dev/null 2>&1 || (apt-get update -y && apt-get install -y jq)",

            # Fetch GHCR credentials
            "SECRET_JSON=$(aws secretsmanager get-secret-value --region $AWS_REGION --secret-id ghcr/nodejs-shopping --query SecretString --output text)",
            "GHCR_USER=$(echo \"$SECRET_JSON\" | jq -r .username)",
            "GHCR_TOKEN=$(echo \"$SECRET_JSON\" | jq -r .token)",

            # Validate secrets
            "[ -n \"$GHCR_USER\" ] || (echo 'ERROR: GHCR username empty' && exit 1)",
            "[ -n \"$GHCR_TOKEN\" ] || (echo 'ERROR: GHCR token empty' && exit 1)",

            # Login to GHCR
            "echo \"$GHCR_TOKEN\" | docker login ghcr.io -u \"$GHCR_USER\" --password-stdin",

            # Deploy container
            "docker pull {{ Image }}",
            "docker stop nodejs-shopping || true",
            "docker rm nodejs-shopping || true",
            "docker run -d --restart unless-stopped --name nodejs-shopping -p 80:3000 {{ Image }}"
          ]
        }
      }
    ]
  })
}
