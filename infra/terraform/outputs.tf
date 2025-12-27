output "public_ip" {
  value       = aws_eip.app.public_ip
  description = "Elastic IP of the application"
}
