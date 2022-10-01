data "aws_vpc" "selected" {
  id = "vpc-0c28124fd431541a1"

  filter {
    name   = "tag:Name"
    values = ["GeeksHubs-DevOps"]
  }
}

data "aws_subnet" "selected" {
  vpc_id = data.aws_vpc.selected.id
}

data "aws_security_group" "allow_traffic" {
  name   = "allow-http-inbound-traffic"
  vpc_id = data.aws_vpc.selected.id
}
