resource "aws_db_subnet_group" "main" {
  name       = "microservices-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags       = { Name = "microservices-db-subnet-group" }
}

resource "aws_security_group" "rds" {
  name   = "microservices-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "microservices-rds-sg" }
}

resource "aws_db_instance" "main" {
  identifier             = "microservices-db"
  engine                 = "postgres"
  engine_version         = "17"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp3"
  db_name                = "microservicesdb"
  username               = "dbadmin"
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  backup_retention_period = 0
  storage_encrypted      = true
  publicly_accessible    = false
  skip_final_snapshot    = true
  tags                   = { Name = "microservices-db" }
}