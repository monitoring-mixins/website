---
title: thanos
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/thanos-io/thanos](https://github.com/thanos-io/thanos/tree/master/mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/alerts.yaml).
{{< /panel >}}

### thanos-compact.rules

##### ThanosCompactMultipleRunning

{{< code lang="yaml" >}}
alert: ThanosCompactMultipleRunning
annotations:
  message: No more than one Thanos Compact instance should be running at once. There are {{ $value }}
expr: sum(up{job=~"thanos-compact.*"}) > 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosCompactHalted

{{< code lang="yaml" >}}
alert: ThanosCompactHalted
annotations:
  message: Thanos Compact {{$labels.job}} has failed to run and now is halted.
expr: thanos_compactor_halted{job=~"thanos-compact.*"} == 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosCompactHighCompactionFailures

{{< code lang="yaml" >}}
alert: ThanosCompactHighCompactionFailures
annotations:
  message: Thanos Compact {{$labels.job}} is failing to execute {{ $value | humanize }}% of compactions.
expr: |
  (
    sum by (job) (rate(thanos_compact_group_compactions_failures_total{job=~"thanos-compact.*"}[5m]))
  /
    sum by (job) (rate(thanos_compact_group_compactions_total{job=~"thanos-compact.*"}[5m]))
  * 100 > 5
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosCompactBucketHighOperationFailures

{{< code lang="yaml" >}}
alert: ThanosCompactBucketHighOperationFailures
annotations:
  message: Thanos Compact {{$labels.job}} Bucket is failing to execute {{ $value | humanize }}% of operations.
expr: |
  (
    sum by (job) (rate(thanos_objstore_bucket_operation_failures_total{job=~"thanos-compact.*"}[5m]))
  /
    sum by (job) (rate(thanos_objstore_bucket_operations_total{job=~"thanos-compact.*"}[5m]))
  * 100 > 5
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosCompactHasNotRun

{{< code lang="yaml" >}}
alert: ThanosCompactHasNotRun
annotations:
  message: Thanos Compact {{$labels.job}} has not uploaded anything for 24 hours.
expr: (time() - max(thanos_objstore_bucket_last_successful_upload_time{job=~"thanos-compact.*"})) / 60 / 60 > 24
labels:
  severity: warning
{{< /code >}}
 
### thanos-query.rules

##### ThanosQueryHttpRequestQueryErrorRateHigh

{{< code lang="yaml" >}}
alert: ThanosQueryHttpRequestQueryErrorRateHigh
annotations:
  message: Thanos Query {{$labels.job}} is failing to handle {{ $value | humanize }}% of "query" requests.
expr: |
  (
    sum(rate(http_requests_total{code=~"5..", job=~"thanos-query.*", handler="query"}[5m]))
  /
    sum(rate(http_requests_total{job=~"thanos-query.*", handler="query"}[5m]))
  ) * 100 > 5
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosQueryHttpRequestQueryRangeErrorRateHigh

{{< code lang="yaml" >}}
alert: ThanosQueryHttpRequestQueryRangeErrorRateHigh
annotations:
  message: Thanos Query {{$labels.job}} is failing to handle {{ $value | humanize }}% of "query_range" requests.
expr: |
  (
    sum(rate(http_requests_total{code=~"5..", job=~"thanos-query.*", handler="query_range"}[5m]))
  /
    sum(rate(http_requests_total{job=~"thanos-query.*", handler="query_range"}[5m]))
  ) * 100 > 5
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosQueryGrpcServerErrorRate

{{< code lang="yaml" >}}
alert: ThanosQueryGrpcServerErrorRate
annotations:
  message: Thanos Query {{$labels.job}} is failing to handle {{ $value | humanize }}% of requests.
expr: |
  (
    sum by (job) (rate(grpc_server_handled_total{grpc_code=~"Unknown|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~"thanos-query.*"}[5m]))
  /
    sum by (job) (rate(grpc_server_started_total{job=~"thanos-query.*"}[5m]))
  * 100 > 5
  )
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosQueryGrpcClientErrorRate

{{< code lang="yaml" >}}
alert: ThanosQueryGrpcClientErrorRate
annotations:
  message: Thanos Query {{$labels.job}} is failing to send {{ $value | humanize }}% of requests.
expr: |
  (
    sum by (job) (rate(grpc_client_handled_total{grpc_code!="OK", job=~"thanos-query.*"}[5m]))
  /
    sum by (job) (rate(grpc_client_started_total{job=~"thanos-query.*"}[5m]))
  ) * 100 > 5
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosQueryHighDNSFailures

{{< code lang="yaml" >}}
alert: ThanosQueryHighDNSFailures
annotations:
  message: Thanos Query {{$labels.job}} have {{ $value | humanize }}% of failing DNS queries for store endpoints.
expr: |
  (
    sum by (job) (rate(thanos_querier_store_apis_dns_failures_total{job=~"thanos-query.*"}[5m]))
  /
    sum by (job) (rate(thanos_querier_store_apis_dns_lookups_total{job=~"thanos-query.*"}[5m]))
  ) * 100 > 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosQueryInstantLatencyHigh

{{< code lang="yaml" >}}
alert: ThanosQueryInstantLatencyHigh
annotations:
  message: Thanos Query {{$labels.job}} has a 99th percentile latency of {{ $value }} seconds for instant queries.
expr: |
  (
    histogram_quantile(0.99, sum by (job, le) (rate(http_request_duration_seconds_bucket{job=~"thanos-query.*", handler="query"}[5m]))) > 40
  and
    sum by (job) (rate(http_request_duration_seconds_bucket{job=~"thanos-query.*", handler="query"}[5m])) > 0
  )
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosQueryRangeLatencyHigh

{{< code lang="yaml" >}}
alert: ThanosQueryRangeLatencyHigh
annotations:
  message: Thanos Query {{$labels.job}} has a 99th percentile latency of {{ $value }} seconds for range queries.
expr: |
  (
    histogram_quantile(0.99, sum by (job, le) (rate(http_request_duration_seconds_bucket{job=~"thanos-query.*", handler="query_range"}[5m]))) > 90
  and
    sum by (job) (rate(http_request_duration_seconds_count{job=~"thanos-query.*", handler="query_range"}[5m])) > 0
  )
for: 10m
labels:
  severity: critical
{{< /code >}}
 
### thanos-receive.rules

##### ThanosReceiveHttpRequestErrorRateHigh

{{< code lang="yaml" >}}
alert: ThanosReceiveHttpRequestErrorRateHigh
annotations:
  message: Thanos Receive {{$labels.job}} is failing to handle {{ $value | humanize }}% of requests.
expr: |
  (
    sum(rate(http_requests_total{code=~"5..", job=~"thanos-receive.*", handler="receive"}[5m]))
  /
    sum(rate(http_requests_total{job=~"thanos-receive.*", handler="receive"}[5m]))
  ) * 100 > 5
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosReceiveHttpRequestLatencyHigh

{{< code lang="yaml" >}}
alert: ThanosReceiveHttpRequestLatencyHigh
annotations:
  message: Thanos Receive {{$labels.job}} has a 99th percentile latency of {{ $value }} seconds for requests.
expr: |
  (
    histogram_quantile(0.99, sum by (job, le) (rate(http_request_duration_seconds_bucket{job=~"thanos-receive.*", handler="receive"}[5m]))) > 10
  and
    sum by (job) (rate(http_request_duration_seconds_count{job=~"thanos-receive.*", handler="receive"}[5m])) > 0
  )
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosReceiveHighForwardRequestFailures

{{< code lang="yaml" >}}
alert: ThanosReceiveHighForwardRequestFailures
annotations:
  message: Thanos Receive {{$labels.job}} is failing to forward {{ $value | humanize }}% of requests.
expr: |
  (
    sum by (job) (rate(thanos_receive_forward_requests_total{result="error", job=~"thanos-receive.*"}[5m]))
  /
    sum by (job) (rate(thanos_receive_forward_requests_total{job=~"thanos-receive.*"}[5m]))
  )
  >
  (
    max by (job) (floor((thanos_receive_replication_factor{job=~"thanos-receive.*"}+1) / 2))
  /
    max by (job) (thanos_receive_hashring_nodes{job=~"thanos-receive.*"})
  )
labels:
  severity: warning
{{< /code >}}
 
##### ThanosReceiveHighHashringFileRefreshFailures

{{< code lang="yaml" >}}
alert: ThanosReceiveHighHashringFileRefreshFailures
annotations:
  message: Thanos Receive {{$labels.job}} is failing to refresh hashring file, {{ $value | humanize }} of attempts failed.
expr: |
  (
    sum by (job) (rate(thanos_receive_hashrings_file_errors_total{job=~"thanos-receive.*"}[5m]))
  /
    sum by (job) (rate(thanos_receive_hashrings_file_refreshes_total{job=~"thanos-receive.*"}[5m]))
  > 0
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosReceiveConfigReloadFailure

{{< code lang="yaml" >}}
alert: ThanosReceiveConfigReloadFailure
annotations:
  message: Thanos Receive {{$labels.job}} has not been able to reload hashring configurations.
expr: avg(thanos_receive_config_last_reload_successful{job=~"thanos-receive.*"}) by (job) != 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosReceiveNoUpload

{{< code lang="yaml" >}}
alert: ThanosReceiveNoUpload
annotations:
  message: Thanos Receive {{$labels.job}} has not uploaded latest data to object storage.
expr: increase(thanos_shipper_uploads_total{job=~"thanos-receive.*"}[2h]) == 0
for: 30m
labels:
  severity: warning
{{< /code >}}
 
### thanos-sidecar.rules

##### ThanosSidecarPrometheusDown

{{< code lang="yaml" >}}
alert: ThanosSidecarPrometheusDown
annotations:
  message: Thanos Sidecar {{$labels.job}} {{$labels.pod}} cannot connect to Prometheus.
expr: |
  sum by (job, pod) (thanos_sidecar_prometheus_up{job=~"thanos-sidecar.*"} == 0)
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosSidecarUnhealthy

{{< code lang="yaml" >}}
alert: ThanosSidecarUnhealthy
annotations:
  message: Thanos Sidecar {{$labels.job}} {{$labels.pod}} is unhealthy for {{ $value }} seconds.
expr: |
  count(time() - max(thanos_sidecar_last_heartbeat_success_time_seconds{job=~"thanos-sidecar.*"}) by (job, pod) >= 300) > 0
labels:
  severity: critical
{{< /code >}}
 
### thanos-store.rules

##### ThanosStoreGrpcErrorRate

{{< code lang="yaml" >}}
alert: ThanosStoreGrpcErrorRate
annotations:
  message: Thanos Store {{$labels.job}} is failing to handle {{ $value | humanize }}% of requests.
expr: |
  (
    sum by (job) (rate(grpc_server_handled_total{grpc_code=~"Unknown|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~"thanos-store.*"}[5m]))
  /
    sum by (job) (rate(grpc_server_started_total{job=~"thanos-store.*"}[5m]))
  * 100 > 5
  )
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosStoreSeriesGateLatencyHigh

{{< code lang="yaml" >}}
alert: ThanosStoreSeriesGateLatencyHigh
annotations:
  message: Thanos Store {{$labels.job}} has a 99th percentile latency of {{ $value }} seconds for store series gate requests.
expr: |
  (
    histogram_quantile(0.9, sum by (job, le) (rate(thanos_bucket_store_series_gate_duration_seconds_bucket{job=~"thanos-store.*"}[5m]))) > 2
  and
    sum by (job) (rate(thanos_bucket_store_series_gate_duration_seconds_count{job=~"thanos-store.*"}[5m])) > 0
  )
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosStoreBucketHighOperationFailures

{{< code lang="yaml" >}}
alert: ThanosStoreBucketHighOperationFailures
annotations:
  message: Thanos Store {{$labels.job}} Bucket is failing to execute {{ $value | humanize }}% of operations.
expr: |
  (
    sum by (job) (rate(thanos_objstore_bucket_operation_failures_total{job=~"thanos-store.*"}[5m]))
  /
    sum by (job) (rate(thanos_objstore_bucket_operations_total{job=~"thanos-store.*"}[5m]))
  * 100 > 5
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosStoreObjstoreOperationLatencyHigh

{{< code lang="yaml" >}}
alert: ThanosStoreObjstoreOperationLatencyHigh
annotations:
  message: Thanos Store {{$labels.job}} Bucket has a 99th percentile latency of {{ $value }} seconds for the bucket operations.
expr: |
  (
    histogram_quantile(0.9, sum by (job, le) (rate(thanos_objstore_bucket_operation_duration_seconds_bucket{job=~"thanos-store.*"}[5m]))) > 2
  and
    sum by (job) (rate(thanos_objstore_bucket_operation_duration_seconds_count{job=~"thanos-store.*"}[5m])) > 0
  )
for: 10m
labels:
  severity: warning
{{< /code >}}
 
### thanos-rule.rules

##### ThanosRuleQueueIsDroppingAlerts
Thanos Rule {{$labels.job}} {{$labels.pod}} is failing to queue alerts.

{{< code lang="yaml" >}}
alert: ThanosRuleQueueIsDroppingAlerts
annotations:
  message: Thanos Rule {{$labels.job}} {{$labels.pod}} is failing to queue alerts.
expr: |
  sum by (job) (rate(thanos_alert_queue_alerts_dropped_total{job=~"thanos-rule.*"}[5m])) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosRuleSenderIsFailingAlerts
Thanos Rule {{$labels.job}} {{$labels.pod}} is failing to send alerts to alertmanager.

{{< code lang="yaml" >}}
alert: ThanosRuleSenderIsFailingAlerts
annotations:
  message: Thanos Rule {{$labels.job}} {{$labels.pod}} is failing to send alerts to alertmanager.
expr: |
  sum by (job) (rate(thanos_alert_sender_alerts_dropped_total{job=~"thanos-rule.*"}[5m])) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosRuleHighRuleEvaluationFailures

{{< code lang="yaml" >}}
alert: ThanosRuleHighRuleEvaluationFailures
annotations:
  message: Thanos Rule {{$labels.job}} {{$labels.pod}} is failing to evaluate rules.
expr: |
  (
    sum by (job) (rate(prometheus_rule_evaluation_failures_total{job=~"thanos-rule.*"}[5m]))
  /
    sum by (job) (rate(prometheus_rule_evaluations_total{job=~"thanos-rule.*"}[5m]))
  * 100 > 5
  )
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosRuleHighRuleEvaluationWarnings

{{< code lang="yaml" >}}
alert: ThanosRuleHighRuleEvaluationWarnings
annotations:
  message: Thanos Rule {{$labels.job}} {{$labels.pod}} has high number of evaluation warnings.
expr: |
  sum by (job) (rate(thanos_rule_evaluation_with_warnings_total{job=~"thanos-rule.*"}[5m])) > 0
for: 15m
labels:
  severity: info
{{< /code >}}
 
##### ThanosRuleRuleEvaluationLatencyHigh

{{< code lang="yaml" >}}
alert: ThanosRuleRuleEvaluationLatencyHigh
annotations:
  message: Thanos Rule {{$labels.job}}/{{$labels.pod}} has higher evaluation latency than interval for {{$labels.rule_group}}.
expr: |
  (
    sum by (job, pod, rule_group) (prometheus_rule_group_last_duration_seconds{job=~"thanos-rule.*"})
  >
    sum by (job, pod, rule_group) (prometheus_rule_group_interval_seconds{job=~"thanos-rule.*"})
  )
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosRuleGrpcErrorRate

{{< code lang="yaml" >}}
alert: ThanosRuleGrpcErrorRate
annotations:
  message: Thanos Rule {{$labels.job}} is failing to handle {{ $value | humanize }}% of requests.
expr: |
  (
    sum by (job) (rate(grpc_server_handled_total{grpc_code=~"Unknown|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~"thanos-rule.*"}[5m]))
  /
    sum by (job) (rate(grpc_server_started_total{job=~"thanos-rule.*"}[5m]))
  * 100 > 5
  )
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosRuleConfigReloadFailure

{{< code lang="yaml" >}}
alert: ThanosRuleConfigReloadFailure
annotations:
  message: Thanos Rule {{$labels.job}} has not been able to reload its configuration.
expr: avg(thanos_rule_config_last_reload_successful{job=~"thanos-rule.*"}) by (job) != 1
for: 5m
labels:
  severity: info
{{< /code >}}
 
##### ThanosRuleQueryHighDNSFailures

{{< code lang="yaml" >}}
alert: ThanosRuleQueryHighDNSFailures
annotations:
  message: Thanos Rule {{$labels.job}} has {{ $value | humanize }}% of failing DNS queries for query endpoints.
expr: |
  (
    sum by (job) (rate(thanos_ruler_query_apis_dns_failures_total{job=~"thanos-rule.*"}[5m]))
  /
    sum by (job) (rate(thanos_ruler_query_apis_dns_lookups_total{job=~"thanos-rule.*"}[5m]))
  * 100 > 1
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosRuleAlertmanagerHighDNSFailures

{{< code lang="yaml" >}}
alert: ThanosRuleAlertmanagerHighDNSFailures
annotations:
  message: Thanos Rule {{$labels.job}} has {{ $value | humanize }}% of failing DNS queries for Alertmanager endpoints.
expr: |
  (
    sum by (job) (rate(thanos_ruler_alertmanagers_dns_failures_total{job=~"thanos-rule.*"}[5m]))
  /
    sum by (job) (rate(thanos_ruler_alertmanagers_dns_lookups_total{job=~"thanos-rule.*"}[5m]))
  * 100 > 1
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosRuleNoEvaluationFor10Intervals

{{< code lang="yaml" >}}
alert: ThanosRuleNoEvaluationFor10Intervals
annotations:
  message: Thanos Rule {{$labels.job}} has {{ $value | humanize }}% rule groups that did not evaluate for at least 10x of their expected interval.
expr: |
  time() -  max by (job, group) (prometheus_rule_group_last_evaluation_timestamp_seconds{job=~"thanos-rule.*"})
  >
  10 * max by (job, group) (prometheus_rule_group_interval_seconds{job=~"thanos-rule.*"})
for: 5m
labels:
  severity: info
{{< /code >}}
 
##### ThanosNoRuleEvaluations

{{< code lang="yaml" >}}
alert: ThanosNoRuleEvaluations
annotations:
  message: Thanos Rule {{$labels.job}} did not perform any rule evaluations in the past 2 minutes.
expr: |
  sum(rate(prometheus_rule_evaluations_total{job=~"thanos-rule.*"}[2m])) <= 0
    and
  sum(thanos_rule_loaded_rules{job=~"thanos-rule.*"}) > 0
labels:
  severity: critical
{{< /code >}}
 
### thanos-component-absent.rules

##### ThanosCompactIsDown

{{< code lang="yaml" >}}
alert: ThanosCompactIsDown
annotations:
  message: ThanosCompact has disappeared from Prometheus target discovery.
expr: |
  absent(up{job=~"thanos-compact.*"} == 1)
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosQueryIsDown

{{< code lang="yaml" >}}
alert: ThanosQueryIsDown
annotations:
  message: ThanosQuery has disappeared from Prometheus target discovery.
expr: |
  absent(up{job=~"thanos-query.*"} == 1)
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosReceiveIsDown

{{< code lang="yaml" >}}
alert: ThanosReceiveIsDown
annotations:
  message: ThanosReceive has disappeared from Prometheus target discovery.
expr: |
  absent(up{job=~"thanos-receive.*"} == 1)
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosRuleIsDown

{{< code lang="yaml" >}}
alert: ThanosRuleIsDown
annotations:
  message: ThanosRule has disappeared from Prometheus target discovery.
expr: |
  absent(up{job=~"thanos-rule.*"} == 1)
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosSidecarIsDown

{{< code lang="yaml" >}}
alert: ThanosSidecarIsDown
annotations:
  message: ThanosSidecar has disappeared from Prometheus target discovery.
expr: |
  absent(up{job=~"thanos-sidecar.*"} == 1)
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosStoreIsDown

{{< code lang="yaml" >}}
alert: ThanosStoreIsDown
annotations:
  message: ThanosStore has disappeared from Prometheus target discovery.
expr: |
  absent(up{job=~"thanos-store.*"} == 1)
for: 5m
labels:
  severity: critical
{{< /code >}}
 
### thanos-bucket-replicate.rules

##### ThanosBucketReplicateIsDown

{{< code lang="yaml" >}}
alert: ThanosBucketReplicateIsDown
annotations:
  message: Thanos Replicate has disappeared from Prometheus target discovery.
expr: |
  absent(up{job=~"thanos-bucket-replicate.*"})
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosBucketReplicateErrorRate

{{< code lang="yaml" >}}
alert: ThanosBucketReplicateErrorRate
annotations:
  message: Thanos Replicate failing to run, {{ $value | humanize }}% of attempts failed.
expr: |
  (
    sum(rate(thanos_replicate_replication_runs_total{result="error", job=~"thanos-bucket-replicate.*"}[5m]))
  / on (namespace) group_left
    sum(rate(thanos_replicate_replication_runs_total{job=~"thanos-bucket-replicate.*"}[5m]))
  ) * 100 >= 10
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosBucketReplicateRunLatency

{{< code lang="yaml" >}}
alert: ThanosBucketReplicateRunLatency
annotations:
  message: Thanos Replicate {{$labels.job}} has a 99th percentile latency of {{ $value }} seconds for the replicate operations.
expr: |
  (
    histogram_quantile(0.9, sum by (job, le) (rate(thanos_replicate_replication_run_duration_seconds_bucket{job=~"thanos-bucket-replicate.*"}[5m]))) > 20
  and
    sum by (job) (rate(thanos_replicate_replication_run_duration_seconds_bucket{job=~"thanos-bucket-replicate.*"}[5m])) > 0
  )
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Recording rules

{{< panel style="warning" >}}
Complete list of pregenerated recording rules is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/rules.yaml).
{{< /panel >}}

### thanos-query.rules

##### :grpc_client_failures_per_unary:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum(rate(grpc_client_handled_total{grpc_code=~"Unknown|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~"thanos-query.*", grpc_type="unary"}[5m]))
  /
    sum(rate(grpc_client_started_total{job=~"thanos-query.*", grpc_type="unary"}[5m]))
  )
labels: {}
record: :grpc_client_failures_per_unary:sum_rate
{{< /code >}}
 
##### :grpc_client_failures_per_stream:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum(rate(grpc_client_handled_total{grpc_code=~"Unknown|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~"thanos-query.*", grpc_type="server_stream"}[5m]))
  /
    sum(rate(grpc_client_started_total{job=~"thanos-query.*", grpc_type="server_stream"}[5m]))
  )
labels: {}
record: :grpc_client_failures_per_stream:sum_rate
{{< /code >}}
 
##### :thanos_querier_store_apis_dns_failures_per_lookup:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum(rate(thanos_querier_store_apis_dns_failures_total{job=~"thanos-query.*"}[5m]))
  /
    sum(rate(thanos_querier_store_apis_dns_lookups_total{job=~"thanos-query.*"}[5m]))
  )
labels: {}
record: :thanos_querier_store_apis_dns_failures_per_lookup:sum_rate
{{< /code >}}
 
##### :query_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99,
    sum(rate(http_request_duration_seconds_bucket{job=~"thanos-query.*", handler="query"}[5m])) by (le)
  )
labels:
  quantile: "0.99"
record: :query_duration_seconds:histogram_quantile
{{< /code >}}
 
##### :api_range_query_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99,
    sum(rate(http_request_duration_seconds_bucket{job=~"thanos-query.*", handler="query_range"}[5m])) by (le)
  )
labels:
  quantile: "0.99"
record: :api_range_query_duration_seconds:histogram_quantile
{{< /code >}}
 
### thanos-receive.rules

##### :grpc_server_failures_per_unary:sum_rate

{{< code lang="yaml" >}}
expr: |
  sum(
    rate(grpc_server_handled_total{grpc_code=~"Unknown|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~"thanos-receive.*", grpc_type="unary"}[5m])
  /
    rate(grpc_server_started_total{job=~"thanos-receive.*", grpc_type="unary"}[5m])
  )
labels: {}
record: :grpc_server_failures_per_unary:sum_rate
{{< /code >}}
 
##### :grpc_server_failures_per_stream:sum_rate

{{< code lang="yaml" >}}
expr: |
  sum(
    rate(grpc_server_handled_total{grpc_code=~"Unknown|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~"thanos-receive.*", grpc_type="server_stream"}[5m])
  /
    rate(grpc_server_started_total{job=~"thanos-receive.*", grpc_type="server_stream"}[5m])
  )
labels: {}
record: :grpc_server_failures_per_stream:sum_rate
{{< /code >}}
 
##### :http_failure_per_request:sum_rate

{{< code lang="yaml" >}}
expr: |
  sum(
    rate(http_requests_total{handler="receive", job=~"thanos-receive.*", code!~"5.."}[5m])
  /
    rate(http_requests_total{handler="receive", job=~"thanos-receive.*"}[5m])
  )
labels: {}
record: :http_failure_per_request:sum_rate
{{< /code >}}
 
##### :http_request_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99,
    sum(rate(http_request_duration_seconds_bucket{handler="receive", job=~"thanos-receive.*"}[5m])) by (le)
  )
labels:
  quantile: "0.99"
record: :http_request_duration_seconds:histogram_quantile
{{< /code >}}
 
##### :thanos_receive_forward_failure_per_requests:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum(rate(thanos_receive_forward_requests_total{result="error", job=~"thanos-receive.*"}[5m]))
  /
    sum(rate(thanos_receive_forward_requests_total{job=~"thanos-receive.*"}[5m]))
  )
labels: {}
record: :thanos_receive_forward_failure_per_requests:sum_rate
{{< /code >}}
 
##### :thanos_receive_hashring_file_failure_per_refresh:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum(rate(thanos_receive_hashrings_file_errors_total{job=~"thanos-receive.*"}[5m]))
  /
    sum(rate(thanos_receive_hashrings_file_refreshes_total{job=~"thanos-receive.*"}[5m]))
  )
labels: {}
record: :thanos_receive_hashring_file_failure_per_refresh:sum_rate
{{< /code >}}
 
### thanos-store.rules

##### :grpc_server_failures_per_unary:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum(rate(grpc_server_handled_total{grpc_code=~"Unknown|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~"thanos-store.*", grpc_type="unary"}[5m]))
  /
    sum(rate(grpc_server_started_total{job=~"thanos-store.*", grpc_type="unary"}[5m]))
  )
labels: {}
record: :grpc_server_failures_per_unary:sum_rate
{{< /code >}}
 
##### :grpc_server_failures_per_stream:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum(rate(grpc_server_handled_total{grpc_code=~"Unknown|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~"thanos-store.*", grpc_type="server_stream"}[5m]))
  /
    sum(rate(grpc_server_started_total{job=~"thanos-store.*", grpc_type="server_stream"}[5m]))
  )
labels: {}
record: :grpc_server_failures_per_stream:sum_rate
{{< /code >}}
 
##### :thanos_objstore_bucket_failures_per_operation:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum(rate(thanos_objstore_bucket_operation_failures_total{job=~"thanos-store.*"}[5m]))
  /
    sum(rate(thanos_objstore_bucket_operations_total{job=~"thanos-store.*"}[5m]))
  )
labels: {}
record: :thanos_objstore_bucket_failures_per_operation:sum_rate
{{< /code >}}
 
##### :thanos_objstore_bucket_operation_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99,
    sum(rate(thanos_objstore_bucket_operation_duration_seconds_bucket{job=~"thanos-store.*"}[5m])) by (le)
  )
labels:
  quantile: "0.99"
record: :thanos_objstore_bucket_operation_duration_seconds:histogram_quantile
{{< /code >}}
 
### thanos-bucket-replicate.rules

## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [bucket_replicate](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/bucket_replicate.json)
- [compact](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/compact.json)
- [overview](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/overview.json)
- [query](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/query.json)
- [receive](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/receive.json)
- [rule](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/rule.json)
- [sidecar](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/sidecar.json)
- [store](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/store.json)
