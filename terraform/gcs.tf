module "gke_auth" {
  source       = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  depends_on   = [module.gke]
  project_id   = var.gcp_config.project_id
  location     = module.gke.location
  cluster_name = module.gke.name
}

module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 2.5"
  project_id   = var.gcp_config.project_id
  network_name = "${var.cluster_config.network}-${var.env}"
  subnets = [
    {
      subnet_name   = "${var.cluster_config.subnetwork}-${var.env}"
      subnet_ip     = var.cluster_config.subnets
      subnet_region = var.gcp_config.region
    },
  ]
  secondary_ranges = {
    "${var.cluster_config.subnetwork}-${var.env}" = [
      {
        range_name    = var.cluster_config.ip_range_pods_name
        ip_cidr_range = var.cluster_config.ip_range_pods_cidr
      },
      {
        range_name    = var.cluster_config.ip_range_services_name
        ip_cidr_range = var.cluster_config.ip_range_services_cidr
      },
    ]
  }
}

module "gke" {
  source            = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id        = var.gcp_config.project_id
  name              = "${var.cluster_config.cluster_name}-${var.env}"
  regional          = true
  region            = var.gcp_config.region
  network           = module.gcp-network.network_name
  subnetwork        = module.gcp-network.subnets_names[0]
  ip_range_pods     = var.cluster_config.ip_range_pods_name
  ip_range_services = var.cluster_config.ip_range_services_name
  node_pools = [
    {
      name           = "${var.cluster_config.cluster_name}-node-pool-${var.env}"
      machine_type   = var.cluster_config.node_pools.machine_type
      node_locations = var.cluster_config.node_pools.node_locations
      min_count      = var.cluster_config.node_pools.min_count
      max_count      = var.cluster_config.node_pools.max_count
      disk_size_gb   = var.cluster_config.node_pools.disk_size_gb
    },
  ]
}
