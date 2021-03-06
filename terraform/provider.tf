provider "google" {
  credentials = file("[SA].json")
  project     = var.google_project
  region      = var.google_region
  zone        = var.google_zone
}
