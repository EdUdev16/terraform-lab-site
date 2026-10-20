# terraform-lab-site

Cria na AWS (us-east-2) a EC2 do lab com o site em Docker, via Terraform: Security Group (HTTP aberto, SSH só do meu IP) + instância Amazon Linux 2023 que instala o Docker e sobe o nginx sozinha (`user_data`).

## Uso
```bash
aws sso login --profile lab-eduardo --use-device-code
echo 'ssh_cidr = "SEU.IP/32"' > terraform.tfvars
terraform init
terraform plan
terraform apply
terraform destroy   # apaga tudo ao terminar (evita cobrança)
```
