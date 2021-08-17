###############
# VPC Section #
###############

# VPCs

resource "aws_vpc" "vpc-dev" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name     = "${var.scenario}-vpc-dev-dev"
    scenario = "${var.scenario}"
    env      = "dev"
  }
}

resource "aws_vpc" "vpc-stage" {
  cidr_block = "10.11.0.0/16"
  tags = {
    Name     = "${var.scenario}-vpc-stage-stage"
    scenario = "${var.scenario}"
    env      = "stage"
  }
}

resource "aws_vpc" "vpc-shared" {
  cidr_block = "10.12.0.0/16"
  tags = {
    Name     = "${var.scenario}-vpc-shared-shared"
    scenario = "${var.scenario}"
    env      = "shared"
  }
}

resource "aws_vpc" "vpc-prod" {
  cidr_block = "10.13.0.0/16"
  tags = {
    Name     = "${var.scenario}-vpc-prod-prod"
    scenario = "${var.scenario}"
    env      = "prod"
  }
}

# Subnets

resource "aws_subnet" "vpc-dev-sub-a" {
  vpc_id            = aws_vpc.vpc-dev.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = var.az1

  tags = {
    Name = "${aws_vpc.vpc-dev.tags.Name}-sub-a"
  }
}

resource "aws_subnet" "vpc-dev-sub-b" {
  vpc_id            = aws_vpc.vpc-dev.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = var.az2

  tags = {
    Name = "${aws_vpc.vpc-dev.tags.Name}-sub-b"
  }
}

resource "aws_subnet" "vpc-stage-sub-a" {
  vpc_id            = aws_vpc.vpc-stage.id
  cidr_block        = "10.11.1.0/24"
  availability_zone = var.az1

  tags = {
    Name = "${aws_vpc.vpc-stage.tags.Name}-sub-a"
  }
}

resource "aws_subnet" "vpc-stage-sub-b" {
  vpc_id            = aws_vpc.vpc-stage.id
  cidr_block        = "10.11.2.0/24"
  availability_zone = var.az2

  tags = {
    Name = "${aws_vpc.vpc-stage.tags.Name}-sub-b"
  }
}

resource "aws_subnet" "vpc-shared-sub-a" {
  vpc_id            = aws_vpc.vpc-shared.id
  cidr_block        = "10.12.1.0/24"
  availability_zone = var.az1

  tags = {
    Name = "${aws_vpc.vpc-shared.tags.Name}-sub-a"
  }
}

resource "aws_subnet" "vpc-shared-sub-b" {
  vpc_id            = aws_vpc.vpc-shared.id
  cidr_block        = "10.12.2.0/24"
  availability_zone = var.az2

  tags = {
    Name = "${aws_vpc.vpc-shared.tags.Name}-sub-b"
  }
}

resource "aws_subnet" "vpc-prod-sub-a" {
  vpc_id            = aws_vpc.vpc-prod.id
  cidr_block        = "10.13.1.0/24"
  availability_zone = var.az1

  tags = {
    Name = "${aws_vpc.vpc-prod.tags.Name}-sub-a"
  }
}

resource "aws_subnet" "vpc-prod-sub-b" {
  vpc_id            = aws_vpc.vpc-prod.id
  cidr_block        = "10.13.2.0/24"
  availability_zone = var.az2

  tags = {
    Name = "${aws_vpc.vpc-prod.tags.Name}-sub-b"
  }
}

# Internet Gateways

resource "aws_internet_gateway" "vpc-shared-igw" {
  vpc_id = aws_vpc.vpc-shared.id

  tags = {
    Name     = "vpc-shared-igw"
    scenario = "${var.scenario}"
  }
}

resource "aws_internet_gateway" "vpc-dev-igw" {
  vpc_id = aws_vpc.vpc-dev.id

  tags = {
    Name     = "vpc-dev-igw"
    scenario = "${var.scenario}"
  }
}

resource "aws_internet_gateway" "vpc-stage-igw" {
  vpc_id = aws_vpc.vpc-stage.id

  tags = {
    Name     = "vpc-stage-igw"
    scenario = "${var.scenario}"
  }
}

resource "aws_internet_gateway" "vpc-prod-igw" {
  vpc_id = aws_vpc.vpc-prod.id

  tags = {
    Name     = "vpc-prod-igw"
    scenario = "${var.scenario}"
  }
}

# Main Route Tables Associations

resource "aws_main_route_table_association" "main-rt-vpc-dev" {
  vpc_id         = aws_vpc.vpc-dev.id
  route_table_id = aws_route_table.vpc-dev-rtb.id
}

