terraform{
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "~>4.0"
        }
    }
}


resource "google_service_account" "dcim_pusher" {
    account_id = "dcim-tool-integration"
    display_name = "DCIM Tool Metric Pusher"
}

resource "google_project_iam_member" "metric_writer" {
    project = var.project_id
    role = "roles/monitoring.metricWriter"
    member  = "serviceAccount:${google_service_account.dcim_pusher.email}"

}
