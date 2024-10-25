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

##### PrometheusOperatorListErrors

{{< code lang="yaml" >}}
alert: PrometheusOperatorListErrors
annotations:
  description: Errors while performing List operations in controller {{$labels.controller}}
    in {{$labels.namespace}} namespace.
  summary: Errors while performing list operations in controller.
expr: |
  (sum by (controller,namespace) (rate(prometheus_operator_list_operations_failed_total{job="prometheus-operator"}[10m])) / sum by (controller,namespace) (rate(prometheus_operator_list_operations_total{job="prometheus-operator"}[10m]))) > 0.4
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusOperatorWatchErrors

{{< code lang="yaml" >}}
alert: PrometheusOperatorWatchErrors
annotations:
  description: Errors while performing watch operations in controller {{$labels.controller}}
    in {{$labels.namespace}} namespace.
  summary: Errors while performing watch operations in controller.
expr: |
  (sum by (controller,namespace) (rate(prometheus_operator_watch_operations_failed_total{job="prometheus-operator"}[5m])) / sum by (controller,namespace) (rate(prometheus_operator_watch_operations_total{job="prometheus-operator"}[5m]))) > 0.4
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusOperatorSyncFailed

{{< code lang="yaml" >}}
alert: PrometheusOperatorSyncFailed
annotations:
  description: Controller {{ $labels.controller }} in {{ $labels.namespace }} namespace
    fails to reconcile {{ $value }} objects.
  summary: Last controller reconciliation failed
expr: |
  min_over_time(prometheus_operator_syncs{status="failed",job="prometheus-operator"}[5m]) > 0
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusOperatorReconcileErrors

{{< code lang="yaml" >}}
alert: PrometheusOperatorReconcileErrors
annotations:
  description: '{{ $value | humanizePercentage }} of reconciling operations failed
    for {{ $labels.controller }} controller in {{ $labels.namespace }} namespace.'
  summary: Errors while reconciling objects.
expr: |
  (sum by (controller,namespace) (rate(prometheus_operator_reconcile_errors_total{job="prometheus-operator"}[5m]))) / (sum by (controller,namespace) (rate(prometheus_operator_reconcile_operations_total{job="prometheus-operator"}[5m]))) > 0.1
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusOperatorStatusUpdateErrors

{{< code lang="yaml" >}}
alert: PrometheusOperatorStatusUpdateErrors
annotations:
  description: '{{ $value | humanizePercentage }} of status update operations failed
    for {{ $labels.controller }} controller in {{ $labels.namespace }} namespace.'
  summary: Errors while updating objects status.
expr: |
  (sum by (controller,namespace) (rate(prometheus_operator_status_update_errors_total{job="prometheus-operator"}[5m]))) / (sum by (controller,namespace) (rate(prometheus_operator_status_update_operations_total{job="prometheus-operator"}[5m]))) > 0.1
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
 
##### PrometheusOperatorNotReady

{{< code lang="yaml" >}}
alert: PrometheusOperatorNotReady
annotations:
  description: Prometheus operator in {{ $labels.namespace }} namespace isn't ready
    to reconcile {{ $labels.controller }} resources.
  summary: Prometheus operator not ready
expr: |
  min by (controller,namespace) (max_over_time(prometheus_operator_ready{job="prometheus-operator"}[5m]) == 0)
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### PrometheusOperatorRejectedResources

{{< code lang="yaml" >}}
alert: PrometheusOperatorRejectedResources
annotations:
  description: Prometheus operator in {{ $labels.namespace }} namespace rejected {{
    printf "%0.0f" $value }} {{ $labels.controller }}/{{ $labels.resource }} resources.
  summary: Resources rejected by Prometheus operator
expr: |
  min_over_time(prometheus_operator_managed_resources{state="rejected",job="prometheus-operator"}[5m]) > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
### config-reloaders

##### ConfigReloaderSidecarErrors

{{< code lang="yaml" >}}
alert: ConfigReloaderSidecarErrors
annotations:
  description: |-
    Errors encountered while the {{$labels.pod}} config-reloader sidecar attempts to sync config in {{$labels.namespace}} namespace.
    As a result, configuration for service running in {{$labels.pod}} may be stale and cannot be updated anymore.
  summary: config-reloader sidecar has not had a successful reload for 10m
expr: |
  max_over_time(reloader_last_reload_successful{namespace=~".+"}[5m]) == 0
for: 10m
labels:
  severity: warning
{{< /code >}}
 
