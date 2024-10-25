---
title: grafana
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/grafana](https://github.com/grafana/grafana/tree/master/grafana-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/grafana/alerts.yaml).
{{< /panel >}}

### GrafanaAlerts

##### GrafanaRequestsFailing

{{< code lang="yaml" >}}
alert: GrafanaRequestsFailing
annotations:
  message: '{{ $labels.namespace }}/{{ $labels.job }}/{{ $labels.handler }} is experiencing
    {{ $value | humanize }}% errors'
expr: |
  100 * sum without (status_code) (namespace_job_handler_statuscode:grafana_http_request_duration_seconds_count:rate5m{handler!~"/api/datasources/proxy/:id.*|/api/ds/query|/api/tsdb/query", status_code=~"5.."})
  /
  sum without (status_code) (namespace_job_handler_statuscode:grafana_http_request_duration_seconds_count:rate5m{handler!~"/api/datasources/proxy/:id.*|/api/ds/query|/api/tsdb/query"})
  > 50
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Recording rules

{{< panel style="warning" >}}
Complete list of pregenerated recording rules is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/grafana/rules.yaml).
{{< /panel >}}

### grafana_rules

##### namespace_job_handler_statuscode:grafana_http_request_duration_seconds_count:rate5m

{{< code lang="yaml" >}}
expr: |
  sum by (namespace, job, handler, status_code) (rate(grafana_http_request_duration_seconds_count[5m]))
record: namespace_job_handler_statuscode:grafana_http_request_duration_seconds_count:rate5m
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [grafana-overview](https://github.com/monitoring-mixins/website/blob/master/assets/grafana/dashboards/grafana-overview.json)
