gcp_config = {
  credentials  = "terraform-gke-keyfile.json"
  account_id   = "[ACCOUNT_ID]"
  display_name = "[DISPLAY_NAME]"
  project_id   = "[PROJECT_ID]"
  region       = "asia-southeast1"
  zone         = "asia-southeast1-a"
}

cluster_config = {
  cluster_name           = "hb-terraform-gcp-test"
  init_node              = 1
  location               = "asia-southeast1-a"
  subnets                = "10.10.0.0/16"
  network                = "hb-network"
  subnetwork             = "hb-subnet"
  ip_range_pods_name     = "hb-ip-range-pods"
  ip_range_pods_cidr     = "10.20.0.0/16"
  ip_range_services_name = "hb-ip-range-services"
  ip_range_services_cidr = "10.30.0.0/16"
  node_pools = {
    machine_type   = "e2-medium"
    node_locations = "asia-southeast1-a,asia-southeast1-b,asia-southeast1-c"
    min_count      = 1
    max_count      = 10
    disk_size_gb   = 50
  })
}