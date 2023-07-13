module "staff-device-private-dns-zone" {
  source       = "./modules/tf-state-mgt"
  service_name = "core"
  prefix_name  = "${module.label.id}-pvt-dns"
}
