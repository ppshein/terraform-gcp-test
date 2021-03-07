# #############################################################################
# GCP Setup Info
# #############################################################################

variable "gcp_config" {
  description = "The attributes of GCP"
  type = object({
    credentials  = string
    account_id   = string
    display_name = string
    project_id   = string
    region       = string
    zone         = string
  })
}

# #############################################################################
# Kubernetes Cluster Info
# #############################################################################

variable "cluster_config" {
  description = "The attributes of GCP Cluster"
  type = object({
    cluster_name           = string
    init_node              = number
    location               = string
    subnets                = string
    network                = string
    subnetwork             = string
    ip_range_pods_name     = string
    ip_range_pods_cidr     = string
    ip_range_services_name = string
    ip_range_services_cidr = string
    node_pools = object({
      machine_type   = string
      node_locations = string
      min_count      = number
      max_count      = number
      disk_size_gb   = number
    })
  })
}

# #############################################################################
# Additional Info
# #############################################################################

variable "env" {
  description = "The environment for the GKE cluster"
  default     = "development"
}
