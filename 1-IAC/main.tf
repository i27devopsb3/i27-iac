# Lets create a new VPC
# But you can deploy the application in the default vpc. 

# Create a VPC
resource "google_compute_network" "tf-vpc" {
  name = var.vpc_name
  auto_create_subnetworks = false
}

# Create a subnet in us-central1
resource "google_compute_subnetwork" "tf-subnet" {
  name = "${var.vpc_name}-subnet"
  network = google_compute_network.tf-vpc.name # Arguments
  # network = var.vpc_name
  region = var.region
  ip_cidr_range = var.cidr
}

# This will create firewalls for the i27-ecommerce-vpc
resource "google_compute_firewall" "tf-allow-ports" {
  name = var.firewall_name
  network = google_compute_network.tf-vpc.name
  dynamic "allow" {
    for_each = var.ports
    content {
      protocol = "tcp"
      ports = [allow.value]
    }
  }
  source_ranges = ["0.0.0.0/0"]
}

# This will create Compute Engine instances which are needed for i27 infrastructure 

resource "google_compute_instance" "tf-vm-instances" {
  for_each = var.instances
  name = each.key
  zone = each.value.zone
  machine_type = each.value.instance_type
  tags = [each.key]
  
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_image.self_link
      size  = 10
      type  = "pd-balanced"
    }
  }
    network_interface {
      access_config {
        network_tier = "PREMIUM"
      }
    network = google_compute_network.tf-vpc.name
    subnetwork  = google_compute_subnetwork.tf-subnet.name
  }
}

# Data block to get images 


data "google_compute_image" "ubuntu_image" {
  family = "ubuntu-2004-lts"
  project = "ubuntu-os-cloud"
}