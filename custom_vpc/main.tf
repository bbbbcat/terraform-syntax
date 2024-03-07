# create a VPC
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main"
  }
}

# create a Public Subnet
resource "aws_subnet" "Public_subnet_1" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.100.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Hangramit_public_subnet_1"
  }
}
resource "aws_subnet" "Hangramit_private_subnet_1" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Hangramit_private_subnet_1"
  }
}

resource "aws_nat_gateway" "private_nat_gw" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.Public_subnet_1.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.default.id
}
