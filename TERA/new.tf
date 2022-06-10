# Main VPC
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "request-vpc" {
  cidr_block = "10.0.0.0/18"

tags = {
Name = "request"

}
}


resource "aws_vpc" "accept-vpc" {
  cidr_block = "172.16.0.0/16"
  provider = aws.accept

tags = {
Name = "accept"
}
}


data "aws_caller_identity" "peer" {
  provider = aws.accept
}

# Requester's side of the connection.
resource "aws_vpc_peering_connection" "request" {
  vpc_id        = aws_vpc.request-vpc.id
  peer_vpc_id   = aws_vpc.accept-vpc.id
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_region   = "eu-north-1"
  auto_accept   = false

  tags = {
    Side = "Requester"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "accept" {
  provider                  = aws.accept
  vpc_peering_connection_id = aws_vpc_peering_connection.request.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.request-vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Public Subnet"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.request-vpc.id

  tags = {
    Name = "Main IGW"
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

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}














#resources in another VPC




resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.accept-vpc.id
  cidr_block = "172.16.0.0/24"
  provider = aws.accept
  tags = {
    Name = "Public2 Subnet"
  }
}

resource "aws_internet_gateway" "igw2" {
  vpc_id = aws_vpc.accept-vpc.id
  provider = aws.accept
  tags = {
    Name = "Main IGW2"
  }
}

resource "aws_route_table" "public2" {
  vpc_id = aws_vpc.accept-vpc.id
  provider = aws.accept
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw2.id
  }

  tags = {
    Name = "Public Route Table2"
  }
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  provider = aws.accept
  route_table_id = aws_route_table.public2.id
}


resource "aws_route" "vpcpeeringaccepterroute" {
  provider                  = aws.accept 
  route_table_id            = aws_route_table.public2.id
  destination_cidr_block    = "10.0.0.0/18"
  vpc_peering_connection_id = "pcx-09b7487beaaef008f"
}

resource "aws_route" "vpcpeeringrequesterroute" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "172.16.0.0/16"
  vpc_peering_connection_id = "pcx-09b7487beaaef008f"
}
