
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "tfstate-netops"
    key    = "tgw-us-east-1/terraform.tfstate"
    region = "us-west-2"
  }
}

###########################
# Transit Gateway Section #
###########################

# Transit Gateway

resource "aws_ec2_transit_gateway" "poc-tgw" {
  description                     = "US-EAST-1 TGW POC"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  amazon_side_asn                 = 64533
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
    Name = "EAST1 TGW Peering Requestor WEST2"
  }
}
