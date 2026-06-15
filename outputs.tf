output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID de la Subnet pública"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID de la Subnet privada"
  value       = try(aws_subnet.private[0].id, "")
}

output "internet_gateway_id" {
  description = "ID del Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "ID del NAT Gateway"
  value       = try(aws_nat_gateway.gw[0].id, "")
}

output "instance_id" {
  description = "ID del EC2 creado"
  value       = try(aws_instance.web[0].id, "")
}

output "instance_public_ip" {
  description = "IP pública del EC2"
  value       = try(aws_instance.web[0].public_ip, "")
}
