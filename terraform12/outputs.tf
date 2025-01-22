output "nginx_amazon_public_ip" {
  value = aws_instance.nginx_amazon.public_ip
}

output "nginx_ubuntu_public_ip" {
  value = aws_instance.nginx_ubuntu.public_ip
}

output "java_amazon_public_ip" {
  value = aws_instance.java_amazon.public_ip
}

output "java_ubuntu_public_ip" {
  value = aws_instance.java_ubuntu.public_ip
}

output "ansible_control_public_ip" {
  value = aws_instance.ansible_control.public_ip
}