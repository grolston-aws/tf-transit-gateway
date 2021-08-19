# TF - AWS Transit Gateway

POC for using Terraform to manage transit-gateway

## Phase One

Deployed in US-EAST-1 and US-WEST-2:

1. TGW
2. RT DEV
3. RT STAGE
4. RT SHARED
5. RT PROD

## HOME REGION

The home region is where all the TGW PEER attachments are accepted. This region is the first TGW to be deployed. In the project the home region is `US-WEST-2`. All other regions initiate the peering request and the home region accepts it.