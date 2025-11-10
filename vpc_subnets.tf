# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.name_prefix}-vpc"
    Environment = "production"
    Owner       = var.name_prefix
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.name_prefix}-igw"
    Environment = "production"
    Owner       = var.name_prefix
  }
}

resource "aws_subnet" "public_subnet_01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_01_cidr
  availability_zone       = "${var.aws_region}a"  # Specify the AZ
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "${var.name_prefix}-Public-Subnet-01"
  }
}

resource "aws_subnet" "public_subnet_02" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_02_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "${var.name_prefix}-Public-Subnet-02"
  }
}

resource "aws_subnet" "private_subnet_01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_01_cidr
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.name_prefix}-Private-Subnet-01"
  }
}

resource "aws_subnet" "private_subnet_02" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_02_cidr
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "${var.name_prefix}-Private-Subnet-02"
  }
}