# Main VPC
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "request-vpc" {
 # cidr_block = "10.0.0.0/18"
  cidr_block = var.requestvpccidrblock
  tags = {
    Name = "request VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Public Subnet"
  }
}

# Private Subnet with Default Route to NAT Gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main IGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

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


resource "aws_security_group" "ssh-allowed" {
	vpc_id = aws_vpc.main.id
        
        egress {
    	from_port = 0
    	to_port = 0
    	protocol = "tcp"
    	cidr_blocks = ["0.0.0.0/0"]

	}

	ingress {
    	from_port = 22
    	to_port = 22
    	protocol = "tcp"    	// This means, all ip address are allowed to ssh !
    	// Do not do it in the production.
    	// Put your office or home address in it!
    	cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
    	Name = "ssh-allowed"
	}
}


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



resource "aws_vpc" "accept-vpc" {
  cidr_block = "172.16.0.0/16"
  provider = aws.next

  tags = {
    Name = "accept VPC"
  }
}


