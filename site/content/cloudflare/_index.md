---
title: cloudflare
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/cloudflare-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/cloudflare/alerts.yaml).
{{< /panel >}}

### cloudflare-alerts

##### CloudflareHighThreatCount

{{< code lang="yaml" >}}
alert: CloudflareHighThreatCount
annotations:
  description: The number of detected threats targeting the zone {{$labels.zone}}
    is {{ printf "%.0f" $value }} which is greater than the threshold of 3.
  summary: There are detected threats targeting the zone.
expr: |
  sum without (instance) (increase(cloudflare_zone_threats_total{}[5m])) > 3
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CloudflareHighRequestRate

{{< code lang="yaml" >}}
alert: CloudflareHighRequestRate
annotations:
  description: The rate of requests to {{$labels.zone}} is {{ printf "%.0f" $value
    }}% of the prior 50 minute baseline which is above the threshold of 150%.
  summary: A high spike in requests is occurring which may indicate an attack or unexpected
    load.
expr: |
  sum without (instance) (100 * (rate(cloudflare_zone_requests_total{}[10m]) / clamp_min(rate(cloudflare_zone_requests_total{}[50m] offset 10m), 1))) > 150
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### CloudflareHighHTTPErrorCodes

{{< code lang="yaml" >}}
alert: CloudflareHighHTTPErrorCodes
annotations:
  description: The number of {{$labels.status}} HTTP status codes occurring in the
    zone {{$labels.zone}} is {{ printf "%.0f" $value }} which is greater than the
    threshold of 100.
  summary: A high number of 4xx or 5xx HTTP status codes are occurring.
expr: |
  sum without (instance) (increase(cloudflare_zone_requests_status{status=~"4.*|5.*"}[5m])) > 100
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### CloudflareUnhealthyPools

{{< code lang="yaml" >}}
alert: CloudflareUnhealthyPools
annotations:
  description: The pool {{$labels.pool_name}} in zone {{$labels.zone}} is currently
    down and unhealthy.
  summary: There are unhealthy pools.
expr: |
  sum without (instance, load_balancer_name) (cloudflare_zone_pool_health_status{}) == 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CloudflareMetricsDown

{{< code lang="yaml" >}}
alert: CloudflareMetricsDown
annotations:
  description: Grafana is no longer receiving metrics for the Cloudflare integration
    from instance {{$labels.instance}}.
  summary: Cloudflare metrics are down.
expr: |
  up{} == 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [cloudflare-geomap-overview](https://github.com/monitoring-mixins/website/blob/master/assets/cloudflare/dashboards/cloudflare-geomap-overview.json)
- [cloudflare-worker-overview](https://github.com/monitoring-mixins/website/blob/master/assets/cloudflare/dashboards/cloudflare-worker-overview.json)
- [cloudflare-zone-overview](https://github.com/monitoring-mixins/website/blob/master/assets/cloudflare/dashboards/cloudflare-zone-overview.json)
