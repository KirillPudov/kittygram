output "instance_ip_addr" {
  value = "${yandex_compute_instance.kitty-vm.network_interface.0.nat_ip_address}"
}