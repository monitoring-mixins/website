---
title: prometheus
---

## Overview

The Prometheus Mixin is a set of configurable, reusable, and extensible alerts and dashboards for Prometheus.

{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/prometheus/prometheus](https://github.com/prometheus/prometheus/tree/master/documentation/prometheus-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/prometheus/alerts.yaml).
{{< /panel >}}

### prometheus

##### PrometheusBadConfig

{{< code lang="yaml" >}}
alert: PrometheusBadConfig
annotations:
  description: Prometheus {{$labels.instance}} has failed to reload its configuration.
  summary: Failed Prometheus configuration reload.
expr: |
  # Without max_over_time, failed scrapes could create false negatives, see
  # https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.
  max_over_time(prometheus_config_last_reload_successful{job="prometheus"}[5m]) == 0
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### PrometheusNotificationQueueRunningFull
Prometheus alert notification queue predicted to run full in less than 30m.

{{< code lang="yaml" >}}
alert: PrometheusNotificationQueueRunningFull
annotations:
  description: Alert notification queue of Prometheus {{$labels.instance}} is running full.
  summary: Prometheus alert notification queue predicted to run full in less than 30m.
expr: |
  # Without min_over_time, failed scrapes could create false negatives, see
  # https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.
  (
    predict_linear(prometheus_notifications_queue_length{job="prometheus"}[5m], 60 * 30)
  >
    min_over_time(prometheus_notifications_queue_capacity{job="prometheus"}[5m])
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusErrorSendingAlertsToSomeAlertmanagers
'{{ printf "%.1f" $value }}% errors while sending alerts from Prometheus {{$labels.instance}} to Alertmanager {{$labels.alertmanager}}.'
Prometheus has encountered more than 1% errors sending alerts to a specific Alertmanager.

{{< code lang="yaml" >}}
alert: PrometheusErrorSendingAlertsToSomeAlertmanagers
annotations:
  description: '{{ printf "%.1f" $value }}% errors while sending alerts from Prometheus {{$labels.instance}} to Alertmanager {{$labels.alertmanager}}.'
  summary: Prometheus has encountered more than 1% errors sending alerts to a specific Alertmanager.
expr: |
  (
    rate(prometheus_notifications_errors_total{job="prometheus"}[5m])
  /
    rate(prometheus_notifications_sent_total{job="prometheus"}[5m])
  )
  * 100
  > 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusErrorSendingAlertsToAnyAlertmanager
'{{ printf "%.1f" $value }}% minimum errors while sending alerts from Prometheus {{$labels.instance}} to any Alertmanager.'
Prometheus encounters more than 3% errors sending alerts to any Alertmanager.

{{< code lang="yaml" >}}
alert: PrometheusErrorSendingAlertsToAnyAlertmanager
annotations:
  description: '{{ printf "%.1f" $value }}% minimum errors while sending alerts from Prometheus {{$labels.instance}} to any Alertmanager.'
  summary: Prometheus encounters more than 3% errors sending alerts to any Alertmanager.
expr: |
  min without(alertmanager) (
    rate(prometheus_notifications_errors_total{job="prometheus"}[5m])
  /
    rate(prometheus_notifications_sent_total{job="prometheus"}[5m])
  )
  * 100
  > 3
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### PrometheusNotConnectedToAlertmanagers

{{< code lang="yaml" >}}
alert: PrometheusNotConnectedToAlertmanagers
annotations:
  description: Prometheus {{$labels.instance}} is not connected to any Alertmanagers.
  summary: Prometheus is not connected to any Alertmanagers.
expr: |
  # Without max_over_time, failed scrapes could create false negatives, see
  # https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.
  max_over_time(prometheus_notifications_alertmanagers_discovered{job="prometheus"}[5m]) < 1
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusTSDBReloadsFailing

{{< code lang="yaml" >}}
alert: PrometheusTSDBReloadsFailing
annotations:
  description: Prometheus {{$labels.instance}} has detected {{$value | humanize}} reload failures over the last 3h.
  summary: Prometheus has issues reloading blocks from disk.
expr: |
  increase(prometheus_tsdb_reloads_failures_total{job="prometheus"}[3h]) > 0
for: 4h
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusTSDBCompactionsFailing

{{< code lang="yaml" >}}
alert: PrometheusTSDBCompactionsFailing
annotations:
  description: Prometheus {{$labels.instance}} has detected {{$value | humanize}} compaction failures over the last 3h.
  summary: Prometheus has issues compacting blocks.
expr: |
  increase(prometheus_tsdb_compactions_failed_total{job="prometheus"}[3h]) > 0
for: 4h
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusNotIngestingSamples

{{< code lang="yaml" >}}
alert: PrometheusNotIngestingSamples
annotations:
  description: Prometheus {{$labels.instance}} is not ingesting samples.
  summary: Prometheus is not ingesting samples.
expr: |
  rate(prometheus_tsdb_head_samples_appended_total{job="prometheus"}[5m]) <= 0
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusDuplicateTimestamps

{{< code lang="yaml" >}}
alert: PrometheusDuplicateTimestamps
annotations:
  description: Prometheus {{$labels.instance}} is dropping {{ printf "%.4g" $value  }} samples/s with different values but duplicated timestamp.
  summary: Prometheus is dropping samples with duplicate timestamps.
expr: |
  rate(prometheus_target_scrapes_sample_duplicate_timestamp_total{job="prometheus"}[5m]) > 0
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusOutOfOrderTimestamps

{{< code lang="yaml" >}}
alert: PrometheusOutOfOrderTimestamps
annotations:
  description: Prometheus {{$labels.instance}} is dropping {{ printf "%.4g" $value  }} samples/s with timestamps arriving out of order.
  summary: Prometheus drops samples with out-of-order timestamps.
expr: |
  rate(prometheus_target_scrapes_sample_out_of_order_total{job="prometheus"}[5m]) > 0
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusRemoteStorageFailures

{{< code lang="yaml" >}}
alert: PrometheusRemoteStorageFailures
annotations:
  description: Prometheus {{$labels.instance}} failed to send {{ printf "%.1f" $value }}% of the samples to {{ $labels.remote_name}}:{{ $labels.url }}
  summary: Prometheus fails to send samples to remote storage.
expr: |
  (
    rate(prometheus_remote_storage_failed_samples_total{job="prometheus"}[5m])
  /
    (
      rate(prometheus_remote_storage_failed_samples_total{job="prometheus"}[5m])
    +
      rate(prometheus_remote_storage_succeeded_samples_total{job="prometheus"}[5m])
    )
  )
  * 100
  > 1
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### PrometheusRemoteWriteBehind

{{< code lang="yaml" >}}
alert: PrometheusRemoteWriteBehind
annotations:
  description: Prometheus {{$labels.instance}} remote write is {{ printf "%.1f" $value }}s behind for {{ $labels.remote_name}}:{{ $labels.url }}.
  summary: Prometheus remote write is behind.
expr: |
  # Without max_over_time, failed scrapes could create false negatives, see
  # https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.
  (
    max_over_time(prometheus_remote_storage_highest_timestamp_in_seconds{job="prometheus"}[5m])
  - on(job, instance) group_right
    max_over_time(prometheus_remote_storage_queue_highest_sent_timestamp_seconds{job="prometheus"}[5m])
  )
  > 120
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### PrometheusRemoteWriteDesiredShards

{{< code lang="yaml" >}}
alert: PrometheusRemoteWriteDesiredShards
annotations:
  description: Prometheus {{$labels.instance}} remote write desired shards calculation wants to run {{ $value }} shards for queue {{ $labels.remote_name}}:{{ $labels.url }}, which is more than the max of {{ printf `prometheus_remote_storage_shards_max{instance="%s",job="prometheus"}` $labels.instance | query | first | value }}.
  summary: Prometheus remote write desired shards calculation wants to run more than configured max shards.
expr: |
  # Without max_over_time, failed scrapes could create false negatives, see
  # https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.
  (
    max_over_time(prometheus_remote_storage_shards_desired{job="prometheus"}[5m])
  >
    max_over_time(prometheus_remote_storage_shards_max{job="prometheus"}[5m])
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusRuleFailures

{{< code lang="yaml" >}}
alert: PrometheusRuleFailures
annotations:
  description: Prometheus {{$labels.instance}} has failed to evaluate {{ printf "%.0f" $value }} rules in the last 5m.
  summary: Prometheus is failing rule evaluations.
expr: |
  increase(prometheus_rule_evaluation_failures_total{job="prometheus"}[5m]) > 0
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### PrometheusMissingRuleEvaluations

{{< code lang="yaml" >}}
alert: PrometheusMissingRuleEvaluations
annotations:
  description: Prometheus {{$labels.instance}} has missed {{ printf "%.0f" $value }} rule group evaluations in the last 5m.
  summary: Prometheus is missing rule evaluations due to slow rule group evaluation.
expr: |
  increase(prometheus_rule_group_iterations_missed_total{job="prometheus"}[5m]) > 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [prometheus](https://github.com/monitoring-mixins/website/blob/master/assets/prometheus/dashboards/prometheus.json)
- [prometheus-remote-write](https://github.com/monitoring-mixins/website/blob/master/assets/prometheus/dashboards/prometheus-remote-write.json)
