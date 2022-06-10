###############################################
## This is the VPC1 main 
##############################################
resource "aws_vpc" "main" {
  cidr_block = "10.2.0.0/24"
  tags = {
   Name = "VPC-1"
 }
}

resource "aws_subnet" "vpc1_publicsubnet" {
 vpc_id = aws_vpc.main.id
 cidr_block = "10.2.0.0/26"
tags = {
Name = "VPC-1.publicsubnet"
 }
}

resource "aws_internet_gateway" "igw1" {
 vpc_id = aws_vpc.main.id
tags = {
Name = "VPC-1.IGW"
 }
}


resource "aws_route_table" "vpc1_PublicRT" {
    vpc_id =  aws_vpc.main.id
         route {
    cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.igw1.id
    }
 }

 resource "aws_route_table_association" "vpc1_PublicRTassociation" {
    subnet_id = aws_subnet.vpc1_publicsubnet.id
    route_table_id = aws_route_table.vpc1_PublicRT.id
 }

resource "aws_security_group" "ssh-security-group" {
name        = "SSH Security Group"
description = "Enable SSH access on Port 22"
vpc_id      = aws_vpc.main.id
ingress {
description      = "SSH Access"
from_port        = 22
to_port          = 22
protocol         = "tcp"
}
egress {
from_port        = 0
to_port          = 0
protocol         = "-1"
}
tags   = {
Name = "SSH Security Group"
}
}

 resource "aws_key_pair" "hawa" {
  key_name   = "hawa"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDnkduKeYbyP7owX3RFfrWybEui8P9xm4YTXSnuwhuiLD8Si7gtdXDBO9HOSixgFMAq2hV3nvaxB8zXLHCb8E8YtOhlMXWPolCWCux+r46tmC+6NKcyN3UsvHoruGrnpnt8etcPsqPe4A6D+u0yhbBkKCf8sGNFqgYoEhAkOdy9oF7ZwmkFe7wxRoRoyqkduuqlXr/HIBJ7zWqIKngi22uh3CqPTbK9EMzluoP6jEMbReftgcX+2mHD+uCefo6c4GyKrzqHG9Qe83RFYNarZ0ZljkkUogK3mI7KcihdaNxXb+wamWJFAGrPaKFx0/rQvi7198dHi9ZiRNDUAtfPiWp4EjhpVqTA1YEYyYy2xW9o2vC4YuQwQhpXhZ6pZhcT72zzpbczUzzcdabDBrCMtA4kkx3Vro+eFmHs1uR2t/AfsaAhohoUueG3gYm0S0eH+NMzMdffg6S7Sv5mkOZYUyQUpchogLVYe4cT+VnOmgwMH07u4c/3UdLOFUludJKXw78= bipin@bipin"

}


resource "aws_instance" "VPC1_ec2" {
ami                         = "ami-0c4dbc994a301913f"
instance_type               = "t2.micro"
key_name                    = "hawa"
security_groups             = ["${aws_security_group.ssh-security-group.id}"]
subnet_id                   = "${aws_subnet.vpc1_publicsubnet.id}"
associate_public_ip_address = true
tags = {
"Name" = "VPC1-Instance"
 }
}

#######################################################################

resource "aws_vpc" "vpc2" {
  provider   = aws.peer
  cidr_block = "10.3.0.0/24"
  tags = { 
    Name = "VPC-2"
 }
}

resource "aws_subnet" "vpc2_privatesubnet" {
 provider   = aws.peer
 vpc_id = aws_vpc.vpc2.id
 cidr_block = "10.3.0.0/26"
tags = {
Name = "VPC-2.privatesubnet"
 }
}


resource "aws_route_table" "VPC2_PrivateRT"{    # Creating RT for Private Subnet
  provider   = aws.peer
  vpc_id = aws_vpc.vpc2.id
 }

 resource "aws_route_table_association" "VPC2_PrivateRTassociation" {
    provider   = aws.peer
    subnet_id = aws_subnet.vpc2_privatesubnet.id
    route_table_id = aws_route_table.VPC2_PrivateRT.id
 }

 resource "aws_key_pair" "waha" {
  provider   = aws.peer
  key_name   = "waha"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDnkduKeYbyP7owX3RFfrWybEui8P9xm4YTXSnuwhuiLD8Si7gtdXDBO9HOSixgFMAq2hV3nvaxB8zXLHCb8E8YtOhlMXWPolCWCux+r46tmC+6NKcyN3UsvHoruGrnpnt8etcPsqPe4A6D+u0yhbBkKCf8sGNFqgYoEhAkOdy9oF7ZwmkFe7wxRoRoyqkduuqlXr/HIBJ7zWqIKngi22uh3CqPTbK9EMzluoP6jEMbReftgcX+2mHD+uCefo6c4GyKrzqHG9Qe83RFYNarZ0ZljkkUogK3mI7KcihdaNxXb+wamWJFAGrPaKFx0/rQvi7198dHi9ZiRNDUAtfPiWp4EjhpVqTA1YEYyYy2xW9o2vC4YuQwQhpXhZ6pZhcT72zzpbczUzzcdabDBrCMtA4kkx3Vro+eFmHs1uR2t/AfsaAhohoUueG3gYm0S0eH+NMzMdffg6S7Sv5mkOZYUyQUpchogLVYe4cT+VnOmgwMH07u4c/3UdLOFUludJKXw78= bipin@bipin"

}

resource "aws_security_group" "ssh-security-group1" {
provider   = aws.peer
name        = "SSH Security Group1"
description = "Enable SSH access on Port 22"
vpc_id      = aws_vpc.vpc2.id
ingress {
description      = "SSH Access"
from_port        = 22
to_port          = 22
protocol         = "tcp"
}
egress {
from_port        = 0
to_port          = 0
protocol         = "-1"
}
tags   = {
Name = "SSH Security Group1"
}
}

resource "aws_instance" "vpc2_ec2" {
provider                    = aws.peer
ami                         = "ami-040cdf30c60564b9b"
instance_type               = "t3.micro"
key_name                    = "waha"
security_groups             = ["${aws_security_group.ssh-security-group1.id}"]
subnet_id                   = "${aws_subnet.vpc2_privatesubnet.id}"
tags = {
"Name" = "vpc2_ec2"
 }
}


# Requester's side of the connection.
resource "aws_vpc_peering_connection" "vpcpeeringdemo" {
  vpc_id        = aws_vpc.main.id
  peer_vpc_id   = aws_vpc.vpc2.id
  peer_region   = "eu-north-1"
  auto_accept   = false

  tags = {
    Side = "Requester"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peering" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.vpcpeeringdemo.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}
resource "aws_route" "route-vpc1" {
route_table_id		= aws_route_table.vpc1_PublicRT.id
destination_cidr_block    = "10.3.0.0/24"
vpc_peering_connection_id  = aws_vpc_peering_connection.vpcpeeringdemo.id
}

resource "aws_route" "route-vpc2" {
provider		= aws.peer
route_table_id		= aws_route_table.VPC2_PrivateRT.id
destination_cidr_block    = "10.2.0.0/24"
vpc_peering_connection_id  = aws_vpc_peering_connection.vpcpeeringdemo.id
}



