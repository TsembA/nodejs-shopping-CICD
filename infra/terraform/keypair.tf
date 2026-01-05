resource "aws_key_pair" "app" {
  key_name   = var.ssh_key_name
  public_key = file(var.ssh_public_key_path)

  tags = {
    Name = "nodejs-shopping-key"
    Env  = "prod"
  }
}
