---
title: kube-state-metrics
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/kubernetes/kube-state-metrics](https://github.com/kubernetes/kube-state-metrics/tree/master/jsonnet/kube-state-metrics-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/kube-state-metrics/alerts.yaml).
{{< /panel >}}

### kube-state-metrics

##### KubeStateMetricsListErrors

{{< code lang="yaml" >}}
alert: KubeStateMetricsListErrors
annotations:
  description: kube-state-metrics is experiencing errors at an elevated rate in list
    operations. This is likely causing it to not be able to expose metrics about Kubernetes
    objects correctly or at all.
  summary: kube-state-metrics is experiencing errors in list operations.
expr: |
  (sum(rate(kube_state_metrics_list_total{job="kube-state-metrics",result="error"}[5m]))
    /
  sum(rate(kube_state_metrics_list_total{job="kube-state-metrics"}[5m])))
  > 0.01
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### KubeStateMetricsWatchErrors

{{< code lang="yaml" >}}
alert: KubeStateMetricsWatchErrors
annotations:
  description: kube-state-metrics is experiencing errors at an elevated rate in watch
    operations. This is likely causing it to not be able to expose metrics about Kubernetes
    objects correctly or at all.
  summary: kube-state-metrics is experiencing errors in watch operations.
expr: |
  (sum(rate(kube_state_metrics_watch_total{job="kube-state-metrics",result="error"}[5m]))
    /
  sum(rate(kube_state_metrics_watch_total{job="kube-state-metrics"}[5m])))
  > 0.01
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### KubeStateMetricsShardingMismatch

{{< code lang="yaml" >}}
alert: KubeStateMetricsShardingMismatch
annotations:
  description: kube-state-metrics pods are running with different --total-shards configuration,
    some Kubernetes objects may be exposed multiple times or not exposed at all.
  summary: kube-state-metrics sharding is misconfigured.
expr: |
  stdvar (kube_state_metrics_total_shards{job="kube-state-metrics"}) != 0
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### KubeStateMetricsShardsMissing

{{< code lang="yaml" >}}
alert: KubeStateMetricsShardsMissing
annotations:
  description: kube-state-metrics shards are missing, some Kubernetes objects are
    not being exposed.
  summary: kube-state-metrics shards are missing.
expr: |
  2^max(kube_state_metrics_total_shards{job="kube-state-metrics"}) - 1
    -
  sum( 2 ^ max by (shard_ordinal) (kube_state_metrics_shard_ordinal{job="kube-state-metrics"}) )
  != 0
for: 15m
labels:
  severity: critical
{{< /code >}}
 
