# Create a VPC
resource "google_compute_network" "vpc" {
  name                    = "dt-vpc-1"
  auto_create_subnetworks = "false"

}

# Create a Subnet
resource "google_compute_subnetwork" "my-custom-subnet" {
  name          = "dt-app-subnet"
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.vpc.name
  region        = var.region
}
resource "google_compute_subnetwork" "my-custom-subnet2" {
  name          = "dt-db-subnet"
  ip_cidr_range = "10.10.1.0/24"
  network       = google_compute_network.vpc.name
  region        = var.region
}


## Create a VM in the above subnet

resource "google_compute_instance" "my_vm" {
  project      = var.project_name
  zone         = "asia-southeast1-a"
  name         = "dt-appvm-1"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }
  network_interface {
    network    = "dt-vpc-1"
    subnetwork = google_compute_subnetwork.my-custom-subnet.name # Replace with a reference or self link to your subnet, in quotes
  }
}


resource "google_compute_instance" "my_vm2" {
  project      = var.project_name
  zone         = "asia-southeast1-a"
  name         = "dt-dbvm-1"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }
  network_interface {
    network    = "dt-vpc-1"
    subnetwork = google_compute_subnetwork.my-custom-subnet2.name # Replace with a reference or self link to your subnet, in quotes
  }
}

resource "google_compute_instance" "my_vm3" {
  project      = var.project_name
  zone         = "asia-southeast1-a"
  name         = "dt-ansiblevm-1"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }
  network_interface {
    network    = "dt-vpc-1"
    subnetwork = google_compute_subnetwork.my-custom-subnet1.name # Replace with a reference or self link to your subnet, in quotes
  }
}


# Create a firewall to allow SSH connection from the specified source range
resource "google_compute_firewall" "rules" {
  project = var.project_name
  name    = "allow-ssh"
  network = "dt-vpc-1"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "rules" {
  project = var.project_name
  name    = "allow-http"
  network = "dt-vpc-1"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "rules" {
  project = var.project_name
  name    = "allow-https"
  network = "dt-vpc-1"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "rules" {
  project = var.project_name
  name    = "allow-postgress-onlyfrom app VM"
  network = "dt-vpc-1"

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }
  source_ranges = ["0.0.0.0/0"]
}

## Create IAP SSH permissions for your test instance

resource "google_project_iam_member" "project1" {
  project = var.project_name
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "serviceAccount:sandboxuser1@electric-node-404612.iam.gserviceaccount.com"
}

## Create Cloud Router

resource "google_compute_router" "router" {
  project = var.project_name
  name    = "nat-router"
  network = "dt-vpc-1"
  region  = var.region
}

## Create Nat Gateway

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}