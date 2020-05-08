variable "bucket_name" {
  description = "The name of the S3 bucket"
}

variable "bucket_acl" {
  description = "Access of the S3 bucket"
  default     = "private"
}