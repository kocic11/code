variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}

variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}

#variable "SubnetOCID" {}

# Choose an Availability Domain
variable "AD" {
    default = "1"
}

variable "InstanceShape" {
    default = "VM.Standard1.2"
}

variable "InstanceOS" {
    default = "Oracle Linux"
}

variable "InstanceOSVersion" {
    default = "7.3"
}

variable "2TB" {
    default = "2097152"
}

variable "256GB" {
    default = "262144"
}

variable "BootStrapFile" {
    default = "./userdata/bootstrap"
}

variable "VPC-CIDR" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block1" {
  default = "10.0.1.0/24"
}

variable "subnet_cidr_block2" {
  default = "10.0.2.0/24"
}
