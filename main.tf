#____________________________________________________________
#
# Intersight Organization Data Source
# GUI Location: Settings > Settings > Organizations > {Name}
#____________________________________________________________

data "intersight_organization_organization" "org_moid" {
  name = var.organization
}

#____________________________________________________________
#
# Intersight UCS Domain Profile(s) Data Source
# GUI Location: Profiles > UCS Domain Profiles > {Name}
#____________________________________________________________

data "intersight_fabric_switch_profile" "profiles" {
  for_each = { for v in var.profiles : v => v if v.object_type == "fabric.SwitchProfile" }
  name     = each.value
}


#____________________________________________________________
#
# Intersight UCS Server Profile(s) Data Source
# GUI Location: Profiles > UCS Server Profiles > {Name}
#____________________________________________________________

data "intersight_server_profile" "profiles" {
  for_each = { for v in var.profiles : v.name => v if v.object_type == "server.Profile" }
  name     = each.value.name
}

#__________________________________________________________________
#
# Intersight UCS Server Profile Template(s) Data Source
# GUI Location: Templates > UCS Server Profile Templates > {Name}
#__________________________________________________________________

data "intersight_server_profile_template" "templates" {
  for_each = { for v in var.profiles : v.name => v if v.object_type == "server.ProfileTemplate" }
  name     = each.value.name
}

#__________________________________________________________________
#
# Intersight NTP Policy
# GUI Location: Policies > Create Policy > NTP
#__________________________________________________________________

resource "intersight_ntp_policy" "ntp" {
  depends_on = [
    data.intersight_fabric_switch_profile.profiles,
    data.intersight_server_profile.profiles,
    data.intersight_server_profile_template.templates,
    data.intersight_organization_organization.org_moid
  ]
  description = var.description != "" ? var.description : "${var.name} NTP Policy."
  enabled     = var.enabled
  name        = var.name
  ntp_servers = var.ntp_servers
  timezone    = var.timezone
  organization {
    moid        = data.intersight_organization_organization.org_moid.results[0].moid
    object_type = "organization.Organization"
  }
  dynamic "authenticated_ntp_servers" {
    for_each = var.authenticated_ntp_servers
    content {
      key_type      = "SHA1"
      object_type   = authenticated_ntp_servers.value.object_type
      server_name   = authenticated_ntp_servers.value.server_name
      sym_key_id    = authenticated_ntp_servers.value.sym_key_id
      sym_key_value = authenticated_ntp_servers.value.sym_key_value
    }
  }
  dynamic "profiles" {
    for_each = { for v in var.profiles : v.name => v }
    content {
      moid = length(regexall("fabric.SwitchProfile", profiles.value.object_type)
        ) > 0 ? data.intersight_fabric_switch_profile.profiles[profiles.value.name].results[0
        ].moid : length(regexall("server.ProfileTemplate", profiles.value.object_type)
        ) > 0 ? data.intersight_server_profile_template.templates[profiles.value.name].results[0
      ].moid : data.intersight_server_profile.profiles[profiles.value.name].results[0].moid
      object_type = profiles.value.object_type
    }
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
