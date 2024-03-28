variable "subnet_ids" {
  description = "List of subnet IDs to place the RDS instance in"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  type = list(string)
}