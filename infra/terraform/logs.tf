# added
resource "aws_cloudwatch_log_group" "app" {
  name              = "/nodejs-shopping/app"
  retention_in_days = 7

  tags = {
    Name = "nodejs-shopping-app-logs"
  }
}
