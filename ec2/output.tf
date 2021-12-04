output "server-public-ip" {
    value       = aws_instance.webserver.*.public_ip
    description = "Public IP ec2"
}
