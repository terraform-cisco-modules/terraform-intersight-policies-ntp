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
