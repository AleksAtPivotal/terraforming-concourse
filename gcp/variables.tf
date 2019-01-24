variable "coreos_linux_channel" {
  type        = "string"
  description = "CoreOS Linux Update Channel"
  default     = "stable"
}

variable "coreos_linux_version" {
  type        = "string"
  description = "CoreOS Linux Version"
  default     = "latest"
}

variable "gcp_region" {
  type        = "string"
  description = "GCP Region"
  default     = "us-east1"
}

variable "gcp_project" {
  type        = "string"
  description = "GCP Project Name"
}

variable "gcp_credentials_file" {
  type        = "string"
  description = "GCP Credentials File Location in the filesystem"
}

variable "machine_type" {
  type        = "string"
  description = "Machine type for concourse machien image"
  default     = "n1-standard-2"
}

variable "ssh_key_public" {
  type        = "string"
  description = "Value of Public SSH Key ie: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDR/idyieGmmHIwZC+wjUBPiGtZvYQndG9md6/EEF1tQiidocbdynxrJdiAidldLauEz2RIWFzwewALy4uU+pt/Q0HEmX32pyfxAN4LIaAZP+2Yp5DtnsxUhICum5drm6..."
  default     = ""
}

variable "concourse_username" {
  type        = "string"
  description = "Username for Concourse"
  default     = "admin"
}

variable "concourse_password" {
  type        = "string"
  description = "Password for Concourse"
  default     = "Pivotal123"
}
