provider "ignition" {
  version = "1.0.1"
}

data "ignition_config" "concourse" {
  systemd = [
    "${data.ignition_systemd_unit.concourse.id}",
    "${data.ignition_systemd_unit.concourse_keygen.id}",
    "${data.ignition_systemd_unit.locksmithd.id}",
  ]

  files = [
    "${compact(list(
        "${data.ignition_file.docker-compose.id}",
        "${data.ignition_file.max_user_watches.id}",
        "${data.ignition_file.generate_keys.id}",
        "${data.ignition_file.docker_compose_yaml.id}"
      ))}",
  ]
}

data "template_file" "max_user_watches" {
  template = "${file("${path.module}/resources/sysctl.d/max-user-watches.conf")}"
}

data "ignition_file" "max_user_watches" {
  filesystem = "root"
  path       = "/etc/sysctl.d/10-max-user-watches.conf"
  mode       = 0644

  content {
    content = "${data.template_file.max_user_watches.rendered}"
  }
}

data "ignition_file" "docker-compose" {
  filesystem = "root"
  path       = "/opt/bin/docker-compose"

  source {
    source = "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-Linux-x86_64"
  }

  mode = 0555
}

data "template_file" "generate_keys" {
  template = "${file("${path.module}/resources/concourse/generate-keys.sh")}"
}

data "ignition_file" "generate_keys" {
  filesystem = "root"
  path       = "/opt/concourse/generate-keys.sh"

  content {
    content = "${data.template_file.generate_keys.rendered}"
  }

  mode = 0555
}

data "template_file" "concourse_service" {
  template = "${file("${path.module}/resources/services/concourse.service")}"
}

data "ignition_systemd_unit" "concourse" {
  name    = "concourse.service"
  content = "${data.template_file.concourse_service.rendered}"
}

data "template_file" "concourse_keygen" {
  template = "${file("${path.module}/resources/services/concoursekeygen.service")}"
}

data "ignition_systemd_unit" "concourse_keygen" {
  name    = "concourse_keygen.service"
  content = "${data.template_file.concourse_keygen.rendered}"
}

data "template_file" "docker_compose_yaml" {
  template = "${file("${path.module}/resources/concourse/docker-compose.yaml")}"

  vars {
    concourse_username = "${var.concourse_username}"
    concourse_password = "${var.concourse_password}"
    concourse_ip       = "${var.concourse_ip}"
  }
}

data "ignition_file" "docker_compose_yaml" {
  filesystem = "root"
  path       = "/opt/concourse/docker-compose.yaml"

  content {
    content = "${data.template_file.docker_compose_yaml.rendered}"
  }

  mode = 0666
}

data "ignition_systemd_unit" "locksmithd" {
  name    = "locksmithd.service"
  enabled = true

  dropin = [
    {
      name = "lock.conf"

      content = <<EOF
[Service]
Environment=REBOOT_STRATEGY=off
EOF
    },
  ]
}
