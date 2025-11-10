output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_01_id" {
  description = "Public subnet 01 ID"
  value       = aws_subnet.public_subnet_01.id
}

output "public_subnet_02_id" {
  description = "Public subnet 02 ID"
  value       = aws_subnet.public_subnet_02.id
}

output "private_subnet_01_id" {
  description = "Private subnet 01 ID"
  value       = aws_subnet.private_subnet_01.id
}

output "private_subnet_02_id" {
  description = "Private subnet 02 ID"
  value       = aws_subnet.private_subnet_02.id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.natgw.id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.madhuka_sg.id
}

output "ec2_instance_id" {
  description = "Instance ID"
  value       = aws_instance.madhuka.id
}

output "ec2_public_ip" {
  description = "Instance public IP (use to SSH)"
  value       = aws_instance.madhuka.public_ip
}

output "private_key_file" {
  description = "Local private key file saved by Terraform (use chmod 600 on this file before SSH)"
  value       = local_file.private_pem.filename
}
