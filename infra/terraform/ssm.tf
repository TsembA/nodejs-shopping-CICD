// FILE: infra/terraform/ssm.tf

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
          "set -euxo pipefail",

          "sudo apt-get update -y",
          "sudo apt-get install -y docker.io docker-compose-plugin",

          "sudo systemctl enable docker",
          "sudo systemctl start docker",

          "sudo usermod -aG docker ssm-user",

          "sudo mkdir -p /opt/app",
          "sudo chown -R ssm-user:ssm-user /opt/app",
          "cd /opt/app",

          "cat > docker-compose.yml <<'EOF'",
          templatefile("${path.module}/templates/docker-compose.yml.tpl", {
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
