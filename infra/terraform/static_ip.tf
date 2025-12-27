resource "aws_lightsail_static_ip" "app_ip" {
  name = "${var.instance_name}-ip"
}

resource "aws_lightsail_static_ip_attachment" "app_ip_attach" {
  static_ip_name = aws_lightsail_static_ip.app_ip.name
  instance_name  = aws_lightsail_instance.app.name
}
