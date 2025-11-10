# Security Group: allow SSH/HTTP/HTTPS inbound from anywhere IPv4, all outbound allowed
resource "aws_security_group" "madhuka_sg" {
  name        = "${var.name_prefix}-sg"
  description = "Allow SSH(22), HTTP(80), HTTPS(443) from anywhere IPv4; all outbound allowed"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere - IPv4"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere - IPv4"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere - IPv4"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Node-Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name_prefix}-sg"
    Environment = "production"
    Owner       = var.name_prefix
  }
}

# Generate RSA private key (4096) locally in Terraform
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair from the generated public key
resource "aws_key_pair" "generated_key" {
  key_name   = "${var.name_prefix}-key"
  public_key = tls_private_key.ssh_key.public_key_openssh

  tags = {
    Name        = "${var.name_prefix}-key"
    Environment = "production"
    Owner       = var.name_prefix
  }
}

# Save the private key to a local file (project root) - name_prefix.pem
resource "local_file" "private_pem" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${var.name_prefix}.pem"
  file_permission = "0600"
}
