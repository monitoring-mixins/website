---
title: ingress-nginx-mixin
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/adinhodovic/ingress-nginx-mixin](https://github.com/adinhodovic/ingress-nginx-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/ingress-nginx-mixin/alerts.yaml).
{{< /panel >}}

### nginx.rules

##### NginxConfigReloadFailed

{{< code lang="yaml" >}}
alert: NginxConfigReloadFailed
annotations:
  dashboard_url: https://grafana.com/d/ingress-nginx-overview-12mk/ingress-nginx-overview?var-job={{
    $labels.job }}&var-controller_class={{ $labels.controller_class }}
  description: Nginx config reload failed for the controller with the class {{ $labels.controller_class
    }}.
  summary: Nginx config reload failed.
expr: |
  sum(
    nginx_ingress_controller_config_last_reload_successful{job=~"ingress-nginx-controller-metrics"}
  ) by (job, controller_class)
  == 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### NginxHighHttp4xxErrorRate

{{< code lang="yaml" >}}
alert: NginxHighHttp4xxErrorRate
annotations:
  dashboard_url: https://grafana.com/d/ingress-nginx-overview-12mk/ingress-nginx-overview?var-exported_namespace={{
    $labels.exported_namespace }}&var-ingress={{ $labels.ingress }}
  description: More than 5% HTTP requests with status 4xx for {{ $labels.exported_namespace
    }}/{{ $labels.ingress }} the past 5m.
  summary: Nginx high HTTP 4xx error rate.
expr: |
  (sum(rate(nginx_ingress_controller_requests{job=~"ingress-nginx-controller-metrics", status=~"^4.*", ingress!~""}[5m]))  by (exported_namespace, ingress) / sum(rate(nginx_ingress_controller_requests{job=~"ingress-nginx-controller-metrics", ingress!~""}[5m]))  by (exported_namespace, ingress) * 100) > 5
for: 1m
labels:
  severity: info
{{< /code >}}
 
##### NginxHighHttp5xxErrorRate

{{< code lang="yaml" >}}
alert: NginxHighHttp5xxErrorRate
annotations:
  dashboard_url: https://grafana.com/d/ingress-nginx-overview-12mk/ingress-nginx-overview?var-exported_namespace={{
    $labels.exported_namespace }}&var-ingress={{ $labels.ingress }}
  description: More than 5% HTTP requests with status 5xx for {{ $labels.exported_namespace
    }}/{{ $labels.ingress }} the past 5m.
  summary: Nginx high HTTP 5xx error rate.
expr: |
  (sum(rate(nginx_ingress_controller_requests{job=~"ingress-nginx-controller-metrics", status=~"^5.*", ingress!~""}[5m]))  by (exported_namespace, ingress) / sum(rate(nginx_ingress_controller_requests{job=~"ingress-nginx-controller-metrics", ingress!~""}[5m]))  by (exported_namespace, ingress) * 100) > 5
for: 1m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [ingress-nginx-overview](https://github.com/monitoring-mixins/website/blob/master/assets/ingress-nginx-mixin/dashboards/ingress-nginx-overview.json)
- [ingress-nginx-request-handling-performance](https://github.com/monitoring-mixins/website/blob/master/assets/ingress-nginx-mixin/dashboards/ingress-nginx-request-handling-performance.json)
