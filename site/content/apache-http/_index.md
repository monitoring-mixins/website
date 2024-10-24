---
title: apache-http
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/apache-http-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/apache-http/alerts.yaml).
{{< /panel >}}

### apache-http

##### ApacheDown

{{< code lang="yaml" >}}
alert: ApacheDown
annotations:
  description: Apache is down on {{ $labels.instance }}.
  summary: Apache is down.
expr: apache_up == 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ApacheRestart

{{< code lang="yaml" >}}
alert: ApacheRestart
annotations:
  description: Apache has just been restarted on {{ $labels.instance }}.
  summary: Apache restart.
expr: apache_uptime_seconds_total / 60 < 1
for: "0"
labels:
  severity: info
{{< /code >}}
 
##### ApacheWorkersLoad

{{< code lang="yaml" >}}
alert: ApacheWorkersLoad
annotations:
  description: |
    Apache workers in busy state approach the max workers count 80% workers busy on {{ $labels.instance }}.
    The current value is {{ $value }}%.
  summary: Apache workers load is too high.
expr: |
  (sum by (instance) (apache_workers{state="busy"}) / sum by (instance) (apache_scoreboard) ) * 100 > 80
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ApacheResponseTimeTooHigh

{{< code lang="yaml" >}}
alert: ApacheResponseTimeTooHigh
annotations:
  description: |
    Apache average response time is above the threshold of 5000 ms on {{ $labels.instance }}.
    The current value is {{ $value }} ms.
  summary: Apache response time is too high.
expr: |
  increase(apache_duration_ms_total[5m])/increase(apache_accesses_total[5m]) > 5000
for: 15m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [apache-http](https://github.com/monitoring-mixins/website/blob/master/assets/apache-http/dashboards/apache-http.json)
