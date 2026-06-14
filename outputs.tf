output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID de la Subnet creada"
  value       = aws_subnet.public.id
}

output "internet_gateway_id" {
  description = "ID del Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "instance_id" {
  description = "ID del EC2 creado"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "IP pública del EC2"
  value       = aws_instance.web.public_ip
}
