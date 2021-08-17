
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "tfstate-netops"
    key    = "tgw-us-west-2/terraform.tfstate"
    region = "us-west-2"
  }
}

###########################
# Transit Gateway Section #
###########################

## Transit Gateway
resource "aws_ec2_transit_gateway" "poc-tgw" {
  description                     = "US-WEST-2 TGW POC"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  amazon_side_asn                 = 64532
  auto_accept_shared_attachments  = "enable"
  dns_support                     = "enabled"

  tags = {
    Name     = "${var.scenario}"
    scenario = "${var.scenario}"
  }
}

# Route Tables

resource "aws_ec2_transit_gateway_route_table" "tgw-dev-rt" {
  transit_gateway_id = aws_ec2_transit_gateway.poc-tgw.id
  tags = {
    Name     = "tgw-dev-rt"
    scenario = "${var.scenario}"
  }
  depends_on = ["aws_ec2_transit_gateway.poc-tgw"]
}

resource "aws_ec2_transit_gateway_route_table" "tgw-shared-rt" {
  transit_gateway_id = aws_ec2_transit_gateway.poc-tgw.id
  tags = {
    Name     = "tgw-shared-rt"
    scenario = "${var.scenario}"
  }
  depends_on = ["aws_ec2_transit_gateway.poc-tgw"]
}

resource "aws_ec2_transit_gateway_route_table" "tgw-prod-rt" {
  transit_gateway_id = aws_ec2_transit_gateway.poc-tgw.id
  tags = {
    Name     = "tgw-prod-rt"
    scenario = "${var.scenario}"
  }
  depends_on = ["aws_ec2_transit_gateway.poc-tgw"]
}

# Route Tables Associations
## This is the link between a VPC (already symbolized with its attachment to the Transit Gateway)
## and the Route Table the VPC's packet will hit when they arrive into the Transit Gateway.
## The Route Tables Associations do not represent the actual routes the packets are routed to.
## These are defined in the Route Tables Propagations section below.

resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpc-dev-assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-dev.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-dev-rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpc-stage-assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-stage.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-dev-rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpc-shared-assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-shared.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-shared-rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpc-prod-assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-prod.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-prod-rt.id
}

# Route Tables Propagations
## This section defines which VPCs will be routed from each Route Table created in the Transit Gateway

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-to-vpc-dev" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-dev.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-dev-rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-to-vpc-stage" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-stage.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-dev-rt.id
}
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-to-vpc-shared" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-shared.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-dev-rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-shared-to-vpc-dev" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-dev.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-shared-rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-shared-to-vpc-stage" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-stage.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-shared-rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-shared-to-vpc-prod" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-prod.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-shared-rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-prod-to-vpc-shared" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-shared.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-prod-rt.id
}

# ROUTES
