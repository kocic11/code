# Gets a list of Availability Domains
data "baremetal_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

# Gets the OCID of the OS image to use
data "baremetal_core_images" "OLImageOCID" {
    compartment_id = "${var.compartment_ocid}"
    operating_system = "${var.InstanceOS}"
    operating_system_version = "${var.InstanceOSVersion}"
}

# Gets a list of vNIC attachments on the instance Node1
data "baremetal_core_vnic_attachments" "Node1Vnics" { 
compartment_id = "${var.compartment_ocid}" 
availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[0],"name")}" 
instance_id = "${baremetal_core_instance.Node1.id}" 
} 

# Gets the OCID of the first (default) vNIC on the instance Node1
data "baremetal_core_vnic" "Node1Vnic" { 
vnic_id = "${lookup(data.baremetal_core_vnic_attachments.Node1Vnics.vnic_attachments[0],"vnic_id")}" 
}

# # Gets a list of vNIC attachments on the instance Node2
data "baremetal_core_vnic_attachments" "Node2Vnics" { 
compartment_id = "${var.compartment_ocid}" 
availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[1],"name")}" 
instance_id = "${baremetal_core_instance.Node2.id}" 
} 

# Gets the OCID of the first (default) vNIC on the instance Node2
data "baremetal_core_vnic" "Node2Vnic" { 
vnic_id = "${lookup(data.baremetal_core_vnic_attachments.Node2Vnics.vnic_attachments[0],"vnic_id")}" 
}

data "baremetal_load_balancer_shapes" "lb_shapes" {
  compartment_id = "${var.compartment_ocid}"
}

# data "baremetal_load_balancer_policies" "lb_policies" {
#   compartment_id = "${var.compartment_ocid}"
# }

data "baremetal_load_balancer_protocols" "t" {
  compartment_id = "${var.compartment_ocid}"
}

data "baremetal_load_balancer_backendsets" "BackendSets" {
  load_balancer_id = "${baremetal_load_balancer.LoadBalancer.id}"
}
