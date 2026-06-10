resource "aws_security_group" "app" {
  name   = "microservices-app-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "microservices-app-sg" }
}

resource "aws_instance" "gateway" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = var.key_name
  user_data              = var.user_data_script
  tags                   = { Name = "api-gateway" }
}

resource "aws_instance" "user" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = var.key_name
  user_data              = var.user_data_script
  tags                   = { Name = "user-service" }
}

resource "aws_instance" "product" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = var.key_name
  user_data              = var.user_data_script
  tags                   = { Name = "product-service" }
}

resource "aws_instance" "order" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = var.key_name
  user_data              = var.user_data_script
  tags                   = { Name = "order-service" }
}