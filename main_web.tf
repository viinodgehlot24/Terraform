# main.tf

provider "aws" {
  region = "us-east-1"  # Change this to your desired AWS region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # Customize the CIDR block as needed
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"  # Customize the CIDR block as needed
  availability_zone       = "us-east-1a"  # Change the availability zone as needed
  map_public_ip_on_launch = true
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow inbound HTTP traffic"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

