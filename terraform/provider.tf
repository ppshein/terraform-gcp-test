provider "google" {
  credentials = file(var.gcp_config.credentials)
  project     = var.gcp_config.project_id
  region      = var.gcp_config.region
  zone        = var.gcp_config.zone
}
