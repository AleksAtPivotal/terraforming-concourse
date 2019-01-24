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

variable "concourse_ip" {
  type        = "string"
  description = "IP Address of concourse"
}
