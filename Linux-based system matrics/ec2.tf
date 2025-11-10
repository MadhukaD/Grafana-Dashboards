# Launch EC2 in the first public subnet so it gets a public IP (so you can SSH directly)
resource "aws_instance" "madhuka" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet_01.id
  vpc_security_group_ids = [aws_security_group.madhuka_sg.id]
  key_name               = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name        = var.name_prefix
    Environment = "production"
    Owner       = var.name_prefix
  }
}
