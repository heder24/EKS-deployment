
resource "grafana_dashboard" "cluster_monitoring" {

  config_json = <<EOF
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
   
  ],
  "time": {
    "from": "now-6h",
    "to": "now"
  },
  "refresh": "10s"
}
EOF
}



