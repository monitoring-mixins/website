---
title: loki
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/loki](https://github.com/grafana/loki/tree/master/production/loki-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/loki/alerts.yaml).
{{< /panel >}}

### loki_alerts

##### LokiRequestErrors

{{< code lang="yaml" >}}
alert: LokiRequestErrors
annotations:
  message: |
    {{ $labels.job }} {{ $labels.route }} is experiencing {{ printf "%.2f" $value }}% errors.
expr: |
  100 * sum(rate(loki_request_duration_seconds_count{status_code=~"5.."}[2m])) by (namespace, job, route)
    /
  sum(rate(loki_request_duration_seconds_count[2m])) by (namespace, job, route)
    > 10
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### LokiRequestPanics

{{< code lang="yaml" >}}
alert: LokiRequestPanics
annotations:
  message: |
    {{ $labels.job }} is experiencing {{ printf "%.2f" $value }}% increase of panics.
expr: |
  sum(increase(loki_panic_total[10m])) by (namespace, job) > 0
labels:
  severity: critical
{{< /code >}}
 
##### LokiRequestLatency

{{< code lang="yaml" >}}
alert: LokiRequestLatency
annotations:
  message: |
    {{ $labels.job }} {{ $labels.route }} is experiencing {{ printf "%.2f" $value }}s 99th percentile latency.
expr: |
  cluster_namespace_job_route:loki_request_duration_seconds:99quantile{route!~"(?i).*tail.*|/schedulerpb.SchedulerForQuerier/QuerierLoop"} > 1
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### LokiTooManyCompactorsRunning

{{< code lang="yaml" >}}
alert: LokiTooManyCompactorsRunning
annotations:
  message: |
    {{ $labels.cluster }} {{ $labels.namespace }} has had {{ printf "%.0f" $value }} compactors running for more than 5m. Only one compactor should run at a time.
expr: |
  sum(loki_boltdb_shipper_compactor_running) by (namespace, cluster) > 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Recording rules

{{< panel style="warning" >}}
Complete list of pregenerated recording rules is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/loki/rules.yaml).
{{< /panel >}}

### loki_rules

##### cluster_job:loki_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(loki_request_duration_seconds_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:loki_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job:loki_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(loki_request_duration_seconds_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:loki_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job:loki_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(loki_request_duration_seconds_sum[1m])) by (cluster, job) / sum(rate(loki_request_duration_seconds_count[1m]))
  by (cluster, job)
record: cluster_job:loki_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_job:loki_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(loki_request_duration_seconds_bucket[1m])) by (le, cluster, job)
record: cluster_job:loki_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job:loki_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(loki_request_duration_seconds_sum[1m])) by (cluster, job)
record: cluster_job:loki_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job:loki_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(loki_request_duration_seconds_count[1m])) by (cluster, job)
record: cluster_job:loki_request_duration_seconds_count:sum_rate
{{< /code >}}
 
##### cluster_job_route:loki_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(loki_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, route))
record: cluster_job_route:loki_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job_route:loki_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(loki_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, route))
record: cluster_job_route:loki_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job_route:loki_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(loki_request_duration_seconds_sum[1m])) by (cluster, job, route) /
  sum(rate(loki_request_duration_seconds_count[1m])) by (cluster, job, route)
record: cluster_job_route:loki_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_job_route:loki_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(loki_request_duration_seconds_bucket[1m])) by (le, cluster, job, route)
record: cluster_job_route:loki_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job_route:loki_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(loki_request_duration_seconds_sum[1m])) by (cluster, job, route)
record: cluster_job_route:loki_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job_route:loki_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(loki_request_duration_seconds_count[1m])) by (cluster, job, route)
record: cluster_job_route:loki_request_duration_seconds_count:sum_rate
{{< /code >}}
 
##### cluster_namespace_job_route:loki_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(loki_request_duration_seconds_bucket[1m]))
  by (le, cluster, namespace, job, route))
record: cluster_namespace_job_route:loki_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_namespace_job_route:loki_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(loki_request_duration_seconds_bucket[1m]))
  by (le, cluster, namespace, job, route))
record: cluster_namespace_job_route:loki_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_namespace_job_route:loki_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(loki_request_duration_seconds_sum[1m])) by (cluster, namespace, job,
  route) / sum(rate(loki_request_duration_seconds_count[1m])) by (cluster, namespace,
  job, route)
record: cluster_namespace_job_route:loki_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_namespace_job_route:loki_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(loki_request_duration_seconds_bucket[1m])) by (le, cluster, namespace,
  job, route)
record: cluster_namespace_job_route:loki_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_namespace_job_route:loki_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(loki_request_duration_seconds_sum[1m])) by (cluster, namespace, job,
  route)
record: cluster_namespace_job_route:loki_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_namespace_job_route:loki_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(loki_request_duration_seconds_count[1m])) by (cluster, namespace, job,
  route)
record: cluster_namespace_job_route:loki_request_duration_seconds_count:sum_rate
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [loki-chunks](https://github.com/monitoring-mixins/website/blob/master/assets/loki/dashboards/loki-chunks.json)
- [loki-deletion](https://github.com/monitoring-mixins/website/blob/master/assets/loki/dashboards/loki-deletion.json)
- [loki-logs](https://github.com/monitoring-mixins/website/blob/master/assets/loki/dashboards/loki-logs.json)
- [loki-mixin-recording-rules](https://github.com/monitoring-mixins/website/blob/master/assets/loki/dashboards/loki-mixin-recording-rules.json)
- [loki-operational](https://github.com/monitoring-mixins/website/blob/master/assets/loki/dashboards/loki-operational.json)
- [loki-reads-resources](https://github.com/monitoring-mixins/website/blob/master/assets/loki/dashboards/loki-reads-resources.json)
- [loki-reads](https://github.com/monitoring-mixins/website/blob/master/assets/loki/dashboards/loki-reads.json)
- [loki-retention](https://github.com/monitoring-mixins/website/blob/master/assets/loki/dashboards/loki-retention.json)
- [loki-writes-resources](https://github.com/monitoring-mixins/website/blob/master/assets/loki/dashboards/loki-writes-resources.json)
- [loki-writes](https://github.com/monitoring-mixins/website/blob/master/assets/loki/dashboards/loki-writes.json)
