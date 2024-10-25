---
title: haproxy
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/haproxy-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/haproxy/alerts.yaml).
{{< /panel >}}

### HAProxyAlerts

##### HAProxyDroppingLogs

{{< code lang="yaml" >}}
alert: HAProxyDroppingLogs
annotations:
  description: HAProxy {{$labels.job}} on {{$labels.instance}} is dropping logs.
  summary: HAProxy is dropping logs.
expr: rate(haproxy_process_dropped_logs_total[5m]) != 0
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### HAProxyBackendCheckFlapping

{{< code lang="yaml" >}}
alert: HAProxyBackendCheckFlapping
annotations:
  description: HAProxy {{$labels.job}} backend {{$labels.proxy}} on {{$labels.instance}}
    has flapping checks.
  summary: HAProxy backend checks are flapping.
expr: rate(haproxy_backend_check_up_down_total[5m]) != 0
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### HAProxyServerCheckFlapping

{{< code lang="yaml" >}}
alert: HAProxyServerCheckFlapping
annotations:
  description: HAProxy {{$labels.job}} server {{$labels.server}} on {{$labels.instance}}
    has flapping checks.
  summary: HAProxy server checks are flapping.
expr: rate(haproxy_server_check_up_down_total[5m]) != 0
for: 10m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [haproxy-backend](https://github.com/monitoring-mixins/website/blob/master/assets/haproxy/dashboards/haproxy-backend.json)
- [haproxy-frontend](https://github.com/monitoring-mixins/website/blob/master/assets/haproxy/dashboards/haproxy-frontend.json)
- [haproxy-overview](https://github.com/monitoring-mixins/website/blob/master/assets/haproxy/dashboards/haproxy-overview.json)
- [haproxy-server](https://github.com/monitoring-mixins/website/blob/master/assets/haproxy/dashboards/haproxy-server.json)
