# FILE: infra/terraform/ssm-deploy.tf

locals {
  ssm_document_name = "NodejsShopping-DockerDeploy-v1" # bump version when logic changes
}

resource "aws_ssm_document" "docker_deploy" {
  name          = local.ssm_document_name
  document_type = "Command"

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
        name   = "deploy"
        action = "aws:runShellScript"

        inputs = {
          runCommand = [
            # Fail fast, no undefined vars
            "set -eu",

            # Explicit region for AWS CLI
            "export AWS_REGION=us-west-1",

            # Ensure jq exists (SSM has no TTY, keep non-interactive)
            "command -v jq >/dev/null 2>&1 || (apt-get update -y && apt-get install -y jq)",

            # Stop and remove existing container FIRST (idempotent)
            "docker stop nodejs-shopping || true",
            "docker rm nodejs-shopping || true",

            # Fetch GHCR credentials from Secrets Manager
            "SECRET_JSON=$(aws secretsmanager get-secret-value --region $AWS_REGION --secret-id ghcr/nodejs-shopping --query SecretString --output text)",
            "GHCR_USER=$(echo \"$SECRET_JSON\" | jq -r .username)",
            "GHCR_TOKEN=$(echo \"$SECRET_JSON\" | jq -r .token)",

            # Validate secrets
            "[ -n \"$GHCR_USER\" ] || (echo 'ERROR: GHCR username is empty' && exit 1)",
            "[ -n \"$GHCR_TOKEN\" ] || (echo 'ERROR: GHCR token is empty' && exit 1)",

            # Authenticate to GHCR
            "echo \"$GHCR_TOKEN\" | docker login ghcr.io -u \"$GHCR_USER\" --password-stdin",

            # Pull and start container LAST
            "docker pull {{ Image }}",
            "docker run -d --restart unless-stopped --name nodejs-shopping -p 80:3000 {{ Image }}"
          ]
        }
      }
    ]
  })
}
