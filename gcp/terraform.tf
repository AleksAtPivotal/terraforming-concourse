provider "google" {
  credentials = "${file(var.gcp_credentials_file)}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
  version     = "1.20"
}

module "ignition" {
  source             = "../modules/ignition"
  concourse_username = "${var.concourse_username}"
  concourse_password = "${var.concourse_password}"
  concourse_ip       = "${google_compute_address.concourse.address}"
}

data "google_compute_image" "coreos" {
  family  = "coreos-stable"
  project = "coreos-cloud"
}

data "google_compute_zones" "available" {}

resource "google_compute_instance" "concourse" {
  name         = "${random_id.servername.hex}"
  machine_type = "${var.machine_type}"

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.coreos.self_link}"
      size  = 60
    }

    auto_delete = true
  }

  network_interface {
    network = "${data.google_compute_network.default.name}"

    access_config {
      nat_ip       = "${google_compute_address.concourse.address}"
      network_tier = "STANDARD"
    }
  }
  tags = ["${random_id.servername.hex}"]

  metadata = {
    user-data = "${module.ignition.config}"

    //sshKeys = "${var.ssh_key_public == "" ? "" : "core:${var.ssh_key_public}" }"
  }

  zone = "${data.google_compute_zones.available.names[0]}"
}

resource "google_compute_address" "concourse" {
  name         = "ipv4-address"
  network_tier = "STANDARD"
}

resource "random_id" "servername" {
  prefix      = "concourse-"
  byte_length = 3
}

resource "google_compute_firewall" "default" {
  name    = "${random_id.servername.hex}-firewall"
  network = "${data.google_compute_network.default.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }
  target_tags  = ["${random_id.servername.hex}"]
  source_ranges = "${compact(list("0.0.0.0/0",))}"
}

data "google_compute_network" "default" {
  name = "default"
}