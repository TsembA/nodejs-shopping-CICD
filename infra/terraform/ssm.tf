// FILE: infra/terraform/ssm.tf
// changed

locals {
  docker_compose_b64 = base64encode(
    templatefile("${path.module}/templates/docker-compose.yml.tpl", {
      image = var.image
    })
  )
}

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

          "apt-get update -y",
          "apt-get install -y docker.io docker-compose-plugin",

          "systemctl enable docker",
          "systemctl start docker",

          "mkdir -p /opt/app",
          "cd /opt/app",

          "echo '${local.docker_compose_b64}' | base64 -d > docker-compose.yml",

          "/usr/bin/docker compose pull",
          "/usr/bin/docker compose up -d"
        ]
      }
    }]
  })
}
