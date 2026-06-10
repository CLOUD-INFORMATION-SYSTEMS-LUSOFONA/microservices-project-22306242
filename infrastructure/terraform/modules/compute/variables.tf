variable "vpc_id"        { type = string }
variable "subnet_id"     { type = string }
variable "ami_id"        { type = string }
variable "instance_type" { type = string }
variable "key_name"      { type = string }
variable "user_data_script" {
  type    = string
  default = ""
}