resource "aws_main_route_table_association" "main-rt-vpc-stage" {
  vpc_id         = aws_vpc.vpc-stage.id
  route_table_id = aws_route_table.vpc-stage-rtb.id
}

resource "aws_main_route_table_association" "main-rt-vpc-shared" {
  vpc_id         = aws_vpc.vpc-shared.id
  route_table_id = aws_route_table.vpc-shared-rtb.id
}

resource "aws_main_route_table_association" "main-rt-vpc-prod" {
  vpc_id         = aws_vpc.vpc-prod.id
  route_table_id = aws_route_table.vpc-prod-rtb.id
}


# Route Tables
## Usually unecessary to explicitly create a Route Table in Terraform
## since AWS automatically creates and assigns a 'Main Route Table'
## whenever a VPC is created. However, in a Transit Gateway scenario,
## Route Tables are explicitly created so an extra route to the
## Transit Gateway could be defined

resource "aws_route_table" "vpc-dev-rtb" {
  vpc_id = aws_vpc.vpc-dev.id

  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.poc-tgw.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-dev-igw.id
  }

  tags = {
    Name     = "vpc-dev-rtb"
    env      = "dev"
    scenario = "${var.scenario}"
  }
  depends_on = ["aws_ec2_transit_gateway.poc-tgw"]
}

resource "aws_route_table" "vpc-stage-rtb" {
  vpc_id = aws_vpc.vpc-stage.id

  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.poc-tgw.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-stage-igw.id
  }

  tags = {
    Name     = "vpc-stage-rtb"
    env      = "dev"
    scenario = "${var.scenario}"
  }
  depends_on = ["aws_ec2_transit_gateway.poc-tgw"]
}

resource "aws_route_table" "vpc-shared-rtb" {
  vpc_id = aws_vpc.vpc-shared.id

  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.poc-tgw.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-shared-igw.id
  }

  tags = {
    Name     = "vpc-shared-rtb"
    env      = "shared"
    scenario = "${var.scenario}"
  }
  depends_on = ["aws_ec2_transit_gateway.poc-tgw"]
}

resource "aws_route_table" "vpc-prod-rtb" {
  vpc_id = aws_vpc.vpc-prod.id

  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.poc-tgw.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-prod-igw.id
  }

  tags = {
    Name     = "vpc-prod-rtb"
    env      = "prod"
    scenario = "${var.scenario}"
  }
  depends_on = ["aws_ec2_transit_gateway.poc-tgw"]
}

 # VPC attachments

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-dev" {
  subnet_ids                                      = ["${aws_subnet.vpc-dev-sub-a.id}", "${aws_subnet.vpc-dev-sub-b.id}"]
  transit_gateway_id                              = aws_ec2_transit_gateway.poc-tgw.id
  vpc_id                                          = aws_vpc.vpc-dev.id
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
  tags = {
    Name     = "tgw-att-vpc-dev"
    scenario = "${var.scenario}"
  }
  depends_on = ["aws_ec2_transit_gateway.poc-tgw"]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-stage" {
  subnet_ids                                      = ["${aws_subnet.vpc-stage-sub-a.id}", "${aws_subnet.vpc-stage-sub-b.id}"]
  transit_gateway_id                              = aws_ec2_transit_gateway.poc-tgw.id
  vpc_id                                          = aws_vpc.vpc-stage.id
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
  tags = {
    Name     = "tgw-att-vpc-stage"
    scenario = "${var.scenario}"
  }
  depends_on = ["aws_ec2_transit_gateway.poc-tgw"]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-shared" {
  subnet_ids                                      = ["${aws_subnet.vpc-shared-sub-a.id}", "${aws_subnet.vpc-shared-sub-b.id}"]
  transit_gateway_id                              = aws_ec2_transit_gateway.poc-tgw.id
  vpc_id                                          = aws_vpc.vpc-shared.id
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
  tags = {
    Name     = "tgw-att-vpc-shared"
    scenario = "${var.scenario}"
  }
  depends_on = ["aws_ec2_transit_gateway.poc-tgw"]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-prod" {
  subnet_ids                                      = ["${aws_subnet.vpc-prod-sub-a.id}", "${aws_subnet.vpc-prod-sub-b.id}"]
  transit_gateway_id                              = aws_ec2_transit_gateway.poc-tgw.id
  vpc_id                                          = aws_vpc.vpc-prod.id
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
  tags = {
    Name     = "tgw-att-vpc-prod"
    scenario = "${var.scenario}"
  }
  depends_on = ["aws_ec2_transit_gateway.poc-tgw"]
}
