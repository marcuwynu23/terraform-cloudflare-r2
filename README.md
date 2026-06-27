# terraform-cloudflare-r2

This Terraform project provisions a Cloudflare R2 object storage bucket using the official Cloudflare Terraform provider.

## Features

- Provisions a Cloudflare R2 bucket via Infrastructure as Code
- Configurable bucket name, location, jurisdiction, and storage class
- Sensitive API token handling through Terraform variables
- Outputs bucket name and ID for downstream use (e.g., Worker bindings)

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) `>= 1.0`
- A [Cloudflare account](https://dash.cloudflare.com/sign-up)
- A Cloudflare API Token with **R2 Edit** permissions
- Your Cloudflare **Account ID**

### How to get your Cloudflare API Token

1. Log in to the [Cloudflare dashboard](https://dash.cloudflare.com/).
2. Go to **My Profile** → **API Tokens**, or open [this direct link](https://dash.cloudflare.com/profile/api-tokens).
3. Click **Create Token**.
4. Under **Custom token**, click **Get started**.
5. Give the token a descriptive name (e.g., `terraform-r2`).
6. Under **Permissions**, add:
   - `Account` → `R2` → `Edit`
7. Under **Account Resources**, select the account you want this token scoped to (e.g., `Include` → `<Your Account>`).
8. (Optional) Set **TTL** and **IP Address Filtering** as needed.
9. Click **Continue to summary** → **Create Token**.
10. Copy the generated token immediately and store it securely — it won't be shown again.

> Use a scoped API token (R2 Edit only) rather than your Global API Key for least-privilege access.

### How to get your Cloudflare Account ID

**Option A — From the dashboard URL**

1. Log in to the [Cloudflare dashboard](https://dash.cloudflare.com/).
2. Select any domain/account from your home page.
3. Look at the URL — it will be in the form:
   `https://dash.cloudflare.com/<ACCOUNT_ID>/...`
4. Copy the `<ACCOUNT_ID>` segment.

**Option B — From the Account home page**

1. Log in to the [Cloudflare dashboard](https://dash.cloudflare.com/).
2. Click **Workers & Pages** (or any domain overview).
3. On the right sidebar, find **Account ID** and click the copy icon.

**Option C — Via the API**

```bash
curl -X GET "https://api.cloudflare.com/client/v4/accounts" \
  -H "Authorization: Bearer <YOUR_API_TOKEN>" \
  -H "Content-Type: application/json"
```

The `result[].id` field in the JSON response is your Account ID.

## Usage

### 1. Clone and configure

```bash
git clone https://github.com/marcuwynu23/terraform-cloudflare-r2.git
cd terraform-cloudflare-r2
cp terraform.tfvars.example terraform.tfvars
```

### 2. Set your values in `terraform.tfvars`

```hcl
cloudflare_api_token  = "your-api-token-here"
cloudflare_account_id = "your-account-id-here"
bucket_name           = "my-r2-bucket"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Preview changes

```bash
terraform plan
```

### 5. Apply

```bash
terraform apply
```

### 6. Destroy (when no longer needed)

```bash
terraform destroy
```

## Variables

| Name                    | Description                              | Type     | Default        | Required |
| ----------------------- | ---------------------------------------- | -------- | -------------- | :------: |
| `cloudflare_api_token`  | Cloudflare API Token with R2 permissions | `string` | n/a            |   yes    |
| `cloudflare_account_id` | Cloudflare Account ID                    | `string` | n/a            |   yes    |
| `bucket_name`           | Name of the R2 bucket (3-64 chars)       | `string` | `my-r2-bucket` |    no    |

## Outputs

| Name             | Description                  |
| ---------------- | ---------------------------- |
| `r2_bucket_name` | Name of the R2 bucket        |
| `r2_bucket_id`   | ID of the R2 bucket resource |

## Usage as a Module

Reference this repository as a Terraform module in your own configurations:

> **Option 1**: Terraform Registry (recommended)
> ```hcl
> module "r2" {
>   source  = "marcuwynu23/r2/cloudflare"
>   version = "1.0.0"
>
>   cloudflare_api_token  = var.cloudflare_api_token
>   cloudflare_account_id = var.cloudflare_account_id
>   bucket_name           = "my-r2-bucket"
> }
> ```
>
> **Option 2**: GitHub source
> ```hcl
> module "r2" {
>   source = "github.com/marcuwynu23/terraform-cloudflare-r2?ref=main"
>
>   cloudflare_api_token  = var.cloudflare_api_token
>   cloudflare_account_id = var.cloudflare_account_id
>   bucket_name           = "my-r2-bucket"
> }
> ```

Then use the outputs in your configuration:

```hcl
# Example: bind the bucket to a Cloudflare Worker
resource "cloudflare_workers_script" "worker" {
  # ...
  r2_bucket_bindings {
    name        = "BUCKET"
    bucket_name = module.r2_bucket.r2_bucket_name
  }
}
```

All variables and outputs documented below are available when using this as a module.

## Optional Configuration

The `cloudflare_r2_bucket` resource supports these optional arguments (commented in `main.tf`):

- `location` — preferred data location. Valid values: `wnam`, `enam`, `weur`, `eeur`, `apac`, `oc`
- `jurisdiction` — restrict data jurisdiction. Valid values: `default`, `eu`, `fedramp`
- `storage_class` — default storage class for new objects. Valid values: `Standard`, `InfrequentAccess`

Uncomment and set them in `main.tf` as needed.

## Binding R2 to a Worker

After applying, use the output `r2_bucket_name` in your `wrangler.toml`:

```toml
[[r2_buckets]]
binding = "BUCKET"
bucket_name = "my-r2-bucket"
```

## Security Notes

- `terraform.tfvars` and `*.tfstate` files are gitignored — never commit secrets
- The API token variable is marked `sensitive` to prevent accidental log exposure
- Use a scoped API token (R2 Edit only) rather than a Global API Key

## References

- [Cloudflare R2 documentation](https://developers.cloudflare.com/r2/)
- [Cloudflare Terraform provider](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs)
- [cloudflare_r2_bucket resource](https://developers.cloudflare.com/api/terraform/resources/r2)

## License

MIT
