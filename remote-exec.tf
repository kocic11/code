resource "null_resource" "remote-exec1" {
    depends_on = ["baremetal_core_instance.Node1", "baremetal_core_volume_attachment.Block1Attach"]
    provisioner "remote-exec" {
      connection {
        agent = false
        timeout = "30m"
        host = "${data.baremetal_core_vnic.Node1Vnic.public_ip_address}"
        user = "opc"
        private_key = "${var.ssh_private_key}"
    }
      inline = [
        "touch ~/IMadeAFile.Right.Here",
        "sudo iscsiadm -m node -o new -T ${baremetal_core_volume_attachment.Block1Attach.iqn} -p ${baremetal_core_volume_attachment.Block1Attach.ipv4}:${baremetal_core_volume_attachment.Block1Attach.port}",
        "sudo iscsiadm -m node -o update -T ${baremetal_core_volume_attachment.Block1Attach.iqn} -n node.startup -v automatic",
        "echo sudo iscsiadm -m node -T ${baremetal_core_volume_attachment.Block1Attach.iqn} -p ${baremetal_core_volume_attachment.Block1Attach.ipv4}:${baremetal_core_volume_attachment.Block1Attach.port} -l >> ~/.bashrc"
      ]
    }
}

resource "null_resource" "remote-exec2" {
    depends_on = ["baremetal_core_instance.Node2", "baremetal_core_volume_attachment.Block2Attach"]
    provisioner "remote-exec" {
      connection {
        agent = false
        timeout = "30m"
        host = "${data.baremetal_core_vnic.Node2Vnic.public_ip_address}"
        user = "opc"
        private_key = "${var.ssh_private_key}"
    }
      inline = [
        "touch ~/IMadeAFile.Right.Here",
        "sudo iscsiadm -m node -o new -T ${baremetal_core_volume_attachment.Block2Attach.iqn} -p ${baremetal_core_volume_attachment.Block2Attach.ipv4}:${baremetal_core_volume_attachment.Block2Attach.port}",
        "sudo iscsiadm -m node -o update -T ${baremetal_core_volume_attachment.Block2Attach.iqn} -n node.startup -v automatic",
        "echo sudo iscsiadm -m node -T ${baremetal_core_volume_attachment.Block2Attach.iqn} -p ${baremetal_core_volume_attachment.Block2Attach.ipv4}:${baremetal_core_volume_attachment.Block2Attach.port} -l >> ~/.bashrc"        
      ]
    }
}