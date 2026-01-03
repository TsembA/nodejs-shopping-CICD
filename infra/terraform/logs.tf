// FILE: infra/terraform/logs.tf
resource "aws_cloudwatch_log_group" "ssm" {
  name              = "/ssm/nodejs-shopping"
  retention_in_days = 7

  tags = {
    Name = "nodejs-shopping-ssm"
  }
}
