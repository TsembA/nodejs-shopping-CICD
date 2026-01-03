// FILE: infra/terraform/ssm-association.tf
// changed

resource "aws_ssm_association" "deploy_app" {
  name = aws_ssm_document.deploy.name

  targets {
    key    = "InstanceIds"
    values = [aws_instance.app.id]
  }

  lifecycle {
    replace_triggered_by = [
      aws_ssm_document.deploy
    ]
  }

  depends_on = [
    aws_instance.app,
    aws_iam_instance_profile.this
  ]
}
