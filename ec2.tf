# ec2.tf

resource "aws_instance" "my_instance" {
  ami           = "ami-xxxxxxxxxxxxx"  # Replace with your desired AMI ID
  instance_type = "t2.micro"           # Customize the instance type as needed
  subnet_id     = aws_subnet.my_subnet.id
  key_name      = "your-key-pair-name" # Replace with your EC2 key pair name

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "MyEC2Instance"
  }
}


