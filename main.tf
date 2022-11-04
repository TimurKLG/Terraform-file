terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.81.0"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "klg225214122514ghdhdh"
    region     = "ru-central1-a"
    key        = "C://Users//groma//terraform file//.terraform//terraform.tfstate"
    access_key = "мой ключ доступа"
    secret_key = "мой серкетный код"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
provider "yandex" {
  token     = "мой токен"
  cloud_id  = "мое облако"
  folder_id = "моя папка"
  zone      = "ru-central1-a"
}
#создание сети
resource "yandex_vpc_network" "network" {
  name = "network"
}
#создание подсети1
resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]

  depends_on = [yandex_vpc_network.network]
}
#создание подсети2
resource "yandex_vpc_subnet" "subnet2" {
  name           = "subnet2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.11.0/24"]

  depends_on = [yandex_vpc_network.network]
}

#создание 1 машины из модуля
module "ya_instance_1" {
  source                = "./modules/instance"
  instance_family_image = "lemp"
  vpc_subnet_id         = yandex_vpc_subnet.subnet1.id
  vpc_subnet_zone       = yandex_vpc_subnet.subnet1.zone

}
#создание 2 машины из модуля
module "ya_instance_2" {
  source                = "./modules/instance"
  instance_family_image = "lamp"
  vpc_subnet_id         = yandex_vpc_subnet.subnet2.id
  vpc_subnet_zone       = yandex_vpc_subnet.subnet2.zone

}
