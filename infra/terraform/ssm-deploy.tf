resource "aws_ssm_document" "docker_deploy" {
  name          = "NodejsShopping-DockerDeploy"
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Deploy Nodejs Shopping Docker container from GHCR"

    parameters = {
      Image = {
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

            # --- Fetch GHCR creds from Secrets Manager ---
            "SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id ghcr/nodejs-shopping --query SecretString --output text)",
            "GHCR_USER=$(echo \"$SECRET_JSON\" | jq -r .username)",
            "GHCR_TOKEN=$(echo \"$SECRET_JSON\" | jq -r .token)",

            # --- Docker login ---
            "echo \"$GHCR_TOKEN\" | docker login ghcr.io -u \"$GHCR_USER\" --password-stdin",

            # --- Deploy ---
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
