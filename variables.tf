variable "aws_region" {
  description = "Region de AWS"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente del proyecto"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block de la subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ami" {
  description = "AMI ID para EC2 (ajusta según tu región)"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.micro"
}

variable "my_ip" {
  description = "Tu IP/CIDR para SSH (ej. 1.2.3.4/32). Cambia esto por seguridad."
  type        = string
  default     = "0.0.0.0/0"
}

variable "key_name" {
  description = "Nombre del key pair para SSH (opcional)"
  type        = string
  default     = ""
}