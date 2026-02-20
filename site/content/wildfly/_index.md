---
title: wildfly
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/wildfly-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/wildfly/alerts.yaml).
{{< /panel >}}

### wildfly-alerts

##### HighPercentageOfErrorResponses

{{< code lang="yaml" >}}
alert: HighPercentageOfErrorResponses
annotations:
  description: |
    The percentage of error responses is {{ printf "%.2f" $value }} on {{ $labels.instance }} - {{ $labels.server }} which is higher than {{30 }}.
  summary: Large percentage of requests are resulting in 5XX responses.
expr: |
  sum by (job, instance, server) (increase(wildfly_undertow_error_count_total{}[5m]) / increase(wildfly_undertow_request_count_total{}[5m])) * 100 > 30
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### HighRejectedSessionsForDeployment

{{< code lang="yaml" >}}
alert: HighRejectedSessionsForDeployment
annotations:
  description: |
    Deployment {{ $labels.deployment }} on {{ $labels.instance }} is exceeding the threshold for rejected sessions {{ printf "%.0f" $value }} is higher than 20.
  summary: Large number of sessions are being rejected for a deployment.
expr: |
  sum by (deployment, instance, job) (increase(wildfly_undertow_rejected_sessions_total{}[5m])) > 20
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [wildfly-datasource](https://github.com/monitoring-mixins/website/blob/master/assets/wildfly/dashboards/wildfly-datasource.json)
- [wildfly-logs](https://github.com/monitoring-mixins/website/blob/master/assets/wildfly/dashboards/wildfly-logs.json)
- [wildfly-overview](https://github.com/monitoring-mixins/website/blob/master/assets/wildfly/dashboards/wildfly-overview.json)
