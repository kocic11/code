resource "baremetal_core_volume" "Block1" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[0], "name")}" 
  compartment_id = "${var.compartment_ocid}"
  display_name = "Block1"
  size_in_mbs = "${var.256GB}"
}

resource "baremetal_core_volume_attachment" "Block1Attach" {
    attachment_type = "iscsi"
    compartment_id = "${var.compartment_ocid}"
    instance_id = "${baremetal_core_instance.Node1.id}" 
    volume_id = "${baremetal_core_volume.Block1.id}"
}

resource "baremetal_core_volume" "Block2" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[1], "name")}" 
  compartment_id = "${var.compartment_ocid}"
  display_name = "Block2"
  size_in_mbs = "${var.256GB}"
}

resource "baremetal_core_volume_attachment" "Block2Attach" {
    attachment_type = "iscsi"
    compartment_id = "${var.compartment_ocid}"
    instance_id = "${baremetal_core_instance.Node2.id}" 
    volume_id = "${baremetal_core_volume.Block2.id}"
}