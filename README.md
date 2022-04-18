# terraform-vpc module

## How to use

```
module "vpc" {
  source              = "git::https://github.com/b44rawat/terraform-vpc.git"
  VPC_CIDR            = var.VPC_CIDR
  VPC_NAME            = var.VPC_NAME
  VPC_ENV             = var.VPC_ENV
  PUBLIC_SUBNET_CIDR  = var.PUBLIC_SUBNET_CIDR
  PRIVATE_SUBNET_CIDR = var.PRIVATE_SUBNET_CIDR
}

```
