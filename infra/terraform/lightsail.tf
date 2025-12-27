resource "aws_lightsail_instance" "app" {
  name              = var.instance_name
  availability_zone = "${var.aws_region}a"
  blueprint_id      = var.blueprint_id
  bundle_id         = var.bundle_id

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    image       = var.docker_image
    ghcr_user  = var.ghcr_user
    ghcr_token = var.ghcr_token
  })

  tags = {
    Project = "nodejs-shopping"
    Managed = "terraform"
  }
}
