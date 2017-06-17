resource "baremetal_core_instance" "Node1" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[0],"name")}" 
  compartment_id = "${var.compartment_ocid}"
  display_name = "Node1"
  hostname_label = "node1"
  image = "${lookup(data.baremetal_core_images.OLImageOCID.images[0], "id")}"
  shape = "${var.InstanceShape}"
  subnet_id = "${baremetal_core_subnet.WebSubnetAD1.id}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(file(var.BootStrapFile))}"
  }

  timeouts {
    create = "60m"
  }
}

resource "baremetal_core_instance" "Node2" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[1],"name")}" 
  compartment_id = "${var.compartment_ocid}"
  display_name = "Node2"
  hostname_label = "node2"
  image = "${lookup(data.baremetal_core_images.OLImageOCID.images[0], "id")}"
  shape = "${var.InstanceShape}"
  subnet_id = "${baremetal_core_subnet.WebSubnetAD2.id}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(file(var.BootStrapFile))}"
  }

  timeouts {
    create = "60m"
  }
}
