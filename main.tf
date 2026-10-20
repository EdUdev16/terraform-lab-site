data "aws_vpc" "default" {
  default = true
}

# AMI Amazon Linux 2023 mais recente, resolvida pelo parâmetro público da AWS
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_security_group" "site" {
  name        = "tf-lab-site"
  description = "Site do lab: HTTP aberto, SSH so do meu IP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH do meu IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "site" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.site.id]

  # Instala o Docker e sobe o site sozinho no primeiro boot
  user_data = <<-EOT
    #!/bin/bash
    dnf install -y docker
    systemctl enable --now docker
    mkdir -p /opt/site
    cat > /opt/site/index.html <<'HTML'
    <meta charset="utf-8">
    <h1>Olá do meu container, Eduardo! (criado com Terraform)</h1>
    HTML
    cat > /opt/site/Dockerfile <<'DOCKER'
    FROM nginx
    COPY index.html /usr/share/nginx/html/index.html
    DOCKER
    docker build -t meu-site /opt/site
    docker run -d --name site --restart unless-stopped -p 80:80 meu-site
  EOT

  user_data_replace_on_change = true

  tags = {
    Name = "tf-lab-site"
  }
}
