locals {
  name = "Kanban-application"
  az = "us-west-2"
}

# Overall VPC
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "${local.name}-VPC"
    Project = "${local.name}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name}-IGW"
    Project = "${local.name}"
  }
}

#Public Subnets

module "Public_Subnet_A" {
  source = "./modules/Subnets"
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "${local.az}a"

  tags = {
    Name = "${local.name}-Public_Subnet_A"
    Project = "${local.name}"
  }
}

module "Public_Subnet_B" {
  source = "./modules/Subnets"
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${local.az}b"

  tags = {
    Name = "${local.name}-Public_Subnet_B"
    Project = "${local.name}"
  }
}

# Private Subnets for Backend/API Service

module "Private_Subnet_A" {
  source = "./modules/Subnets"
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${local.az}a"

  tags = {
    Name = "${local.name}-Private_Subnet_A"
    Project = "${local.name}"
  }
}

module "Private_Subnet_B" {
  source = "./modules/Subnets"
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "${local.az}b"

  tags = {
    Name = "${local.name}-Private_Subnet_B"
    Project = "${local.name}"
  }
}

module "Private_Subnet_C" {
  source = "./modules/Subnets"
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "${local.az}c"

  tags = {
    Name = "${local.name}-Private_Subnet_C"
    Project = "${local.name}"
  }
}

# Subnets for Database Service

module "Database_Subnet_A" {
  source = "./modules/Subnets"
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "${local.az}a"

  tags = {
    Name = "${local.name}-Database_Subnet_A"
    Project = "${local.name}"
  }
}

module "Database_Subnet_B" {
  source = "./modules/Subnets"
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "${local.az}b"

  tags = {
    Name = "${local.name}-Database_Subnet_B"
    Project = "${local.name}"
  }
}

module "Database_Subnet_C" {
  source = "./modules/Subnets"
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.7.0/24"
  availability_zone = "${local.az}c"

  tags = {
    Name = "${local.name}-Database_Subnet_C"
    Project = "${local.name}"
  }
}

# Route Table for Public subnets

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.name}-Public-RT"
    Project = local.name
  }
}

# Association RT for Public Subnets

resource "aws_route_table_association" "public-a" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id = module.Public_Subnet_A.id
}

resource "aws_route_table_association" "public-b" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id = module.Public_Subnet_B.id
}

# Database/API Service subnet route table and NAT

resource "aws_eip" "nat-1-eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "private-NAT" {
  subnet_id = module.Public_Subnet_A.id
  allocation_id = aws_eip.nat-1-eip.id

  depends_on = [ aws_internet_gateway.igw ]

  tags = {
    Name = "${local.name}-private-NAT"
    Project = local.name
  }
}

resource "aws_route_table" "private-tb" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private-NAT.id
  }

  tags = {
    Name = "${local.name}-private-rt"
    Project = local.name
  }
}

resource "aws_route_table_association" "private-a" {
  route_table_id = aws_route_table.private-tb.id
  subnet_id = module.Private_Subnet_A.id
}

resource "aws_route_table_association" "private-b" {
  route_table_id = aws_route_table.private-tb.id
  subnet_id = module.Private_Subnet_B.id
}

resource "aws_route_table_association" "private-c" {
  route_table_id = aws_route_table.private-tb.id
  subnet_id = module.Private_Subnet_C.id
}

# Database subnets  routebable and NAT

resource "aws_eip" "nat-2-eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "database-NAT" {
  subnet_id = module.Public_Subnet_B.id
  allocation_id = aws_eip.nat-2-eip.id

  depends_on = [ aws_internet_gateway.igw ]

  tags = {
    Name = "${local.name}-database-NAT"
    Project = local.name
  }
}

resource "aws_route_table" "database-tb" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.database-NAT.id
  }

  tags = {
    Name = "${local.name}-database-rt"
    Project = local.name
  }
}

resource "aws_route_table_association" "database-a" {
  route_table_id = aws_route_table.database-tb.id
  subnet_id = module.Database_Subnet_A.id
}

resource "aws_route_table_association" "database-b" {
  route_table_id =  aws_route_table.database-tb.id
  subnet_id = module.Database_Subnet_B.id
}

resource "aws_route_table_association" "database-c" {
  route_table_id = aws_route_table.database-tb.id
  subnet_id = module.Database_Subnet_C.id
}