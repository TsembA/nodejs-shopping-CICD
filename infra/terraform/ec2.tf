// FILE: infra/terraform/ec2.tf

resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile   = aws_iam_instance_profile.this.name

  tags = {
    Name = "nodejs-shopping-app"
  }
}
