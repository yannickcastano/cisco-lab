locals {
physDom = "Baremetals_Physical_Domain"
}
provider "aci" {
username = "admin"
password = "cisco123"
url = "https://10.60.9.225"
insecure = true
}
resource "aci_tenant" "Terraform_provisionning" {
name = "Demo-Tenant-101"
description = "This object is managed by Terraform"
}
#----- ACI VRFs -----
resource "aci_vrf" "Production" {
tenant_dn = aci_tenant.Terraform_provisionning.id
name = "Production"
description = "This object is managed by Terraform"
}
#----- ACI application profiles -----
resource "aci_application_profile" "Production_segments" {
tenant_dn = aci_tenant.Terraform_provisionning.id
name = "Production_segments"
description = "This object is managed by Terraform"
}
#----- ACI network centric segments -----
#- network segment 102
resource "aci_application_epg" "Production_segment_102" {
application_profile_dn = aci_application_profile.Production_segments.id
name = "Production_segment_102"
relation_fv_rs_bd = aci_bridge_domain.Production_segment_102.name
relation_fv_rs_dom_att = ["${local.physDom}"]
relation_fv_rs_cons = ["${aci_contract.Contract_open.name}"]
relation_fv_rs_prov = ["${aci_contract.Contract_open.name}"]
description = "This object is managed by Terraform"
}
resource "aci_bridge_domain" "Production_segment_102" {
tenant_dn = aci_tenant.Terraform_provisionning.id
relation_fv_rs_ctx = aci_vrf.Production.name
name = "Production_segment_102"
description = "This object is managed by Terraform"
}
resource "aci_subnet" "Subnet_102" {
bridge_domain_dn = aci_bridge_domain.Production_segment_102.id
ip = "192.168.102.254/24"
description = "This object is managed by Terraform"
}
#- network segment 105
resource "aci_application_epg" "Production_segment_105" {
application_profile_dn = aci_application_profile.Production_segments.id
name = "Production_segment_105"
relation_fv_rs_bd = aci_bridge_domain.Production_segment_105.name
relation_fv_rs_dom_att = ["${local.physDom}"]
relation_fv_rs_cons = ["${aci_contract.Contract_open.name}"]
relation_fv_rs_prov = ["${aci_contract.Contract_open.name}"]
description = "This object is managed by Terraform"
}
resource "aci_bridge_domain" "Production_segment_105" {
tenant_dn = aci_tenant.Terraform_provisionning.id
relation_fv_rs_ctx = aci_vrf.Production.name
name = "Production_segment_105"
description = "This object is managed by Terraform"
}
resource "aci_subnet" "Subnet_105" {
bridge_domain_dn = aci_bridge_domain.Production_segment_105.id
ip = "192.168.105.254/24"
description = "This object is managed by Terraform"
}
#----- ACI contracts -----
resource "aci_contract" "Contract_open" {
tenant_dn = aci_tenant.Terraform_provisionning.id
name = "Contract_open"
description = "This object is managed by Terraform"
}
resource "aci_contract_subject" "Contract_open_subject1" {
contract_dn = aci_contract.Contract_open.id
name = "Subject"
relation_vz_rs_subj_filt_att = ["${aci_filter.Allow_https.name}","${aci_filter.Allow_icmp.name}"]
description = "This object is managed by Terraform"
}
#----- ACI filters -----
resource "aci_filter" "Allow_https" {
tenant_dn = aci_tenant.Terraform_provisionning.id
name = "Allow_https"
description = "This object is managed by Terraform"
}
resource "aci_filter_entry" "https" {
name = "https"
filter_dn = aci_filter.Allow_https.id
ether_t = "ip"
prot = "tcp"
d_from_port = "https"
d_to_port = "https"
stateful = "yes"
description = "This object is managed by Terraform"
}
resource "aci_filter" "Allow_icmp" {
tenant_dn = aci_tenant.Terraform_provisionning.id
name = "Allow_icmp"
description = "This object is managed by Terraform"
}
resource "aci_filter_entry" "icmp" {
name = "icmp"
filter_dn = aci_filter.Allow_icmp.id
ether_t = "ip"
prot = "icmp"
stateful = "yes"
description = "This object is managed by Terraform"
}
