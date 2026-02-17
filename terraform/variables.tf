variable "region" {
  default = "us-east-1"
}

variable "sns_email" {}
variable "budget_email" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b"]
}
