# FILE: infra/terraform/ec2.tf

resource "aws_instance" "app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids       = [aws_security_group.app.id]
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    image      = var.docker_image
    ghcr_user  = var.ghcr_user
    ghcr_token = var.ghcr_token
  })

  tags = {
    Name    = var.instance_name
    Project = "nodejs-shopping"
    Managed = "terraform"
  }
}
