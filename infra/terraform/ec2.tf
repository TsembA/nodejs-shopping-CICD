resource "aws_instance" "app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = true

  key_name             = "nodejs-shopping-key"
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name


  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name    = var.instance_name
    Project = "nodejs-shopping"
    Managed = "terraform"
  }

  lifecycle {
    ignore_changes = [user_data]
  }
}

