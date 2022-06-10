#VPC

resource "aws_vpc" "request-vpc" {
  cidr_block = "10.0.0.0/18"

tags = {
Name = "mumbai-request"

}
}

#publicsubnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.request-vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Public Subnet"
  }
}

#internetgateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.request-vpc.id

  tags = {
    Name = "Main IGW"
  }
}
# RouteTable
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


# create your #outbound #inbound rules with security groups
resource "aws_security_group" "ssh-allowed" {
        vpc_id = aws_vpc.request-vpc.id

        egress {
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

        }

        ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"        // This means, all ip address are allowed to ssh !
        // Do not do it in the production.
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
        }

        tags = {
        Name = "ssh-allowed"
        }
}



# create your instance
resource "aws_instance" "public_instance" {
  ami           = "ami-021d41cbdefc0c994"
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public.id}"
  associate_public_ip_address = "true"
  key_name = "ACCEPT"
  tags = {
        Name = "public_instance"
  }
}

