provider "google" {
  region      = var.region
  project     = var.project_name
  credentials = file("electric-node-404612-cd45c23dad77.json")
  zone        = "asia-southeast1"
}