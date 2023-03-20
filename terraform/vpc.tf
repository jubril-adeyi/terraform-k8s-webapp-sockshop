
#creating vpc

resource "aws_vpc" "eks-vpc" {
  cidr_block           = var.cidr_blocks
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "eks-vpc"
  }
}


#creating  an internet gateway

resource "aws_internet_gateway" "eks-gw" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "eks-gw"
  }
}

#creating public subnets

resource "aws_subnet" "eks-subnets1" {
  vpc_id                  = aws_vpc.eks-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone_id    = "use1-az1"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "eks-subnets2" {
  vpc_id                  = aws_vpc.eks-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone_id    = "use1-az2"
  map_public_ip_on_launch = true
}

#creating private subnets

resource "aws_subnet" "eks-subnets3" {
  vpc_id               = aws_vpc.eks-vpc.id
  cidr_block           = "10.0.3.0/24"
  availability_zone_id = "use1-az4"
}
resource "aws_subnet" "eks-subnets4" {
  vpc_id               = aws_vpc.eks-vpc.id
  cidr_block           = "10.0.4.0/24"
  availability_zone_id = "use1-az6"
}

#creating Nat gateway 

resource "aws_eip" "eks-eip" {
  vpc = true

  tags = {
    Name = "eks-eip"
  }
}

resource "aws_nat_gateway" "eks-nat-gw" {
  allocation_id = aws_eip.eks-eip.id
  subnet_id     = aws_subnet.eks-subnets1.id

  tags = {
    Name = "eks-nat-gw"
  }

  depends_on = [aws_internet_gateway.eks-gw]
}


// creating route tables 

resource "aws_route_table" "eks-pub-rt" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-gw.id
  }

  tags = {
    Name = "eks-pub-rt"
  }
}

resource "aws_route_table" "eks-priv-rt" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks-nat-gw.id
  }

  tags = {
    Name = "eks-priv-rt"
  }
}


// route table associations 

resource "aws_route_table_association" "subnet1_rt" {
  subnet_id      = aws_subnet.eks-subnets1.id
  route_table_id = aws_route_table.eks-pub-rt.id
}

resource "aws_route_table_association" "subnet2_rt" {
  subnet_id      = aws_subnet.eks-subnets2.id
  route_table_id = aws_route_table.eks-pub-rt.id
}
resource "aws_route_table_association" "subnet3_rt" {
  subnet_id      = aws_subnet.eks-subnets3.id
  route_table_id = aws_route_table.eks-priv-rt.id
}
resource "aws_route_table_association" "subnet4_rt" {
  subnet_id      = aws_subnet.eks-subnets4.id
  route_table_id = aws_route_table.eks-priv-rt.id
}


