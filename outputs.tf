output "arn" {
  value       = aws_instance.openvpn.arn
  description = "The EC2 instance ARN."
}

output "availability_zone" {
  value       = aws_instance.openvpn.availability_zone
  description = "The AZ where the EC2 instance is deployed."
}

output "id" {
  value       = aws_instance.openvpn.id
  description = "The EC2 instance ID."
}

output "private_ip" {
  value       = aws_instance.openvpn.private_ip
  description = "The private IP of the EC2 instance."
}

output "public_ip" {
  value       = aws_instance.openvpn.public_ip
  description = "The public IP of the OpenVPN instance."
}

output "security_group_arn" {
  value       = aws_security_group.openvpn_servers.arn
  description = "The ARN of the OpenVPN server security group."
}

output "security_group_id" {
  value       = aws_security_group.openvpn_servers.id
  description = "The ID of the OpenVPN server security group."
}

output "subnet_id" {
  value       = aws_instance.openvpn.subnet_id
  description = "The ID of the subnet where the EC2 instance is deployed."
}
