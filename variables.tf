variable "cloudflare_api_token" {
  description = "Cloudflare API Token with R2 permissions"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "bucket_name" {
  description = "Name of the R2 bucket (3-64 characters)"
  type        = string
  default     = "my-r2-bucket"

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 64
    error_message = "Bucket name must be between 3 and 64 characters."
  }
}
