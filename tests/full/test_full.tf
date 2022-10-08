module "main" {
  source       = "../.."
  description  = "${var.name} NTP Policy."
  enabled      = true
  name         = var.name
  organization = "terratest"
  ntp_servers  = ["time-a-g.nist.gov", "time-b-g.nist.gov"]
  timezone     = "Etc/GMT"
}
