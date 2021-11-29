resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.vpc-first.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-subnet"
  }
}
resource "aws_vpc" "vpc-first" {
    cidr_block = "10.0.0.0/16"
    tags = {
        name = "antihacker"
    }
}
