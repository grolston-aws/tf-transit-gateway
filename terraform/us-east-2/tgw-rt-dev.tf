

# Route Tables Associations
## This is the link between a VPC (already symbolized with its attachment to the Transit Gateway)
## and the Route Table the VPC's packet will hit when they arrive into the Transit Gateway.
## The Route Tables Associations do not represent the actual routes the packets are routed to.
## These are defined in the Route Tables Propagations section below.

# resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpc-dev-assoc" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-dev.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-dev-rt.id
# }

# Route Tables Propagations
## This section defines which VPCs will be routed from each Route Table created in the Transit Gateway

# resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-to-vpc-dev" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-dev.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-dev-rt.id
# }

# resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-to-vpc-stage" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-stage.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-dev-rt.id
# }

# resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-to-vpc-shared" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-shared.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-dev-rt.id
# }
