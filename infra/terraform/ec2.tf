resource "aws_instance" "app" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app.id]

  key_name = var.ssh_key_name

  tags = {
    Name = "nodejs-shopping-app"
  }
}
