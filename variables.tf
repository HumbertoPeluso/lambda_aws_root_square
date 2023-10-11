variable "env" {
  type    = string
  default = "env"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

/* variable "aws_profile" {
  type    = string
  default = "tf014"
} */

variable "aws_account_id" {
  type = string
}

variable "service_name" {
  type    = string
  default = "todos"
}

variable "email" {
  type = string
}