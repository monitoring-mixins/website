---
title: discourse
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/discourse-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/discourse/alerts.yaml).
{{< /panel >}}

### discourse-alerts

##### DiscourseHigh5xxErrors

{{< code lang="yaml" >}}
alert: DiscourseHigh5xxErrors
annotations:
  description: '{{ printf "%.2f" $value }}% of all requests are resulting in 500 status
    codes, which is above the threshold 10%, indicating a potentially larger issue
    for {{$labels.instance}}'
  summary: More than 10% of all requests result in a 5XX.
expr: |
  100 * rate(discourse_http_requests{status=~"5..", job="integrations/discourse"}[5m]) / on() group_left() (sum(rate(discourse_http_requests[5m])) by (instance)) > 10
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### DiscourseHigh4xxErrors

{{< code lang="yaml" >}}
alert: DiscourseHigh4xxErrors
annotations:
  description: '{{ printf "%.2f" $value }}% of all requests are resulting in 400 status
    code, which is above the threshold 30%, indicating a potentially larger issue
    for {{$labels.instance}}'
  summary: More than 30% of all requests result in a 4XX.
expr: |
  100 * rate(discourse_http_requests{status=~"4..", job="integrations/discourse"}[5m]) / on() group_left() (sum(rate(discourse_http_requests[5m])) by (instance)) > 30
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [discourse-jobs](https://github.com/monitoring-mixins/website/blob/master/assets/discourse/dashboards/discourse-jobs.json)
- [discourse-overview](https://github.com/monitoring-mixins/website/blob/master/assets/discourse/dashboards/discourse-overview.json)
