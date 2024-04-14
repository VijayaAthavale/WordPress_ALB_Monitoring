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



 






