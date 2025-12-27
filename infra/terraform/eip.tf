resource "aws_eip" "app" {
  instance = aws_instance.app.id
  domain   = "vpc"

  tags = {
    Project = "nodejs-shopping"
    Managed = "terraform"
  }
}
