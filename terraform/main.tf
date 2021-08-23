provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "tfstate-netops"
    key    = "tgw/terraform.tfstate"
    region = "us-west-2"
  }
}

# US-WEST2 accepts the Peering attachment.
provider "aws" {
  alias = "west2"
  region = var.region
}

provider "aws" {
  alias = "east1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "east2"
  region = "us-east-2"
}

data "aws_caller_identity" "west2" {
  provider = aws.west2
}

data "aws_caller_identity" "east1" {
  provider = aws.east1
}

data "aws_caller_identity" "east2" {
  provider = aws.east2
}

## US-WEST-2
resource "aws_ec2_transit_gateway" "poc_tgw_west2" {
  provider = aws.west2
  description                     = "US-WEST-2 TGW POC"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  amazon_side_asn                 = 64532
  auto_accept_shared_attachments  = "enable"
  dns_support                     = "enable"

  tags = {
    Name     = "US-WEST-2 TGW POC"
  }
}

resource "aws_ec2_transit_gateway_route_table" "tgw_prod_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.poc-tgw-west2.id
  tags = {
    Name     = "tgw-prod-rt"
  }
  depends_on = ["aws_ec2_transit_gateway.poc_tgw_west2"]
}

## US-EAST-1
resource "aws_ec2_transit_gateway" "poc_tgw_east1" {
  provider = aws.east1
  description                     = "US-EAST-1 TGW POC"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  amazon_side_asn                 = 64533
  auto_accept_shared_attachments  = "enable"
  dns_support                     = "enable"

  tags = {
    Name     = "US-EAST-1 TGW POC"
  }
}

resource "aws_ec2_transit_gateway_route_table" "tgw_prod_rt_e1" {
  transit_gateway_id = aws_ec2_transit_gateway.poc_tgw_east1.id
  tags = {
    Name     = "tgw-prod-rt-e1"
  }
  depends_on = ["aws_ec2_transit_gateway.poc_tgw_east1"]
}

## US-EAST-2

resource "aws_ec2_transit_gateway" "poc_tgw_east2" {
  provider = aws.east2

  description                     = "US-EAST-2 TGW POC"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  amazon_side_asn                 = 64534
  auto_accept_shared_attachments  = "enable"
  dns_support                     = "enable"

  tags = {
    Name     = "US-EAST-2 TGW POC"
  }
}

resource "aws_ec2_transit_gateway_route_table" "tgw_prod_rt_e2" {
  transit_gateway_id = aws_ec2_transit_gateway.poc_tgw_east2.id
  tags = {
    Name     = "tgw-prod-rt-e2"
  }
  depends_on = ["aws_ec2_transit_gateway.poc_tgw_east2"]
}

## TGW Peering

# US-WEST-2 to US-EAST-1

resource "aws_ec2_transit_gateway_peering_attachment" "west2_east1_request" {
  provider = aws.east1

  peer_account_id         = data.aws_caller_identity.west2.account_id
  peer_region             = "us-west-2"
  peer_transit_gateway_id = aws_ec2_transit_gateway.west2.id
  transit_gateway_id      = aws_ec2_transit_gateway.east1.id
  tags = {
    Name = "US-WEST-2 to US-EAST-1 CNX"
    Side = "Requesting"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "west2_east1_accept" {
  provider = aws.west2

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.west2_east1_request.id
  tags = {
    Name = "US-WEST-2 to US-EAST-1 CNX"
    Side = "Accepting"
  }
}

# US-WEST-2 to US-EAST-2

resource "aws_ec2_transit_gateway_peering_attachment" "west2_east2_request" {
  provider = aws.east2

  peer_account_id         = data.aws_caller_identity.west2.account_id
  peer_region             = "us-west-2"
  peer_transit_gateway_id = aws_ec2_transit_gateway.west2.id
  transit_gateway_id      = aws_ec2_transit_gateway.east2.id
  tags = {
    Name = "US-WEST-2 to US-EAST-2 CNX"
    Side = "Requesting"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "west2_east2_accept" {
  provider = aws.west2

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.west2_east2_request.id
  tags = {
    Name = "US-WEST-2 to US-EAST-2 CNX"
    Side = "Accepting"
  }
}

# US-EAST-1 to US-EAST-2
resource "aws_ec2_transit_gateway_peering_attachment" "east1_east2_request" {
  provider = aws.east2

  peer_account_id         = data.aws_caller_identity.west2.account_id
  peer_region             = "us-east-1"
  peer_transit_gateway_id = aws_ec2_transit_gateway.east1.id
  transit_gateway_id      = aws_ec2_transit_gateway.east2.id
  tags = {
    Name = "US-EAST-1 to US-EAST-2 CNX"
    Side = "Requesting"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "east1_east2_accept" {
  provider = aws.east1

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.east1_east2_request.id
  tags = {
    Name = "US-EAST-1 to US-EAST-2 CNX"
    Side = "Accepting"
  }
}