# Output the private and public IPs of the instance

output "Node1PrivateIP" {
value = ["${data.baremetal_core_vnic.Node1Vnic.private_ip_address}"]
}

output "Node1PublicIP" {
value = ["${data.baremetal_core_vnic.Node1Vnic.public_ip_address}"]
}

output "Node2PrivateIP" {
value = ["${data.baremetal_core_vnic.Node2Vnic.private_ip_address}"]
}

output "Node2PublicIP" {
value = ["${data.baremetal_core_vnic.Node2Vnic.public_ip_address}"]
}

