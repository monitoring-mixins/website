---
title: prometheus-operator
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/prometheus-operator/prometheus-operator](https://github.com/prometheus-operator/prometheus-operator/tree/master/jsonnet/mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/prometheus-operator/alerts.yaml).
{{< /panel >}}

### prometheus-operator

##### PrometheusOperatorWatchErrors

{{< code lang="yaml" >}}
alert: PrometheusOperatorWatchErrors
annotations:
  description: Errors while performing watch operations in controller {{$labels.controller}}
    in {{$labels.namespace}} namespace.
  summary: Errors while performing watch operations in controller.
expr: |
  (sum by (controller,namespace) (rate(prometheus_operator_watch_operations_failed_total{job="prometheus-operator"}[1h])) / sum by (controller,namespace) (rate(prometheus_operator_watch_operations_total{job="prometheus-operator"}[1h]))) > 0.1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusOperatorReconcileErrors

{{< code lang="yaml" >}}
alert: PrometheusOperatorReconcileErrors
annotations:
  description: '{{ $value | humanizePercentage }} of reconciling operations failed
    for {{ $labels.controller }} controller in {{ $labels.namespace }} namespace.'
  summary: Errors while reconciling controller.
expr: |
  (sum by (controller,namespace) (rate(prometheus_operator_reconcile_errors_total{job="prometheus-operator"}[5m])) / (sum by (controller,namespace) (rate(prometheus_operator_reconcile_operations_total{job="prometheus-operator"}[5m])) > 0.1
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusOperatorNodeLookupErrors

{{< code lang="yaml" >}}
alert: PrometheusOperatorNodeLookupErrors
annotations:
  description: Errors while reconciling Prometheus in {{ $labels.namespace }} Namespace.
  summary: Errors while reconciling Prometheus.
expr: |
  rate(prometheus_operator_node_address_lookup_errors_total{job="prometheus-operator"}[5m]) > 0.1
for: 10m
labels:
  severity: warning
{{< /code >}}
 
