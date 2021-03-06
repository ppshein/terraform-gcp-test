resource "google_container_cluster" "gke-cluster" {
  name               = var.cluster_name
  network            = "default"
  zone               = var.google_zone
  initial_node_count = var.cluster_init_node
}
