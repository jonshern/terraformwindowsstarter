variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "REGION" {
  default = "us-east-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "terrawindowskey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "terrawindowskey.pub"
}

variable "INSTANCE_USERNAME" {
  default = "Terraform"
}

variable "INSTANCE_PASSWORD" {}
