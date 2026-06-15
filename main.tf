# VPC principal
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${var.environment}"
  }
}

# Subnet pública
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "subnet-public-${var.environment}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-${var.environment}"
  }
}

# Route Table pública
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "rt-public-${var.environment}"
  }
}

# Asociar Route Table con la Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Subnet privada (opcional)
resource "aws_subnet" "private" {
  count             = var.create_private_subnet ? 1 : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "subnet-private-${var.environment}"
  }
}

# NAT (opcional) — EIP + NAT Gateway
resource "aws_eip" "nat_eip" {
  count = var.create_nat_gateway ? 1 : 0
}

resource "aws_nat_gateway" "gw" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public.id
}

# Route table privada y ruta hacia NAT (si existe)
resource "aws_route_table" "private" {
  count  = var.create_private_subnet ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "rt-private-${var.environment}"
  }
}

resource "aws_route" "private_nat" {
  count                  = var.create_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw[0].id
}

resource "aws_route_table_association" "private" {
  count          = var.create_private_subnet ? 1 : 0
  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.private[0].id
}

# Security Group para EC2
resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg-${var.environment}"
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg-${var.environment}"
  }
}

# Reglas de SG condicionales (no abren puertos por defecto)
resource "aws_security_group_rule" "ssh" {
  count             = var.my_ip != "" ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
  security_group_id = aws_security_group.ec2_sg.id
  description       = "SSH from allowed IP"
}

resource "aws_security_group_rule" "http" {
  count             = var.allow_http_public ? 1 : 0
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
  description       = "Public HTTP (only if enabled)"
}

# IAM role + profile para SSM (opcional si EC2 se crea)
resource "aws_iam_role" "ec2_ssm_role" {
  count = var.create_ec2 ? 1 : 0
  name  = "ec2-ssm-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  count      = var.create_ec2 ? 1 : 0
  role       = aws_iam_role.ec2_ssm_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  count = var.create_ec2 ? 1 : 0
  name  = "ec2-profile-${var.environment}"
  role  = aws_iam_role.ec2_ssm_role[0].name
}

# EC2 instance (opcional)
resource "aws_instance" "web" {
  count = var.create_ec2 ? 1 : 0

  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.create_private_subnet ? aws_subnet.private[0].id : aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = var.create_private_subnet ? false : true
  key_name                    = var.key_name != "" ? var.key_name : null
  iam_instance_profile        = var.create_ec2 ? aws_iam_instance_profile.ec2_profile[0].name : null

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "ec2-web-${var.environment}"
  }
}
