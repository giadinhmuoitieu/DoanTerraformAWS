provider aws {
    region = var.region
    access_key = var.access_key
  secret_key = var.secret_key 
}

resource "aws_vpc" "vpc" {
  cidr_block              = "10.0.0.0/16"
  instance_tenancy        = "default"
  enable_dns_hostnames    = true
  tags      = {
    Name    = "Test VPC"
  }
}

#internet gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id    = aws_vpc.vpc.id
  tags      = {
    Name    = "Test IGW"
  }
}
#public subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Public Subnet 1"
  }
}
#private subnet
resource "aws_subnet" "private-subnet-1" {
  vpc_id                 = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2c"
  map_public_ip_on_launch = false

  tags      = {
    Name    = "private Subnet 1"
  }
}
#route table public route table
resource "aws_route_table" "public-route-table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags       = {
    Name     = "Public Route Table"
  }
}
#add publicsubnet vao` route table
resource "aws_route_table_association" "public-subnet-1-route-table" {
  subnet_id           = aws_subnet.public-subnet-1.id
  route_table_id      = aws_route_table.public-route-table.id
}



//sg ssh http https
resource "aws_security_group" "allow-internal" {
  name        = "EC2-webserver-SG"
  description = "Webserver for EC2 Instances"
  vpc_id = aws_vpc.vpc.id
  
  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 443
    protocol    = "TCP"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
//sg
# resource "aws_security_group" "allow-db" {
#   name        = "allo_mysql"
#   description = "sg for mysql "
#   vpc_id = aws_vpc.vpc.id
  
#   ingress {
#     from_port   = 3306
#     protocol    = "TCP"
#     to_port     = 3306
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     protocol    = "-1"
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

resource "aws_security_group" "allow-pri" {
  name        = "allow_bssh_private"
  description = "allo private"
  vpc_id = aws_vpc.vpc.id
  
  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# resource "aws_security_group" "allow-ssh" {
#   name        = "allow_bastion_os"
#   description = "allo bastion"
#   vpc_id = aws_vpc.vpc.id
  
#   ingress {
#     from_port   = 22
#     protocol    = "TCP"
#     to_port     = 22
#    security_groups = [aws_security_group.allow-bs.id]
#   }

#   egress {
#     from_port   = 0
#     protocol    = "-1"
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
module "server" {
    source                  = "./ec2"
    ami_id                  = var.ami_id
    name                    = "Doansv" 
    key_name           = ""
    subnet_id = aws_subnet.public-subnet-1.id
    private_subnet_id = aws_subnet.private-subnet-1.id
    vpc_security_groups_ids = [aws_security_group.allow-internal.id]
    vpc_security_groups_ids_private  = [ aws_security_group.allow-pri ]
    
   
}

