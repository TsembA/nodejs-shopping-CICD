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
            "set -e",
            "mkdir -p /opt/nodejs-shopping",
            "cd /opt/nodejs-shopping",
            "docker-compose pull",
            "docker-compose up -d"
          ]
        }
      }
    ]
  })
}
