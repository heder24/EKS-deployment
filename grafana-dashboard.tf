
provider "grafana" {
  url      = "http://grafana-server:3000"  # Replace with your Grafana server URL
  admin_user =  var.grafana_username                   # Replace with your Grafana admin username
  admin_password = var.grafana_password
}

resource "grafana_dashboard" "cluster_monitoring" {
  name          = "Cluster Monitoring"
  folder        = "Monitoring"  # Replace with the desired folder name

  json = <<EOF
{
  "editable": true,
  "panels": [
    {
      "type": "graph",
      "title": "CPU Usage",
      "targets": [
        {
          "refId": "A",
          "expr": "sum(cluster_cpu_usage)"
        }
      ]
    },
    {
      "type": "graph",
      "title": "Memory Usage",
      "targets": [
        {
          "refId": "A",
          "expr": "sum(cluster_memory_usage)"
        }
      ]
    }
    // Add more panels as needed
  ],
  "time": {
    "from": "now-6h",
    "to": "now"
  },
  "refresh": "10s"
}
EOF
}



