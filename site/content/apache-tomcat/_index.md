---
title: apache-tomcat
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/apache-tomcat-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/apache-tomcat/alerts.yaml).
{{< /panel >}}

### ApacheTomcatAlerts

##### ApacheTomcatAlertsHighCpuUsage

{{< code lang="yaml" >}}
alert: ApacheTomcatAlertsHighCpuUsage
annotations:
  description: The CPU usage has been at {{ printf "%.0f" $value }} percent over the
    last 5 minutes on {{$labels.instance}}, which is above the threshold of 80 percent.
  summary: The instance has a CPU usage higher than the configured threshold.
expr: |
  sum by (job,instance) (jvm_process_cpu_load{job="integrations/tomcat"}) > 80
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ApacheTomcatAlertsHighMemoryUsage

{{< code lang="yaml" >}}
alert: ApacheTomcatAlertsHighMemoryUsage
annotations:
  description: The memory usage has been at {{ printf "%.0f" $value }} percent over
    the last 5 minutes on {{$labels.instance}}, which is above the threshold of 80
    percent.
  summary: The instance has a higher memory usage than the configured threshold.
expr: |
  sum(jvm_memory_usage_used_bytes{job="integrations/tomcat"}) by (job,instance) / sum(jvm_physical_memory_bytes{job="integrations/tomcat"}) by (job,instance) * 100 > 80
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ApacheTomcatAlertsHighRequestErrorPercent

{{< code lang="yaml" >}}
alert: ApacheTomcatAlertsHighRequestErrorPercent
annotations:
  description: The percentage of request errors has been at {{ printf "%.0f" $value
    }} percent over the last 5 minutes on {{$labels.instance}}, which is above the
    threshold of 5 percent.
  summary: There are a high number of request errors.
expr: |
  sum by (job,instance) (increase(tomcat_errorcount_total{job="integrations/tomcat"}[5m]) / increase(tomcat_requestcount_total{job="integrations/tomcat"}[5m]) * 100) > 5
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ApacheTomcatAlertsModeratelyHighProcessingTime

{{< code lang="yaml" >}}
alert: ApacheTomcatAlertsModeratelyHighProcessingTime
annotations:
  description: The processing time has been at {{ printf "%.0f" $value }}ms over the
    last 5 minutes on {{$labels.instance}}, which is above the threshold of 300ms.
  summary: The processing time has been moderately high.
expr: |
  sum by (job,instance) (increase(tomcat_processingtime_total{job="integrations/tomcat"}[5m]) / increase(tomcat_requestcount_total{job="integrations/tomcat"}[5m])) > 300
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [apache-tomcat-hosts](https://github.com/monitoring-mixins/website/blob/master/assets/apache-tomcat/dashboards/apache-tomcat-hosts.json)
- [apache-tomcat-overview](https://github.com/monitoring-mixins/website/blob/master/assets/apache-tomcat/dashboards/apache-tomcat-overview.json)
