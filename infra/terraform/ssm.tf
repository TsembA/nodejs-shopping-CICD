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
          "cd /opt/app || exit 1",

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
