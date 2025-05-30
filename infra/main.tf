terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "s3" {
    endpoints = {
      s3 = "http://storage.yandexcloud.net"
    }
    bucket = "kitty"
    region = "ru-central1"
    key    = "terraform.tfstate"

    # access_key = var.ACCESS_KEY
    # secret_key = var.SECRET_KEY

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  } 
}

provider "yandex" {
  token     = var.YANDEX_TOKEN
  cloud_id  = var.YANDEX_CLOUD_ID
  folder_id = var.YANDEX_FOLDER_ID
  zone      = var.YANDEX_ZONE
}

resource "yandex_vpc_network" "kittygram-network" {}

resource "yandex_vpc_subnet" "kittygram_subnet" {
  v4_cidr_blocks = ["192.168.1.0/24"]
  zone           = var.YANDEX_ZONE
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
  zone     = var.YANDEX_ZONE
  size     = 10
  image_id = "fd82odtq5h79jo7ffss3"
}

resource "yandex_compute_instance" "kitty-vm" {
  name        = "kitty-vm"
  platform_id = "standard-v1"
  zone        = var.YANDEX_ZONE
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
    ssh-keys = "kittygram:${var.PUB_SSH_KEY}"
    user-data  = templatefile("cloud-init.yaml.tftpl", {user = "kittygram", key = var.PUB_SSH_KEY})
  }
}