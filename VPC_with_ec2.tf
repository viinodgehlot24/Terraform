// Create VPC 
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.10.0.0/24"
}

// Create Subnet01
resource "aws_subnet" "Subnet01" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.10.0.0/25"
  availability_zone = "ap-south-1a"  # Change the availability zone as needed
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet01"
  }
}
// Create Subnet02
resource "aws_subnet" "Subnet02" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.10.0.128/25"
  availability_zone = "ap-south-1b"	 # Change the availability zone as needed
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet02"
  }
}

// create internet 
resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "custom_igw"
  }
}

// Create Route table
resource "aws_route_table" "custom_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }
 tags = {
    Name = "custom_rt"
  }
}
//  associate subnets to Route table
resource "aws_route_table_association" "demo-rt_association" {
  subnet_id      = aws_subnet.Subnet01.id
  route_table_id = aws_route_table.custom_rt.id
}
resource "aws_route_table_association" "demo-rt_association" {
  subnet_id      = aws_subnet.Subnet02.id
  route_table_id = aws_route_table.custom_rt.id
}
// Create Security group 
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow inbound SSH traffic"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description      = "optional"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

// Create EC2
provider "aws" {
    region = "ap-south-1"   # Change this to your desired AWS region
}
resource "aws_instance" "MyEC2Instance" {
    ami             = "ami-0f5ee92e2d63afc18" 
    instance_type   = "t2.micro"
	availability_zone = "ap-south-1a"
    key_name        = "VIINODG24"
	subnet_id = aws_subnet.Subnet01.id
	vpc_security_group_ids = [aws_security_group.allow_ssh.id]
    tage = {
        name = "MyEC2Instance"
    }
}
