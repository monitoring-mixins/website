---
title: influxdb
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/influxdb-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/influxdb/alerts.yaml).
{{< /panel >}}

### influxdb

##### InfluxDBWarningTaskHighFailureRate

{{< code lang="yaml" >}}
alert: InfluxDBWarningTaskHighFailureRate
annotations:
  description: Task scheduler task executions for instance {{$labels.instance}} on
    cluster {{$labels.influxdb_cluster}} are failing at a rate of {{ printf "%.0f"
    $value }} percent, which is above the threshold of 25 percent.
  summary: Automated data processing tasks are failing at a high rate.
expr: |
  100 * rate(task_scheduler_total_execute_failure{job="integrations/influxdb"}[5m])/clamp_min(rate(task_scheduler_total_execution_calls{job="integrations/influxdb"}[5m]), 1) >= 25
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### InfluxDBCriticalTaskHighFailureRate

{{< code lang="yaml" >}}
alert: InfluxDBCriticalTaskHighFailureRate
annotations:
  description: Task scheduler task executions for instance {{$labels.instance}} on
    cluster {{$labels.influxdb_cluster}} are failing at a rate of {{ printf "%.0f"
    $value }} percent, which is above the threshold of 50 percent.
  summary: Automated data processing tasks are failing at a critical rate.
expr: |
  100 * rate(task_scheduler_total_execute_failure{job="integrations/influxdb"}[5m])/clamp_min(rate(task_scheduler_total_execution_calls{job="integrations/influxdb"}[5m]), 1) >= 50
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### InfluxDBHighBusyWorkerPercentage

{{< code lang="yaml" >}}
alert: InfluxDBHighBusyWorkerPercentage
annotations:
  description: The busy worker percentage for instance {{$labels.instance}} on cluster
    {{$labels.influxdb_cluster}} is {{ printf "%.0f" $value }} percent, which is above
    the threshold of 80 percent.
  summary: There is a high percentage of busy workers.
expr: |
  task_executor_workers_busy{job="integrations/influxdb"} >= 80
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### InfluxDBHighHeapMemoryUsage

{{< code lang="yaml" >}}
alert: InfluxDBHighHeapMemoryUsage
annotations:
  description: The heap memory usage for instance {{$labels.instance}} on cluster
    {{$labels.influxdb_cluster}} is {{ printf "%.0f" $value }} percent, which is above
    the threshold of 80 percent.
  summary: There is a high amount of heap memory being used.
expr: |
  100 * go_memstats_heap_alloc_bytes{job="integrations/influxdb"}/clamp_min((go_memstats_heap_idle_bytes{job="integrations/influxdb"} + go_memstats_heap_alloc_bytes{job="integrations/influxdb"}), 1) >= 80
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### InfluxDBHighAverageAPIRequestLatency

{{< code lang="yaml" >}}
alert: InfluxDBHighAverageAPIRequestLatency
annotations:
  description: The average API request latency for instance {{$labels.instance}} on
    cluster {{$labels.influxdb_cluster}} is {{ printf "%.2f" $value }} seconds, which
    is above the threshold of 0.29999999999999999 seconds.
  summary: Average API request latency is too high. High latency will negatively affect
    system performance, degrading data availability and precision.
expr: |
  sum without(handler, method, path, response_code, status, user_agent) (increase(http_api_request_duration_seconds_sum{job="integrations/influxdb"}[5m])/clamp_min(increase(http_api_requests_total{job="integrations/influxdb"}[5m]), 1)) >= 0.29999999999999999
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### InfluxDBSlowAverageIQLExecutionTime

{{< code lang="yaml" >}}
alert: InfluxDBSlowAverageIQLExecutionTime
annotations:
  description: The average InfluxQL query execution time for instance {{$labels.instance}}
    on cluster {{$labels.influxdb_cluster}} is {{ printf "%.2f" $value }} seconds,
    which is above the threshold of 0.10000000000000001 seconds.
  summary: InfluxQL execution times are too slow. Slow query execution times will
    negatively affect system performance, degrading data availability and precision.
expr: |
  sum without(result) (increase(influxql_service_executing_duration_seconds_sum{job="integrations/influxdb"}[5m])/clamp_min(increase(influxql_service_requests_total{job="integrations/influxdb"}[5m]), 1)) >= 0.10000000000000001
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [influxdb-cluster-overview](https://github.com/monitoring-mixins/website/blob/master/assets/influxdb/dashboards/influxdb-cluster-overview.json)
- [influxdb-instance-overview](https://github.com/monitoring-mixins/website/blob/master/assets/influxdb/dashboards/influxdb-instance-overview.json)
- [influxdb-logs](https://github.com/monitoring-mixins/website/blob/master/assets/influxdb/dashboards/influxdb-logs.json)
