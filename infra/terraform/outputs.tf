output "ec2_public_ip" {
  description = "Public IP of the application EC2 instance"
  value       = aws_instance.app.public_ip
}

output "application_url" {
  description = "Public URL of the NodeJS application"
  value       = "http://${aws_instance.app.public_ip}"
}
