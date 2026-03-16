terraform{
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "~>4.0"
        }
    }
}


resource "google_monitoring_metric_descriptor" "rack_temperature" {

  type = "custom.googleapis.com/rack_temperature"
  display_name = "Rack Temperature"
  description = "Temperature readings from physical data center racks"
  metric_kind = "GAUGE"
  value_type = "DOUBLE"
  unit = "{degC}"

}

resource "google_monitoring_dashboard" "dcim_dashboard" {

  dashboard_json = <<EOF
{
  "displayName": "Physical DCIM Monitor",
  "gridLayout": {
    "widgets": [
      {
        "title": "Rack Temperature Over Time",
        "xyChart": {
          "dataSets": [
            {
              "plotType": "LINE",
              "targetAxis": "Y1",
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"custom.googleapis.com/rack_temperature\""
                }
              }
            }
          ]
        }
      }
    ]
  }
}
EOF

}