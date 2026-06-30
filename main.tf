
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_r2_bucket" "this" {
  account_id = var.cloudflare_account_id
  name       = var.bucket_name

  # Optional — uncomment and set as needed:
  # location      = "wnam"   # Valid: wnam, enam, weur, eeur, apac, oc
  # jurisdiction  = "default" # Valid: default, eu, fedramp
  # storage_class = "Standard" # Valid: Standard, InfrequentAccess
}
