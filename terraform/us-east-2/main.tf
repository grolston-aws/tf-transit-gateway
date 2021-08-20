
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "tfstate-netops"
    key    = "tgw-us-east-2/terraform.tfstate"
    region = "us-west-2"
  }
}

## Transit Gateway
resource "aws_ec2_transit_gateway" "poc-tgw" {
  description                     = "US-EAST-2 TGW POC"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  amazon_side_asn                 = 64534
  auto_accept_shared_attachments  = "enable"
  dns_support                     = "enable"

  tags = {
    Name     = "${var.scenario}"
    scenario = "${var.scenario}"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment" "poc-tgw-attach-to-west-2" {
  peer_account_id         = aws_ec2_transit_gateway.poc-tgw.owner_id ## both TGWs in same account
  peer_region             = "us-west-2"
  peer_transit_gateway_id = "tgw-03fea9685797c5865"
  transit_gateway_id      = aws_ec2_transit_gateway.poc-tgw.id

  tags = {
    Name = "EAST2 TGW Peering Requestor WEST2"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "accept_peer_us_east_1" {
  transit_gateway_attachment_id = "tgw-attach-0d379323b40e1cabc"

  tags = {
    Name = "US-EAST-1 US-EAST-2"
  }
}

resource "aws_ec2_transit_gateway_route_table" "tgw-prod-rt" {
  transit_gateway_id = aws_ec2_transit_gateway.poc-tgw.id
  tags = {
    Name     = "tgw-prod-rt"
    scenario = "${var.scenario}"
  }
  depends_on = ["aws_ec2_transit_gateway.poc-tgw"]
}

resource "aws_ec2_transit_gateway_route_table" "tgw-nonprod-rt" {
  transit_gateway_id = aws_ec2_transit_gateway.poc-tgw.id
  tags = {
    Name     = "tgw-nonprod-rt"
    scenario = "${var.scenario}"
  }
  depends_on = ["aws_ec2_transit_gateway.poc-tgw"]
}
