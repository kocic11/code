resource "baremetal_core_virtual_network" "CompleteVCN" {
  cidr_block        = "${var.VPC-CIDR}"
  compartment_id    = "${var.compartment_ocid}"
  display_name      = "CompleteVCN"
  dns_label         = "demo"
}

resource "baremetal_core_internet_gateway" "CompleteIG" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "CompleteIG"
    vcn_id = "${baremetal_core_virtual_network.CompleteVCN.id}"
}

resource "baremetal_core_route_table" "RouteForComplete" {
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${baremetal_core_virtual_network.CompleteVCN.id}"
    display_name = "RouteTableForComplete"
    route_rules {
        cidr_block = "0.0.0.0/0"
        network_entity_id = "${baremetal_core_internet_gateway.CompleteIG.id}"
    }
}

resource "baremetal_core_security_list" "WebSubnet" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "Public"
    vcn_id = "${baremetal_core_virtual_network.CompleteVCN.id}"
    egress_security_rules = [
        {
            destination = "0.0.0.0/0"
            protocol = "6"
        }
    ]
    
    ingress_security_rules = [
        {
            tcp_options {
                "max" = 80
                "min" = 80
            }
            protocol = "6"
            source = "0.0.0.0/0"
        },
        {
            tcp_options {
                "max" = 7001
                "min" = 7001
            }
            protocol = "6"
            source = "0.0.0.0/0"
        },
        {
            tcp_options {
                "max" = 7001
                "min" = 7001
            }
            protocol = "6"
            source = "${var.subnet_cidr_block1}"
        },
        {
            tcp_options {
                "max" = 7001
                "min" = 7001
            }
            protocol = "6"
            source = "${var.subnet_cidr_block2}"
        },
	    # {
        #     protocol = "6"
        #     source = "${var.VPC-CIDR}"
        # },
        {
            tcp_options {
                "max" = 22
                "min" = 22
            }
            protocol = "6"
            source = "0.0.0.0/0"
        }
    ]
}

resource "baremetal_core_subnet" "WebSubnetAD1" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block = "${var.subnet_cidr_block1}"
  display_name = "WebSubnetAD1"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${baremetal_core_virtual_network.CompleteVCN.id}"
  route_table_id = "${baremetal_core_route_table.RouteForComplete.id}"
  security_list_ids = ["${baremetal_core_security_list.WebSubnet.id}"]
  dns_label = "demo1"
}

resource "baremetal_core_subnet" "WebSubnetAD2" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[1],"name")}"
  cidr_block = "${var.subnet_cidr_block2}"
  display_name = "WebSubnetAD2"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${baremetal_core_virtual_network.CompleteVCN.id}"
  route_table_id = "${baremetal_core_route_table.RouteForComplete.id}"
  security_list_ids = ["${baremetal_core_security_list.WebSubnet.id}"]
  dns_label = "demo2"
}

# resource "baremetal_core_subnet" "WebSubnetAD3" {
#   availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[2],"name")}"
#   cidr_block = "10.0.3.0/24"
#   display_name = "WebSubnetAD3"
#   compartment_id = "${var.compartment_ocid}"
#   vcn_id = "${baremetal_core_virtual_network.CompleteVCN.id}"
#   route_table_id = "${baremetal_core_route_table.RouteForComplete.id}"
#   security_list_ids = ["${baremetal_core_security_list.WebSubnet.id}"]
#   dns_label = "demo3"
# }

resource "baremetal_load_balancer" "LoadBalancer" {
  shape          = "${lookup(data.baremetal_load_balancer_shapes.lb_shapes.shapes[0],"name")}"
  compartment_id = "${var.compartment_ocid}"
  subnet_ids     = ["${baremetal_core_subnet.WebSubnetAD1.id}", "${baremetal_core_subnet.WebSubnetAD2.id}"]
  display_name   = "Load Balancer"
}

resource "baremetal_load_balancer_backendset" "BackendSet" {
  load_balancer_id = "${baremetal_load_balancer.LoadBalancer.id}"
  name             = "BackendSet"
  policy           = "ROUND_ROBIN"

  health_checker {
    interval_ms         = 30000
    port                = 7001
    protocol            = "HTTP"
    url_path            = "/"
    response_body_regex = "200"
  }
}

resource "baremetal_load_balancer_listener" "Listener" {
  load_balancer_id         = "${baremetal_load_balancer.LoadBalancer.id}"
  name                     = "Listener"
  default_backend_set_name = "BackendSet"
  port                     = 80
  protocol                 = "HTTP"
}

resource "baremetal_load_balancer_backend" "BackendNode1" {
  load_balancer_id = "${baremetal_load_balancer.LoadBalancer.id}"
  backendset_name  = "BackendSet"
  ip_address       = "${data.baremetal_core_vnic.Node1Vnic.private_ip_address}"
  port             = 7001
  backup           = true
  drain            = true
  offline          = true
  weight           = 1
}

resource "baremetal_load_balancer_backend" "BackendNode2" {
  load_balancer_id = "${baremetal_load_balancer.LoadBalancer.id}"
  backendset_name  = "BackendSet"
  ip_address       = "${data.baremetal_core_vnic.Node2Vnic.private_ip_address}"
  port             = 7001
  backup           = true
  drain            = true
  offline          = true
  weight           = 1
}
