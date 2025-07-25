---
title: MSSQL
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/mssql-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/MSSQL/alerts.yaml).
{{< /panel >}}

### MSSQLAlerts

##### MSSQLHighNumberOfDeadlocks

{{< code lang="yaml" >}}
alert: MSSQLHighNumberOfDeadlocks
annotations:
  description: '{{ printf "%.2f" $value }} deadlocks have occurred over the last 5
    minutes on {{$labels.instance}}, which is above threshold of 10 deadlocks.'
  summary: There are deadlocks occurring in the database.
expr: |
  increase(mssql_deadlocks_total{}[5m]) > 10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MSSQLModerateReadStallTime

{{< code lang="yaml" >}}
alert: MSSQLModerateReadStallTime
annotations:
  description: '{{ printf "%.2f" $value }}ms of IO read stall has occurred on {{$labels.instance}},
    which is above threshold of 200ms.'
  summary: There is a moderate amount of IO stall for database reads.
expr: |
  1000 * increase(mssql_io_stall_seconds_total{operation="read"}[5m]) > 200
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MSSQLHighReadStallTime

{{< code lang="yaml" >}}
alert: MSSQLHighReadStallTime
annotations:
  description: '{{ printf "%.2f" $value }}ms of IO read stall has occurred on {{$labels.instance}},
    which is above threshold of 400ms.'
  summary: There is a high amount of IO stall for database reads.
expr: |
  1000 * increase(mssql_io_stall_seconds_total{operation="read"}[5m]) > 400
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### MSSQLModerateWriteStallTime

{{< code lang="yaml" >}}
alert: MSSQLModerateWriteStallTime
annotations:
  description: '{{ printf "%.2f" $value }}ms of IO write stall has occurred on {{$labels.instance}},
    which is above threshold of 200ms.'
  summary: There is a moderate amount of IO stall for database writes.
expr: |
  1000 * increase(mssql_io_stall_seconds_total{operation="write"}[5m]) > 200
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MSSQLHighWriteStallTime

{{< code lang="yaml" >}}
alert: MSSQLHighWriteStallTime
annotations:
  description: '{{ printf "%.2f" $value }}ms of IO write stall has occurred on {{$labels.instance}},
    which is above threshold of 400ms.'
  summary: There is a high amount of IO stall for database writes.
expr: |
  1000 * increase(mssql_io_stall_seconds_total{operation="write"}[5m]) > 400
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [logs](https://github.com/monitoring-mixins/website/blob/master/assets/MSSQL/dashboards/logs.json)
- [mssql_overview](https://github.com/monitoring-mixins/website/blob/master/assets/MSSQL/dashboards/mssql_overview.json)
- [mssql_pages](https://github.com/monitoring-mixins/website/blob/master/assets/MSSQL/dashboards/mssql_pages.json)
