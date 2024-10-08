output "ec2_public_ip" {
    value = aws_instance.group10_nginx_server.public_ip
  
}