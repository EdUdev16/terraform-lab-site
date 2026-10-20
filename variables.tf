variable "region" {
  description = "Região AWS dos recursos"
  type        = string
  default     = "us-east-2"
}

variable "profile" {
  description = "Perfil do AWS CLI (login por SSO)"
  type        = string
  default     = "lab-eduardo"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair que já existe na AWS, usada no SSH"
  type        = string
  default     = "lab-key"
}

variable "ssh_cidr" {
  description = "IP liberado no SSH, no formato x.x.x.x/32 (sem padrão, para nunca abrir a 22 pro mundo)"
  type        = string
}
