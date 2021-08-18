
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
