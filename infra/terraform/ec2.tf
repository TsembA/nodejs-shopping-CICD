resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile   = aws_iam_instance_profile.this.name

  user_data = <<-EOF
    #!/bin/bash
    set -eux

    apt-get update -y
    apt-get install -y docker.io docker-compose-plugin

    systemctl enable docker
    systemctl start docker

    usermod -aG docker ubuntu
    usermod -aG docker ssm-user
  EOF

  tags = {
    Name = "nodejs-shopping-app"
  }

  lifecycle {
    create_before_destroy = true
  }
}
