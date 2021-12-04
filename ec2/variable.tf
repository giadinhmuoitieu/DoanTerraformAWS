variable "ami_id" {
    type    = string
}
variable "type" {
    default = "t2.micro"
    type    = string
}
variable "name" {
    type=string
  
}
variable "key_name" {
   type    = string
}

variable "vpc_security_groups_ids" {
    type    = any
}
variable "vpc_security_groups_ids_private" {
    type    = any
}
variable "subnet_id" {
   type    = string
}
variable "private_subnet_id" {
   type    = string
}