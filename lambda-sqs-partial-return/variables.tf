variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region to apply the infrastructure"
}

variable "account_id" {
  type        = string
  description = "AWS AccountID to be apply changes"
}


