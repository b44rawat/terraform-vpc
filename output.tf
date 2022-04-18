output "VPC_ID" {
    value = aws_vpc.main_vpc.id
}

output "PUBLIC_SUBNET_LIST" {
    value = aws_subnet.public_subnet.*.id
}

output "PRIVATE_SUBNET_LIST" {
    value = aws_subnet.private_subnet.*.id
}

output "IGW_ID" {
    value = aws_internet_gateway.igw.id
}

output "NATG_ID" {
    value = aws_nat_gateway.ngw.id
}

output "NGW_ELASTIC_IP" {
    value = aws_eip.eip.public_ip
}
