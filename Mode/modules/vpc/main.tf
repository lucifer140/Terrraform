#VPC

resource "aws_vpc" "request-vpc" {
  cidr_block = var.cidr_block

tags = {
Name = "mumbai-request"

}
}


#publicsubnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.request-vpc.id
  cidr_block = var.public_subnet

  tags = {
    Name = "Public Subnet"
  }
}


#internetgateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.request-vpc.id

  tags = {
    Name = var.igw
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.request-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# subnet association in route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id

}

