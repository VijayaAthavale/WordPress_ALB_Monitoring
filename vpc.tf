locals {
    #Name of the vpc
  Name="awsRestartVPC"

}
# VPC 
resource "aws_vpc" "dev_vpc" {
  cidr_block = var.VPC_CIDR
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  instance_tenancy = "default"
  tags = {
    Name = "awsRestartVPC"
  }
}
# Internet Gateway
resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "awsRestartIGW"
  }
}
# Route Table 
resource "aws_route_table" "dev_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "awsRestartRT"
  }
}
# Route 
resource "aws_route" "dev_route" {
  route_table_id = aws_route_table.dev_rt.id
  destination_cidr_block = var.CIDR_BLOCK
  gateway_id = aws_internet_gateway.dev_igw.id
}
# Public Subnet1 
resource "aws_subnet" "dev_subnet" {
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = var.PUBLIC_SUBNET_CIDR
  availability_zone ="us-west-2a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "awsRestartPublicSubnet1"
  }
}
#Associate Public Subnet1 with Route Table
resource "aws_route_table_association" "dev_rt_association" {
    subnet_id = aws_subnet.dev_subnet.id
  route_table_id = aws_route_table.dev_rt.id
}
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
#Public Subnet2
resource "aws_subnet" "dev_subnet2" {
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = var.PUBLIC_SUBNET_CIDR2
 availability_zone ="us-west-2b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "awsRestartPublicSubnet2"
  }
}
#Associate Public Subnet2 with Route Table
resource "aws_route_table_association" "dev_rt_association2" {
  subnet_id = aws_subnet.dev_subnet2.id
  route_table_id = aws_route_table.dev_rt.id
}

#Private Subnet1
resource "aws_subnet" "dev_subnet3" {
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = var.PRIVATE_SUBNET_CIDR
   availability_zone ="us-west-2a"
  tags = {
    Name = "awsRestartPrivateSubnet1"
  }
}
#Private Subnet2
resource "aws_subnet" "dev_subnet4" {
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = var.PRIVATE_SUBNET_CIDR2
   availability_zone ="us-west-2b"
  tags = {
    Name = "awsRestartPrivateSubnet2"
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
#create route table for private subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "awsRestartPrivateRT"
  }
}
#create route for private subnet
resource "aws_route" "private_route" {
  route_table_id = aws_route_table.private_rt.id
  destination_cidr_block = var.CIDR_BLOCK
  gateway_id = aws_internet_gateway.dev_igw.id
}
#Associate Private Subnet1 with Route Table
resource "aws_route_table_association" "private_rt_association" {
  subnet_id = aws_subnet.dev_subnet3.id
  route_table_id = aws_route_table.private_rt.id
}
#Associate Private Subnet2 with Route Table
resource "aws_route_table_association" "private_rt_association2" {
  subnet_id = aws_subnet.dev_subnet4.id
  route_table_id = aws_route_table.private_rt.id
}