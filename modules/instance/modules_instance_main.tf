terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.81.0"
    }
  }
}
data "yandex_compute_image" "my_image" {
  family = var.instance_family_image
}

resource "yandex_compute_instance" "vm" {
  name = "terraform-${var.instance_family_image}"
  zone = var.vpc_subnet_zone
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
    }
  }
  #выбор подсети
  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }
  #передача ssh ключа
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
