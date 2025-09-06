---
title: oracledb
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/oracledb-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/oracledb/alerts.yaml).
{{< /panel >}}

### OracleDBAlerts

##### OracledbReachingSessionLimit

{{< code lang="yaml" >}}
alert: OracledbReachingSessionLimit
annotations:
  description: '{{ printf "%.2f" $value }}% of sessions are being utilized which is
    above the threshold 85%. This could mean that {{$labels.instance}} is being overutilized.'
  summary: The number of sessions being utilized exceeded 85%.
expr: |
  oracledb_resource_current_utilization{resource_name="sessions"} / oracledb_resource_limit_value{resource_name="sessions"} * 100 > 85
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### OracledbReachingProcessLimit

{{< code lang="yaml" >}}
alert: OracledbReachingProcessLimit
annotations:
  description: '{{ printf "%.2f" $value }} of processes are being utilized which is
    above thethreshold 85%. This could potentially mean that {{$labels.instance}}
    runs out of processes it can spin up.'
  summary: The number of processess being utilized exceeded the threshold of 85%.
expr: |
  oracledb_resource_current_utilization{resource_name="processes"} / oracledb_resource_limit_value{resource_name="processes"} * 100 > 85
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### OracledbTablespaceReachingCapacity

{{< code lang="yaml" >}}
alert: OracledbTablespaceReachingCapacity
annotations:
  description: '{{ printf "%.2f" $value }}% of bytes are being utilized by the tablespace
    {{$labels.tablespace}} on the instance {{$labels.instance}}, which is above the
    threshold 85%.'
  summary: A tablespace is exceeding more than 85% of its maximum allotted space.
expr: |
  oracledb_tablespace_bytes / oracledb_tablespace_max_bytes * 100 > 85
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [logs](https://github.com/monitoring-mixins/website/blob/master/assets/oracledb/dashboards/logs.json)
- [oracledb-overview](https://github.com/monitoring-mixins/website/blob/master/assets/oracledb/dashboards/oracledb-overview.json)
