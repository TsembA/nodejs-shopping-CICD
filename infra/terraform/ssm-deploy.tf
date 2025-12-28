# FILE: infra/terraform/ssm.tf
resource "aws_ssm_document" "docker_deploy" {
  name          = "NodejsShopping-DockerDeploy"
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Deploy Nodejs Shopping Docker container"

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
          timeoutSeconds = 600
          runCommand = [
            "set -e",
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
