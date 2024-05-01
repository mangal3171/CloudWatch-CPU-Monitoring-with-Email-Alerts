variable "instance_name" {}

variable "ami_value" {}

variable "region" {
  default = "eu-west-2"  # Update with your desired AWS region
}

variable "email" {
  default = "iamgroot3171@gmail.com"
}

variable "aws_instance_type" {
  default = "t2.micro"  # Default instance type for AWS EC2 instances
}

variable "key_name" {
  default = "key_london"
}


variable "subnet_id" {
  default = "subnet-08670eff352ffb3fc"
}