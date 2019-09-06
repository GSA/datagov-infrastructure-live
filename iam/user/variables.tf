variable "name" {
  description = "IAM user name to create."
}

variable "groups" {
  default = []
  description = "List of IAM groups to assign the user to."
}
