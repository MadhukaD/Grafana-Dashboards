# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  tags = {
    Name        = "${var.name_prefix}-nat-eip"
    Environment = "production"
    Owner       = var.name_prefix
  }
}

# NAT Gateway placed in the first public subnet (cost note below)
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_01.id

  tags = {
    Name        = "${var.name_prefix}-natgw"
    Environment = "production"
    Owner       = var.name_prefix
  }

  depends_on = [aws_internet_gateway.igw]
}

# Public route table -> IGW
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.name_prefix}-public-rt"
    Environment = "production"
    Owner       = var.name_prefix
  }
}

# Private route table -> NAT
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name        = "${var.name_prefix}-private-rt"
    Environment = "production"
    Owner       = var.name_prefix
  }

  depends_on = [aws_nat_gateway.natgw]
}

resource "aws_route_table_association" "public_subnet_01" {
  subnet_id      = aws_subnet.public_subnet_01.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_02" {
  subnet_id      = aws_subnet.public_subnet_02.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_subnet_01" {
  subnet_id      = aws_subnet.private_subnet_01.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_subnet_02" {
  subnet_id      = aws_subnet.private_subnet_02.id
  route_table_id = aws_route_table.private_rt.id
}