# #############################################################################
# GCP Setup Info
# #############################################################################

variable "google_credentials" {
  description = "Contents of a JSON keyfile of an account with write access to the project"
}

variable "google_project" {
  description = "The GCP project to use for this run"
}

variable "google_region" {
  description = "The GCP region"
}

variable "google_zone" {
  description = "The GCP zone"
}

# #############################################################################
# Kubernetes Cluster Info
# #############################################################################

variable "cluster_name" {
  description = "The name of the Kubernetes cluster"
}

variable "cluster_init_node" {
  description = "The node count of the Kubernetes cluster"
  type        = number
  default     = 1
}
