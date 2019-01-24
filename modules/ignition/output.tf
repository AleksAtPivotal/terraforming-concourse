output "config" {
  value = "${data.ignition_config.concourse.rendered}"
}
