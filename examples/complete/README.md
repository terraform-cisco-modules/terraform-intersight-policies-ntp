<!-- BEGIN_TF_DOCS -->
# NTP Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

### main.tf
```hcl
module "ntp" {
  source  = "terraform-cisco-modules/policies-ntp/intersight"
  version = ">= 1.0.1"

  description  = "default NTP Policy."
  enabled      = true
  name         = "default"
  ntp_servers  = ["time-a-g.nist.gov", "time-b-g.nist.gov"]
  organization = "default"
  timezone     = "Etc/GMT"
}
```

### provider.tf
```hcl
terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.32"
    }
  }
  required_version = ">=1.3.0"
}
```

### variables.tf
```hcl
variable "apikey" {
  description = "Intersight API Key."
  sensitive   = true
  type        = string
}

variable "endpoint" {
  default     = "https://intersight.com"
  description = "Intersight URL."
  type        = string
}

variable "secretkey" {
  description = "Intersight Secret Key."
  sensitive   = true
  type        = string
}
```
<!-- END_TF_DOCS -->