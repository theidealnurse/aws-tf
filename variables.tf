variable "instance_type" {
  type = string
  default = "t2.medium"
}

variable "ami_id" {
  type = string
  default = "ami-0e86e20dae9224db8" 
}

variable "aws_region" {
    type = string
    default = "us-east-1"
}

variable "subnet_cidr_block" {
  type = string
  default = "10.0.1.0/24"
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}