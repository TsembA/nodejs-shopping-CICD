// FILE: infra/terraform/ssm-association.tf

resource "aws_ssm_association" "deploy_app" {
  name = aws_ssm_document.deploy.name

  targets {
    key    = "InstanceIds"
    values = [aws_instance.app.id]
  }

  parameters = {
    force = timestamp()
  }

  depends_on = [
    aws_instance.app,
    aws_iam_instance_profile.this,
    aws_ssm_document.deploy
  ]
}
