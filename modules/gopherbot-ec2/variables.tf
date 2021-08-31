variable "robot-name" {
  type        = string
  description = "The robot's name, required for provisioning multiple"
  default     = "gopherbot"
}

variable "encryption-key" {
  type        = string
  description = "The robot's brain encryption key"
}

variable "repository" {
  type        = string
  description = "The robot's configuration repository"
}

variable "protocol" {
  type        = string
  description = "The chat connection protocol to use, only 'slack' currently supported"
  default     = "slack"
}

variable "instance-type" {
  type        = string
  description = "The AWS instance type to launch"
  default     = "t3a.nano"
}

variable "subnet-id" {
  type        = string
  description = "The subnet where the instance should launch"
  default     = ""
}
