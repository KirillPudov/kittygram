terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.yandex_token
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
  zone      = var.yandex_zone
}

resource "yandex_vpc_network" "kittygram-network" {}

resource "yandex_vpc_subnet" "kittygram_subnet" {
  v4_cidr_blocks = ["192.168.1.0/24"]
  zone           = var.yandex_zone
  network_id     = yandex_vpc_network.kittygram-network.id
}

resource "yandex_vpc_security_group" "sec-group" {
  name        = "sec-group"
  network_id  = yandex_vpc_network.kittygram-network.id

  ingress {
    protocol       = "TCP"
    description    = "Allow http port"
    v4_cidr_blocks = ["192.168.1.0/24"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "Allow ssh port"
    v4_cidr_blocks = ["192.168.1.0/24"]
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all egress trafic"
    v4_cidr_blocks = ["192.168.1.0/24"]
    port = -1
  }
}

resource "yandex_compute_disk" "kitty-vm" {
  name     = "kitty-vm"
  type     = "network-ssd"
  zone     = "ru-central1-a"
  size     = 10
  image_id = "fd82odtq5h79jo7ffss3"
}

resource "yandex_compute_instance" "kitty-vm" {
  name        = "kitty-vm"
  platform_id = "standard-v1"
  zone        = var.yandex_zone
  network_interface {
    subnet_id = yandex_vpc_subnet.kittygram_subnet.id
    nat = true
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.kitty-vm.id
  }

  network_interface {
    index  = 1
    subnet_id = yandex_vpc_subnet.kittygram_subnet.id
  }

  metadata = {
    ssh-keys = "kittygram:${var.ssh_key}"
    user-data  = templatefile("cloud-init.yaml.tftpl", {user = "kittygram", key = var.ssh_key})
  }
}