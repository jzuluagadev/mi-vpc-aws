# 🌐 Mi VPC en AWS con OpenTofu

Proyecto de infraestructura como código (IaC) que despliega una VPC funcional en AWS usando **OpenTofu**, la alternativa open source de Terraform.

---

## 📐 Arquitectura

```
AWS Cloud
└── VPC (vpc-dev)
    ├── Subnet Pública
    │   └── Route Table → Internet Gateway
    └── Internet Gateway (igw-dev)
```

---

## ✅ Recursos desplegados

| Recurso | Nombre | Descripción |
|---|---|---|
| `aws_vpc` | vpc-{environment} | Red virtual principal |
| `aws_subnet` | subnet-public-{environment} | Subnet pública con acceso a internet |
| `aws_internet_gateway` | igw-{environment} | Puerta de enlace a internet |
| `aws_route_table` | rt-public-{environment} | Tabla de rutas para la subnet pública |
| `aws_route_table_association` | - | Asociación entre subnet y route table |

---

## 🛠️ Tecnologías

- [OpenTofu](https://opentofu.org/) >= 1.6
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest) >= 5.0
- AWS CLI configurado

---

## ⚙️ Requisitos previos

1. Tener instalado [OpenTofu](https://opentofu.org/docs/intro/install/)
2. Tener una cuenta de AWS
3. Configurar credenciales de AWS:

```bash
aws configure
```

---

## 🚀 Cómo usar este proyecto

**1. Clona el repositorio:**
```bash
git clone https://github.com/jzuluagadev/mi-vpc-aws.git
cd mi-vpc-aws
```

**2. Inicializa OpenTofu:**
```bash
tofu init
```

**3. Revisa el plan de ejecución:**
```bash
tofu plan
```

**4. Aplica la infraestructura:**
```bash
tofu apply
```

**5. Para destruir los recursos:**
```bash
tofu destroy
```

---

## 📋 Variables

| Variable | Descripción | Valor por defecto |
|---|---|---|
| `vpc_cidr` | CIDR block de la VPC | `10.0.0.0/16` |
| `subnet_cidr` | CIDR block de la subnet pública | `10.0.1.0/24` |
| `aws_region` | Región de AWS | `us-east-1` |
| `environment` | Nombre del ambiente | `dev` |

---

## 📤 Outputs

- ID de la VPC creada
- ID de la Subnet pública
- ID del Internet Gateway

---

## 👨‍💻 Autor

**Jorge Zuluaga**
- GitHub: [@jzuluagadev](https://github.com/jzuluagadev)

---

## 📄 Licencia

Este proyecto es de uso educativo y libre distribución.
