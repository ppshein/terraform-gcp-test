terraform {
  required_version = "~> 0.14.7"

  backend "gcs" {
    credentials = "./terraform-gke-keyfile.json"
    bucket      = "hb-tf-state-storage"
    prefix      = "terraform/state"
  }

  required_providers {
    google = {
      version = "~> 3.58.0"
    }

    kubernetes = {
      version = "~> 1.10"
    }

    local = {
      version = "~> 2.1.0"
    }

    random = {
      version = "~> 3.1.0"
    }
  }
}
