output "public_ip" {
  value       = aws_lightsail_static_ip.app_ip.ip_address
  description = "Public IP of the application"
}
