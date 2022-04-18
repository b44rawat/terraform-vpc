## VPC SETUP

resource "aws_vpc" "main_vpc" {
    cidr_block = "${var.VPC_CIDR}"
    instance_tenancy = "default"
    tags = merge(var.ADDITIONAL_TAGS,{
        Name = "${var.VPC_ENV}-${var.VPC_NAME}"
    })
}

## DEFAULT ROUTE TABLE

resource "aws_default_route_table" "default_vpc_rt" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id

  tags = merge(var.ADDITIONAL_TAGS, {
    Name = "${var.VPC_ENV}_${var.VPC_NAME}_default_rt"
  })
}

## PUBLIC SUBNET SETUP

resource "aws_subnet" "public_subnet" {
    count = length(var.PUBLIC_SUBNET_CIDR)
    vpc_id     = aws_vpc.main_vpc.id
    cidr_block = var.PUBLIC_SUBNET_CIDR[count.index]
    tags = merge(var.ADDITIONAL_TAGS ,{
        Name = "${var.VPC_ENV}_${var.VPC_NAME}_public-subnet-${count.index + 1}"
    })
}

## PRIVATE SUBNET SETUP

resource "aws_subnet" "private_subnet" {
    count = length(var.PRIVATE_SUBNET_CIDR)
    vpc_id     = aws_vpc.main_vpc.id
    cidr_block = var.PRIVATE_SUBNET_CIDR[count.index]
    tags = merge(var.ADDITIONAL_TAGS ,{
        Name = "${var.VPC_ENV}_${var.VPC_NAME}_private-subnet-${count.index + 1}"
    })
}

## INTERNET GATEWAY SETUP

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = merge(var.ADDITIONAL_TAGS,{
    Name = "${var.VPC_ENV}_${var.VPC_NAME}-igw"
  })
}

## NAT GATEWAY SETUP

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = merge(var.ADDITIONAL_TAGS,{
    Name = "${var.VPC_ENV}_${var.VPC_NAME}-ngw"
  })
  depends_on = [
      aws_internet_gateway.igw,
      aws_subnet.public_subnet,
      aws_eip.eip
      ]
}

## SETUP ELASTIC IP FOR NATGATEWAY

resource "aws_eip" "eip" {
  vpc      = true
  tags = merge(var.ADDITIONAL_TAGS,{
    Name = "${var.VPC_ENV}_${var.VPC_NAME}-eip"
  })
}

## PUBLIC ROUTE TABLE

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.ADDITIONAL_TAGS ,{
    Name = "${var.VPC_ENV}_${var.VPC_NAME}-public-rt"
  })
}

## PRIVATE ROUTE TABLE

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = merge(var.ADDITIONAL_TAGS ,{
    Name = "${var.VPC_ENV}_${var.VPC_NAME}-private-rt"
  })
}

## PUBLIC SUBNET ROUTE TABLE ASSOCIATION

resource "aws_route_table_association" "public_rt_association" {
  count = length(var.PUBLIC_SUBNET_CIDR)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

## PRIVATE SUBNET ROUTE TABLE ASSOCIATION

resource "aws_route_table_association" "private_rt_association" {
  count = length(var.PRIVATE_SUBNET_CIDR)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
