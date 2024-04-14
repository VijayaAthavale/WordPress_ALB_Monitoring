#Security Group

resource "aws_security_group" "dev_sg" {
  name = "awsRestartSG"
  description = "allow ssh"
  vpc_id = aws_vpc.dev_vpc.id
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.CIDR_BLOCK]
  }
  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.CIDR_BLOCK]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.CIDR_BLOCK]
  }
  tags = {
    Name = "awsRestartSG"
  }
}
  

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Allow SSH traffic"
  vpc_id = aws_vpc.dev_vpc.id
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.CIDR_BLOCK]
  }
  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.CIDR_BLOCK]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.CIDR_BLOCK]
  }
  tags = {
    Name = "allow_ssh"
  }
}

#Create security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow traffic from web servers"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.CIDR_BLOCK]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Internet Gateway
resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "awsRestartIGW"
  }
}