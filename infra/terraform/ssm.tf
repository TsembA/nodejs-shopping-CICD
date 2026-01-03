// FILE: infra/terraform/ssm.tf
// changed

resource "aws_ssm_document" "deploy" {
  name          = "NodejsShopping-DockerDeploy"
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Deploy NodeJS app via docker-compose"

    mainSteps = [{
      action = "aws:runShellScript"
      name   = "deploy"
      inputs = {
        runCommand = [
          "set -e",

          "apt-get update -y",
          "apt-get install -y docker.io docker-compose-plugin",
          "systemctl enable docker",
          "systemctl start docker",

          "mkdir -p /opt/app",
          "cd /opt/app",

          "cat > docker-compose.yml <<'EOF'",
          templatefile("${path.module}/../../app/docker-compose.yml", {
            image = var.image
          }),
          "EOF",

          "docker compose pull",
          "docker compose up -d"
        ]
      }
    }]
  })
}
