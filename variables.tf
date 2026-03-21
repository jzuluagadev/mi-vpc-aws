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