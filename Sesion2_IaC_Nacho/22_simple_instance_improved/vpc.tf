resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = aws_vpc.my_vpc.cidr_block
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id
}

data "aws_route_table" "route_table" {
  depends_on = [aws_vpc.my_vpc]

  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "add_external_route" {
  route_table_id         = data.aws_route_table.route_table.id
  gateway_id             = aws_internet_gateway.gw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_security_group" "allow_traffic" {
  name        = "allow-http-inbound-traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
