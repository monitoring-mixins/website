---
title: promtail
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/loki](https://github.com/grafana/loki/tree/master/production/promtail-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/promtail/alerts.yaml).
{{< /panel >}}

### promtail_alerts

##### PromtailRequestsErrors

{{< code lang="yaml" >}}
alert: PromtailRequestsErrors
annotations:
  description: |
    {{ $labels.job }} {{ $labels.route }} is experiencing {{ printf "%.2f" $value }}% errors.
  summary: Promtail request error rate is high.
expr: |
  100 * sum(rate(promtail_request_duration_seconds_count{status_code=~"5..|failed"}[1m])) by (namespace, job, route, instance)
    /
  sum(rate(promtail_request_duration_seconds_count[1m])) by (namespace, job, route, instance)
    > 10
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### PromtailRequestLatency

{{< code lang="yaml" >}}
alert: PromtailRequestLatency
annotations:
  description: |
    {{ $labels.job }} {{ $labels.route }} is experiencing {{ printf "%.2f" $value }}s 99th percentile latency.
  summary: Promtail request latency P99 is high.
expr: |
  job_status_code_namespace:promtail_request_duration_seconds:99quantile > 1
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### PromtailFileMissing

{{< code lang="yaml" >}}
alert: PromtailFileMissing
annotations:
  description: |
    {{ $labels.instance }} {{ $labels.job }} {{ $labels.path }} matches the glob but is not being tailed.
  summary: Promtail cannot find a file it should be tailing.
expr: |
  promtail_file_bytes_total unless promtail_read_bytes_total
for: 15m
labels:
  severity: warning
{{< /code >}}
 
## Recording rules

{{< panel style="warning" >}}
Complete list of pregenerated recording rules is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/promtail/rules.yaml).
{{< /panel >}}

### promtail_rules

##### job:promtail_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(promtail_request_duration_seconds_bucket[1m]))
  by (le, job))
record: job:promtail_request_duration_seconds:99quantile
{{< /code >}}
 
##### job:promtail_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(promtail_request_duration_seconds_bucket[1m]))
  by (le, job))
record: job:promtail_request_duration_seconds:50quantile
{{< /code >}}
 
##### job:promtail_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(promtail_request_duration_seconds_sum[1m])) by (job) / sum(rate(promtail_request_duration_seconds_count[1m]))
  by (job)
record: job:promtail_request_duration_seconds:avg
{{< /code >}}
 
##### job:promtail_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(promtail_request_duration_seconds_bucket[1m])) by (le, job)
record: job:promtail_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### job:promtail_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(promtail_request_duration_seconds_sum[1m])) by (job)
record: job:promtail_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### job:promtail_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(promtail_request_duration_seconds_count[1m])) by (job)
record: job:promtail_request_duration_seconds_count:sum_rate
{{< /code >}}
 
##### job_namespace:promtail_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(promtail_request_duration_seconds_bucket[1m]))
  by (le, job, namespace))
record: job_namespace:promtail_request_duration_seconds:99quantile
{{< /code >}}
 
##### job_namespace:promtail_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(promtail_request_duration_seconds_bucket[1m]))
  by (le, job, namespace))
record: job_namespace:promtail_request_duration_seconds:50quantile
{{< /code >}}
 
##### job_namespace:promtail_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(promtail_request_duration_seconds_sum[1m])) by (job, namespace) / sum(rate(promtail_request_duration_seconds_count[1m]))
  by (job, namespace)
record: job_namespace:promtail_request_duration_seconds:avg
{{< /code >}}
 
##### job_namespace:promtail_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(promtail_request_duration_seconds_bucket[1m])) by (le, job, namespace)
record: job_namespace:promtail_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### job_namespace:promtail_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(promtail_request_duration_seconds_sum[1m])) by (job, namespace)
record: job_namespace:promtail_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### job_namespace:promtail_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(promtail_request_duration_seconds_count[1m])) by (job, namespace)
record: job_namespace:promtail_request_duration_seconds_count:sum_rate
{{< /code >}}
 
##### job_status_code_namespace:promtail_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(promtail_request_duration_seconds_bucket[1m]))
  by (le, job, status_code, namespace))
record: job_status_code_namespace:promtail_request_duration_seconds:99quantile
{{< /code >}}
 
##### job_status_code_namespace:promtail_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(promtail_request_duration_seconds_bucket[1m]))
  by (le, job, status_code, namespace))
record: job_status_code_namespace:promtail_request_duration_seconds:50quantile
{{< /code >}}
 
##### job_status_code_namespace:promtail_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(promtail_request_duration_seconds_sum[1m])) by (job, status_code, namespace)
  / sum(rate(promtail_request_duration_seconds_count[1m])) by (job, status_code, namespace)
record: job_status_code_namespace:promtail_request_duration_seconds:avg
{{< /code >}}
 
##### job_status_code_namespace:promtail_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(promtail_request_duration_seconds_bucket[1m])) by (le, job, status_code,
  namespace)
record: job_status_code_namespace:promtail_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### job_status_code_namespace:promtail_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(promtail_request_duration_seconds_sum[1m])) by (job, status_code, namespace)
record: job_status_code_namespace:promtail_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### job_status_code_namespace:promtail_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(promtail_request_duration_seconds_count[1m])) by (job, status_code,
  namespace)
record: job_status_code_namespace:promtail_request_duration_seconds_count:sum_rate
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [promtail](https://github.com/monitoring-mixins/website/blob/master/assets/promtail/dashboards/promtail.json)
