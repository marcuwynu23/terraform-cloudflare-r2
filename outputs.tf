output "r2_bucket_name" {
  description = "Name of the R2 bucket"
  value       = cloudflare_r2_bucket.this.name
}

output "r2_bucket_id" {
  description = "ID of the R2 bucket resource"
  value       = cloudflare_r2_bucket.this.id
}
