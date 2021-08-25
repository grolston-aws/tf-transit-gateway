# EC2 Transit Gateway Single Account Multi-Region Peering and Organization Share

This example demonstrates how to peer multiple Transit Gateways in different regions to achieve full mesh network. Each Transit Gateway is setup as an organization share which any member account in the organization can create an attachment to. The solution deploys an additional route table which is leveraged for production routing. The default route table for the Transit Gateway is meant for non-production workloads.

## Prerequisites

- This example requires two AWS accounts within the same AWS Organizations Organization
- Ensure Resource Access Manager is enabled in your organization. For more information, see the [Resource Access Manager User Guide](https://docs.aws.amazon.com/ram/latest/userguide/getting-started-sharing.html).

## Running this example

```sh
terraform apply \
	-var="region=us-west-2it sh" \
	-var="org-id=arn:aws:organizations::55555555555:organization/o-XXXXXX" \
	-var="us-west-2-asn=64532" \
	-var="us-east-1-asn=64533" \
	-var="us-east-2-asn=64534"
```
