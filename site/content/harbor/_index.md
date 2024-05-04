---
title: harbor
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/harbor-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/harbor/alerts.yaml).
{{< /panel >}}

### Harbor

##### HarborComponentStatus

{{< code lang="yaml" >}}
alert: HarborComponentStatus
annotations:
  description: Harbor {{ $labels.component }} has been down for more than 5 minutes
  summary: Harbor Component is Down.
expr: |
  harbor_up == 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### HarborProjectQuataExceeded

{{< code lang="yaml" >}}
alert: HarborProjectQuataExceeded
annotations:
  description: Harbor project {{ $labels.project_name }} has exceeded the configured
    disk usage quota for the past 15 minutes
  summary: Harbor project exceeds disk usage quota.
expr: |
  harbor_project_quota_usage_byte > harbor_project_quota_byte and on(harbor_project_quota_usage_byte) harbor_project_quota_byte != -1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### HarborHighErrorRate

{{< code lang="yaml" >}}
alert: HarborHighErrorRate
annotations:
  description: HTTP Requests of {{ $labels.instance }} are having a high Error rate
  summary: Harbor high error rate.
expr: sum(rate(harbor_core_http_request_total{code=~"4..|5.."}[5m]))/sum(rate(harbor_core_http_request_total[5m]))
  > 0.15
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [harbor-overview](https://github.com/monitoring-mixins/website/blob/master/assets/harbor/dashboards/harbor-overview.json)
