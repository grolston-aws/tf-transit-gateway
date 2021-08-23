
variable "region" {
  default = "us-west-2"
}

## Org ID is used for Principal in RAM Share
variable "org-id" {
  default = "arn:aws:organizations::528093727995:organization/o-neknezmwm3"
}

## ASNs for each TGW should be unique
variable "us-west-2-asn" {
  default = 64532
}

variable "us-east-1-asn" {
  default = 64533
}

variable "us-east-2-asn" {
  default = 64534
}