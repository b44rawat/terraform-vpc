variable "VPC_CIDR" {
    type = string
}

variable "VPC_NAME" {
    type = string
}

variable "VPC_ENV" {
    type = string
}

variable "ADDITIONAL_TAGS" {
    type = map(any)
    default = {
      "ManagedBy" = "Rawat"
      "GithubProfile" = "https://github.com/b44rawat"
    }
}

variable "PUBLIC_SUBNET_CIDR" {
    type = list
}

variable "PRIVATE_SUBNET_CIDR" {
    type = list
}
