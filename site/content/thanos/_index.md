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

### thanos-compact

##### ThanosCompactMultipleRunning
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanoscompactmultiplerunning

{{< code lang="yaml" >}}
alert: ThanosCompactMultipleRunning
annotations:
  description: No more than one Thanos Compact instance should be running at once.
    There are {{$value}} instances running.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanoscompactmultiplerunning
  summary: Thanos Compact has multiple instances running.
expr: sum by (job) (up{job=~".*thanos-compact.*"}) > 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosCompactHalted
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanoscompacthalted

{{< code lang="yaml" >}}
alert: ThanosCompactHalted
annotations:
  description: Thanos Compact {{$labels.job}} has failed to run and now is halted.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanoscompacthalted
  summary: Thanos Compact has failed to run and is now halted.
expr: thanos_compact_halted{job=~".*thanos-compact.*"} == 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosCompactHighCompactionFailures
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanoscompacthighcompactionfailures

{{< code lang="yaml" >}}
alert: ThanosCompactHighCompactionFailures
annotations:
  description: Thanos Compact {{$labels.job}} is failing to execute {{$value | humanize}}%
    of compactions.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanoscompacthighcompactionfailures
  summary: Thanos Compact is failing to execute compactions.
expr: |
  (
    sum by (job) (rate(thanos_compact_group_compactions_failures_total{job=~".*thanos-compact.*"}[5m]))
  /
    sum by (job) (rate(thanos_compact_group_compactions_total{job=~".*thanos-compact.*"}[5m]))
  * 100 > 5
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosCompactBucketHighOperationFailures
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanoscompactbuckethighoperationfailures

{{< code lang="yaml" >}}
alert: ThanosCompactBucketHighOperationFailures
annotations:
  description: Thanos Compact {{$labels.job}} Bucket is failing to execute {{$value
    | humanize}}% of operations.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanoscompactbuckethighoperationfailures
  summary: Thanos Compact Bucket is having a high number of operation failures.
expr: |
  (
    sum by (job) (rate(thanos_objstore_bucket_operation_failures_total{job=~".*thanos-compact.*"}[5m]))
  /
    sum by (job) (rate(thanos_objstore_bucket_operations_total{job=~".*thanos-compact.*"}[5m]))
  * 100 > 5
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosCompactHasNotRun
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanoscompacthasnotrun

{{< code lang="yaml" >}}
alert: ThanosCompactHasNotRun
annotations:
  description: Thanos Compact {{$labels.job}} has not uploaded anything for 24 hours.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanoscompacthasnotrun
  summary: Thanos Compact has not uploaded anything for last 24 hours.
expr: (time() - max by (job) (max_over_time(thanos_objstore_bucket_last_successful_upload_time{job=~".*thanos-compact.*"}[24h])))
  / 60 / 60 > 24
labels:
  severity: warning
{{< /code >}}
 
### thanos-query

##### ThanosQueryHttpRequestQueryErrorRateHigh
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosqueryhttprequestqueryerrorratehigh

{{< code lang="yaml" >}}
alert: ThanosQueryHttpRequestQueryErrorRateHigh
annotations:
  description: Thanos Query {{$labels.job}} is failing to handle {{$value | humanize}}%
    of "query" requests.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosqueryhttprequestqueryerrorratehigh
  summary: Thanos Query is failing to handle requests.
expr: |
  (
    sum by (job) (rate(http_requests_total{code=~"5..", job=~".*thanos-query.*", handler="query"}[5m]))
  /
    sum by (job) (rate(http_requests_total{job=~".*thanos-query.*", handler="query"}[5m]))
  ) * 100 > 5
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosQueryHttpRequestQueryRangeErrorRateHigh
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosqueryhttprequestqueryrangeerrorratehigh

{{< code lang="yaml" >}}
alert: ThanosQueryHttpRequestQueryRangeErrorRateHigh
annotations:
  description: Thanos Query {{$labels.job}} is failing to handle {{$value | humanize}}%
    of "query_range" requests.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosqueryhttprequestqueryrangeerrorratehigh
  summary: Thanos Query is failing to handle requests.
expr: |
  (
    sum by (job) (rate(http_requests_total{code=~"5..", job=~".*thanos-query.*", handler="query_range"}[5m]))
  /
    sum by (job) (rate(http_requests_total{job=~".*thanos-query.*", handler="query_range"}[5m]))
  ) * 100 > 5
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosQueryGrpcServerErrorRate
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosquerygrpcservererrorrate

{{< code lang="yaml" >}}
alert: ThanosQueryGrpcServerErrorRate
annotations:
  description: Thanos Query {{$labels.job}} is failing to handle {{$value | humanize}}%
    of requests.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosquerygrpcservererrorrate
  summary: Thanos Query is failing to handle requests.
expr: |
  (
    sum by (job) (rate(grpc_server_handled_total{grpc_code=~"Unknown|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~".*thanos-query.*"}[5m]))
  /
    sum by (job) (rate(grpc_server_started_total{job=~".*thanos-query.*"}[5m]))
  * 100 > 5
  )
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosQueryGrpcClientErrorRate
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosquerygrpcclienterrorrate

{{< code lang="yaml" >}}
alert: ThanosQueryGrpcClientErrorRate
annotations:
  description: Thanos Query {{$labels.job}} is failing to send {{$value | humanize}}%
    of requests.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosquerygrpcclienterrorrate
  summary: Thanos Query is failing to send requests.
expr: |
  (
    sum by (job) (rate(grpc_client_handled_total{grpc_code!="OK", job=~".*thanos-query.*"}[5m]))
  /
    sum by (job) (rate(grpc_client_started_total{job=~".*thanos-query.*"}[5m]))
  ) * 100 > 5
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosQueryHighDNSFailures
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosqueryhighdnsfailures

{{< code lang="yaml" >}}
alert: ThanosQueryHighDNSFailures
annotations:
  description: Thanos Query {{$labels.job}} have {{$value | humanize}}% of failing
    DNS queries for store endpoints.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosqueryhighdnsfailures
  summary: Thanos Query is having high number of DNS failures.
expr: |
  (
    sum by (job) (rate(thanos_query_store_apis_dns_failures_total{job=~".*thanos-query.*"}[5m]))
  /
    sum by (job) (rate(thanos_query_store_apis_dns_lookups_total{job=~".*thanos-query.*"}[5m]))
  ) * 100 > 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosQueryInstantLatencyHigh
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosqueryinstantlatencyhigh

{{< code lang="yaml" >}}
alert: ThanosQueryInstantLatencyHigh
annotations:
  description: Thanos Query {{$labels.job}} has a 99th percentile latency of {{$value}}
    seconds for instant queries.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosqueryinstantlatencyhigh
  summary: Thanos Query has high latency for queries.
expr: |
  (
    histogram_quantile(0.99, sum by (job, le) (rate(http_request_duration_seconds_bucket{job=~".*thanos-query.*", handler="query"}[5m]))) > 40
  and
    sum by (job) (rate(http_request_duration_seconds_bucket{job=~".*thanos-query.*", handler="query"}[5m])) > 0
  )
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosQueryRangeLatencyHigh
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosqueryrangelatencyhigh

{{< code lang="yaml" >}}
alert: ThanosQueryRangeLatencyHigh
annotations:
  description: Thanos Query {{$labels.job}} has a 99th percentile latency of {{$value}}
    seconds for range queries.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosqueryrangelatencyhigh
  summary: Thanos Query has high latency for queries.
expr: |
  (
    histogram_quantile(0.99, sum by (job, le) (rate(http_request_duration_seconds_bucket{job=~".*thanos-query.*", handler="query_range"}[5m]))) > 90
  and
    sum by (job) (rate(http_request_duration_seconds_count{job=~".*thanos-query.*", handler="query_range"}[5m])) > 0
  )
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosQueryOverload
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosqueryoverload

{{< code lang="yaml" >}}
alert: ThanosQueryOverload
annotations:
  description: Thanos Query {{$labels.job}} has been overloaded for more than 15 minutes.
    This may be a symptom of excessive simultaneous complex requests, low performance
    of the Prometheus API, or failures within these components. Assess the health
    of the Thanos query instances, the connected Prometheus instances, look for potential
    senders of these requests and then contact support.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosqueryoverload
  summary: Thanos query reaches its maximum capacity serving concurrent requests.
expr: |
  (
    max_over_time(thanos_query_concurrent_gate_queries_max[5m]) - avg_over_time(thanos_query_concurrent_gate_queries_in_flight[5m]) < 1
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
### thanos-receive

##### ThanosReceiveHttpRequestErrorRateHigh
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivehttprequesterrorratehigh

{{< code lang="yaml" >}}
alert: ThanosReceiveHttpRequestErrorRateHigh
annotations:
  description: Thanos Receive {{$labels.job}} is failing to handle {{$value | humanize}}%
    of requests.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivehttprequesterrorratehigh
  summary: Thanos Receive is failing to handle requests.
expr: |
  (
    sum by (job) (rate(http_requests_total{code=~"5..", job=~".*thanos-receive.*", handler="receive"}[5m]))
  /
    sum by (job) (rate(http_requests_total{job=~".*thanos-receive.*", handler="receive"}[5m]))
  ) * 100 > 5
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosReceiveHttpRequestLatencyHigh
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivehttprequestlatencyhigh

{{< code lang="yaml" >}}
alert: ThanosReceiveHttpRequestLatencyHigh
annotations:
  description: Thanos Receive {{$labels.job}} has a 99th percentile latency of {{
    $value }} seconds for requests.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivehttprequestlatencyhigh
  summary: Thanos Receive has high HTTP requests latency.
expr: |
  (
    histogram_quantile(0.99, sum by (job, le) (rate(http_request_duration_seconds_bucket{job=~".*thanos-receive.*", handler="receive"}[5m]))) > 10
  and
    sum by (job) (rate(http_request_duration_seconds_count{job=~".*thanos-receive.*", handler="receive"}[5m])) > 0
  )
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosReceiveHighReplicationFailures
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivehighreplicationfailures

{{< code lang="yaml" >}}
alert: ThanosReceiveHighReplicationFailures
annotations:
  description: Thanos Receive {{$labels.job}} is failing to replicate {{$value | humanize}}%
    of requests.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivehighreplicationfailures
  summary: Thanos Receive is having high number of replication failures.
expr: |
  thanos_receive_replication_factor > 1
    and
  (
    (
      sum by (job) (rate(thanos_receive_replications_total{result="error", job=~".*thanos-receive.*"}[5m]))
    /
      sum by (job) (rate(thanos_receive_replications_total{job=~".*thanos-receive.*"}[5m]))
    )
    >
    (
      max by (job) (floor((thanos_receive_replication_factor{job=~".*thanos-receive.*"}+1) / 2))
    /
      max by (job) (thanos_receive_hashring_nodes{job=~".*thanos-receive.*"})
    )
  ) * 100
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosReceiveHighForwardRequestFailures
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivehighforwardrequestfailures

{{< code lang="yaml" >}}
alert: ThanosReceiveHighForwardRequestFailures
annotations:
  description: Thanos Receive {{$labels.job}} is failing to forward {{$value | humanize}}%
    of requests.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivehighforwardrequestfailures
  summary: Thanos Receive is failing to forward requests.
expr: |
  (
    sum by (job) (rate(thanos_receive_forward_requests_total{result="error", job=~".*thanos-receive.*"}[5m]))
  /
    sum by (job) (rate(thanos_receive_forward_requests_total{job=~".*thanos-receive.*"}[5m]))
  ) * 100 > 20
for: 5m
labels:
  severity: info
{{< /code >}}
 
##### ThanosReceiveHighHashringFileRefreshFailures
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivehighhashringfilerefreshfailures

{{< code lang="yaml" >}}
alert: ThanosReceiveHighHashringFileRefreshFailures
annotations:
  description: Thanos Receive {{$labels.job}} is failing to refresh hashring file,
    {{$value | humanize}} of attempts failed.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivehighhashringfilerefreshfailures
  summary: Thanos Receive is failing to refresh hasring file.
expr: |
  (
    sum by (job) (rate(thanos_receive_hashrings_file_errors_total{job=~".*thanos-receive.*"}[5m]))
  /
    sum by (job) (rate(thanos_receive_hashrings_file_refreshes_total{job=~".*thanos-receive.*"}[5m]))
  > 0
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosReceiveConfigReloadFailure
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceiveconfigreloadfailure

{{< code lang="yaml" >}}
alert: ThanosReceiveConfigReloadFailure
annotations:
  description: Thanos Receive {{$labels.job}} has not been able to reload hashring
    configurations.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceiveconfigreloadfailure
  summary: Thanos Receive has not been able to reload configuration.
expr: avg by (job) (thanos_receive_config_last_reload_successful{job=~".*thanos-receive.*"})
  != 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosReceiveNoUpload
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivenoupload

{{< code lang="yaml" >}}
alert: ThanosReceiveNoUpload
annotations:
  description: Thanos Receive {{$labels.instance}} has not uploaded latest data to
    object storage.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivenoupload
  summary: Thanos Receive has not uploaded latest data to object storage.
expr: |
  (up{job=~".*thanos-receive.*"} - 1)
  + on (job, instance) # filters to only alert on current instance last 3h
  (sum by (job, instance) (increase(thanos_shipper_uploads_total{job=~".*thanos-receive.*"}[3h])) == 0)
for: 3h
labels:
  severity: critical
{{< /code >}}
 
##### ThanosReceiveLimitsConfigReloadFailure
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivelimitsconfigreloadfailure

{{< code lang="yaml" >}}
alert: ThanosReceiveLimitsConfigReloadFailure
annotations:
  description: Thanos Receive {{$labels.job}} has not been able to reload the limits
    configuration.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivelimitsconfigreloadfailure
  summary: Thanos Receive has not been able to reload the limits configuration.
expr: sum by(job) (increase(thanos_receive_limits_config_reload_err_total{job=~".*thanos-receive.*"}[5m]))
  > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosReceiveLimitsHighMetaMonitoringQueriesFailureRate
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivelimitshighmetamonitoringqueriesfailurerate

{{< code lang="yaml" >}}
alert: ThanosReceiveLimitsHighMetaMonitoringQueriesFailureRate
annotations:
  description: Thanos Receive {{$labels.job}} is failing for {{$value | humanize}}%
    of meta monitoring queries.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivelimitshighmetamonitoringqueriesfailurerate
  summary: Thanos Receive has not been able to update the number of head series.
expr: (sum by(job) (increase(thanos_receive_metamonitoring_failed_queries_total{job=~".*thanos-receive.*"}[5m]))
  / 20) * 100 > 20
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosReceiveTenantLimitedByHeadSeries
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivetenantlimitedbyheadseries

{{< code lang="yaml" >}}
alert: ThanosReceiveTenantLimitedByHeadSeries
annotations:
  description: Thanos Receive tenant {{$labels.tenant}} is limited by head series.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceivetenantlimitedbyheadseries
  summary: A Thanos Receive tenant is limited by head series.
expr: sum by(job, tenant) (increase(thanos_receive_head_series_limited_requests_total{job=~".*thanos-receive.*"}[5m]))
  > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
### thanos-sidecar

##### ThanosSidecarBucketOperationsFailed
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanossidecarbucketoperationsfailed

{{< code lang="yaml" >}}
alert: ThanosSidecarBucketOperationsFailed
annotations:
  description: Thanos Sidecar {{$labels.instance}} bucket operations are failing
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanossidecarbucketoperationsfailed
  summary: Thanos Sidecar bucket operations are failing
expr: |
  sum by (job, instance) (rate(thanos_objstore_bucket_operation_failures_total{job=~".*thanos-sidecar.*"}[5m])) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosSidecarNoConnectionToStartedPrometheus
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanossidecarnoconnectiontostartedprometheus

{{< code lang="yaml" >}}
alert: ThanosSidecarNoConnectionToStartedPrometheus
annotations:
  description: Thanos Sidecar {{$labels.instance}} is unhealthy.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanossidecarnoconnectiontostartedprometheus
  summary: Thanos Sidecar cannot access Prometheus, even though Prometheus seems healthy
    and has reloaded WAL.
expr: |
  thanos_sidecar_prometheus_up{job=~".*thanos-sidecar.*"} == 0
  AND on (namespace, pod)
  prometheus_tsdb_data_replay_duration_seconds != 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
### thanos-store

##### ThanosStoreGrpcErrorRate
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosstoregrpcerrorrate

{{< code lang="yaml" >}}
alert: ThanosStoreGrpcErrorRate
annotations:
  description: Thanos Store {{$labels.job}} is failing to handle {{$value | humanize}}%
    of requests.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosstoregrpcerrorrate
  summary: Thanos Store is failing to handle gRPC requests.
expr: |
  (
    sum by (job) (rate(grpc_server_handled_total{grpc_code=~"Unknown|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~".*thanos-store.*"}[5m]))
  /
    sum by (job) (rate(grpc_server_started_total{job=~".*thanos-store.*"}[5m]))
  * 100 > 5
  )
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosStoreSeriesGateLatencyHigh
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosstoreseriesgatelatencyhigh

{{< code lang="yaml" >}}
alert: ThanosStoreSeriesGateLatencyHigh
annotations:
  description: Thanos Store {{$labels.job}} has a 99th percentile latency of {{$value}}
    seconds for store series gate requests.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosstoreseriesgatelatencyhigh
  summary: Thanos Store has high latency for store series gate requests.
expr: |
  (
    histogram_quantile(0.99, sum by (job, le) (rate(thanos_bucket_store_series_gate_duration_seconds_bucket{job=~".*thanos-store.*"}[5m]))) > 2
  and
    sum by (job) (rate(thanos_bucket_store_series_gate_duration_seconds_count{job=~".*thanos-store.*"}[5m])) > 0
  )
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosStoreBucketHighOperationFailures
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosstorebuckethighoperationfailures

{{< code lang="yaml" >}}
alert: ThanosStoreBucketHighOperationFailures
annotations:
  description: Thanos Store {{$labels.job}} Bucket is failing to execute {{$value
    | humanize}}% of operations.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosstorebuckethighoperationfailures
  summary: Thanos Store Bucket is failing to execute operations.
expr: |
  (
    sum by (job) (rate(thanos_objstore_bucket_operation_failures_total{job=~".*thanos-store.*"}[5m]))
  /
    sum by (job) (rate(thanos_objstore_bucket_operations_total{job=~".*thanos-store.*"}[5m]))
  * 100 > 5
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosStoreObjstoreOperationLatencyHigh
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosstoreobjstoreoperationlatencyhigh

{{< code lang="yaml" >}}
alert: ThanosStoreObjstoreOperationLatencyHigh
annotations:
  description: Thanos Store {{$labels.job}} Bucket has a 99th percentile latency of
    {{$value}} seconds for the bucket operations.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosstoreobjstoreoperationlatencyhigh
  summary: Thanos Store is having high latency for bucket operations.
expr: |
  (
    histogram_quantile(0.99, sum by (job, le) (rate(thanos_objstore_bucket_operation_duration_seconds_bucket{job=~".*thanos-store.*"}[5m]))) > 2
  and
    sum by (job) (rate(thanos_objstore_bucket_operation_duration_seconds_count{job=~".*thanos-store.*"}[5m])) > 0
  )
for: 10m
labels:
  severity: warning
{{< /code >}}
 
### thanos-rule

##### ThanosRuleQueueIsDroppingAlerts
Thanos Rule {{$labels.instance}} is failing to queue alerts.
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulequeueisdroppingalerts
Thanos Rule is failing to queue alerts.

{{< code lang="yaml" >}}
alert: ThanosRuleQueueIsDroppingAlerts
annotations:
  description: Thanos Rule {{$labels.instance}} is failing to queue alerts.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulequeueisdroppingalerts
  summary: Thanos Rule is failing to queue alerts.
expr: |
  sum by (job, instance) (rate(thanos_alert_queue_alerts_dropped_total{job=~".*thanos-rule.*"}[5m])) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosRuleSenderIsFailingAlerts
Thanos Rule {{$labels.instance}} is failing to send alerts to alertmanager.
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulesenderisfailingalerts
Thanos Rule is failing to send alerts to alertmanager.

{{< code lang="yaml" >}}
alert: ThanosRuleSenderIsFailingAlerts
annotations:
  description: Thanos Rule {{$labels.instance}} is failing to send alerts to alertmanager.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulesenderisfailingalerts
  summary: Thanos Rule is failing to send alerts to alertmanager.
expr: |
  sum by (job, instance) (rate(thanos_alert_sender_alerts_dropped_total{job=~".*thanos-rule.*"}[5m])) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosRuleHighRuleEvaluationFailures
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulehighruleevaluationfailures

{{< code lang="yaml" >}}
alert: ThanosRuleHighRuleEvaluationFailures
annotations:
  description: Thanos Rule {{$labels.instance}} is failing to evaluate rules.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulehighruleevaluationfailures
  summary: Thanos Rule is failing to evaluate rules.
expr: |
  (
    sum by (job, instance) (rate(prometheus_rule_evaluation_failures_total{job=~".*thanos-rule.*"}[5m]))
  /
    sum by (job, instance) (rate(prometheus_rule_evaluations_total{job=~".*thanos-rule.*"}[5m]))
  * 100 > 5
  )
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosRuleHighRuleEvaluationWarnings
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulehighruleevaluationwarnings

{{< code lang="yaml" >}}
alert: ThanosRuleHighRuleEvaluationWarnings
annotations:
  description: Thanos Rule {{$labels.instance}} has high number of evaluation warnings.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulehighruleevaluationwarnings
  summary: Thanos Rule has high number of evaluation warnings.
expr: |
  sum by (job, instance) (rate(thanos_rule_evaluation_with_warnings_total{job=~".*thanos-rule.*"}[5m])) > 0
for: 15m
labels:
  severity: info
{{< /code >}}
 
##### ThanosRuleRuleEvaluationLatencyHigh
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosruleruleevaluationlatencyhigh

{{< code lang="yaml" >}}
alert: ThanosRuleRuleEvaluationLatencyHigh
annotations:
  description: Thanos Rule {{$labels.instance}} has higher evaluation latency than
    interval for {{$labels.rule_group}}.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosruleruleevaluationlatencyhigh
  summary: Thanos Rule has high rule evaluation latency.
expr: |
  (
    sum by (job, instance, rule_group) (prometheus_rule_group_last_duration_seconds{job=~".*thanos-rule.*"})
  >
    sum by (job, instance, rule_group) (prometheus_rule_group_interval_seconds{job=~".*thanos-rule.*"})
  )
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosRuleGrpcErrorRate
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulegrpcerrorrate

{{< code lang="yaml" >}}
alert: ThanosRuleGrpcErrorRate
annotations:
  description: Thanos Rule {{$labels.job}} is failing to handle {{$value | humanize}}%
    of requests.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulegrpcerrorrate
  summary: Thanos Rule is failing to handle grpc requests.
expr: |
  (
    sum by (job, instance) (rate(grpc_server_handled_total{grpc_code=~"Unknown|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~".*thanos-rule.*"}[5m]))
  /
    sum by (job, instance) (rate(grpc_server_started_total{job=~".*thanos-rule.*"}[5m]))
  * 100 > 5
  )
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosRuleConfigReloadFailure
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosruleconfigreloadfailure

{{< code lang="yaml" >}}
alert: ThanosRuleConfigReloadFailure
annotations:
  description: Thanos Rule {{$labels.job}} has not been able to reload its configuration.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosruleconfigreloadfailure
  summary: Thanos Rule has not been able to reload configuration.
expr: avg by (job, instance) (thanos_rule_config_last_reload_successful{job=~".*thanos-rule.*"})
  != 1
for: 5m
labels:
  severity: info
{{< /code >}}
 
##### ThanosRuleQueryHighDNSFailures
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulequeryhighdnsfailures

{{< code lang="yaml" >}}
alert: ThanosRuleQueryHighDNSFailures
annotations:
  description: Thanos Rule {{$labels.job}} has {{$value | humanize}}% of failing DNS
    queries for query endpoints.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulequeryhighdnsfailures
  summary: Thanos Rule is having high number of DNS failures.
expr: |
  (
    sum by (job, instance) (rate(thanos_rule_query_apis_dns_failures_total{job=~".*thanos-rule.*"}[5m]))
  /
    sum by (job, instance) (rate(thanos_rule_query_apis_dns_lookups_total{job=~".*thanos-rule.*"}[5m]))
  * 100 > 1
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosRuleAlertmanagerHighDNSFailures
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulealertmanagerhighdnsfailures

{{< code lang="yaml" >}}
alert: ThanosRuleAlertmanagerHighDNSFailures
annotations:
  description: Thanos Rule {{$labels.instance}} has {{$value | humanize}}% of failing
    DNS queries for Alertmanager endpoints.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulealertmanagerhighdnsfailures
  summary: Thanos Rule is having high number of DNS failures.
expr: |
  (
    sum by (job, instance) (rate(thanos_rule_alertmanagers_dns_failures_total{job=~".*thanos-rule.*"}[5m]))
  /
    sum by (job, instance) (rate(thanos_rule_alertmanagers_dns_lookups_total{job=~".*thanos-rule.*"}[5m]))
  * 100 > 1
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ThanosRuleNoEvaluationFor10Intervals
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulenoevaluationfor10intervals

{{< code lang="yaml" >}}
alert: ThanosRuleNoEvaluationFor10Intervals
annotations:
  description: Thanos Rule {{$labels.job}} has rule groups that did not evaluate for
    at least 10x of their expected interval.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosrulenoevaluationfor10intervals
  summary: Thanos Rule has rule groups that did not evaluate for 10 intervals.
expr: |
  time() -  max by (job, instance, group) (prometheus_rule_group_last_evaluation_timestamp_seconds{job=~".*thanos-rule.*"})
  >
  10 * max by (job, instance, group) (prometheus_rule_group_interval_seconds{job=~".*thanos-rule.*"})
for: 5m
labels:
  severity: info
{{< /code >}}
 
##### ThanosNoRuleEvaluations
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosnoruleevaluations

{{< code lang="yaml" >}}
alert: ThanosNoRuleEvaluations
annotations:
  description: Thanos Rule {{$labels.instance}} did not perform any rule evaluations
    in the past 10 minutes.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosnoruleevaluations
  summary: Thanos Rule did not perform any rule evaluations.
expr: |
  sum by (job, instance) (rate(prometheus_rule_evaluations_total{job=~".*thanos-rule.*"}[5m])) <= 0
    and
  sum by (job, instance) (thanos_rule_loaded_rules{job=~".*thanos-rule.*"}) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
### thanos-bucket-replicate

##### ThanosBucketReplicateErrorRate
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosbucketreplicateerrorrate

{{< code lang="yaml" >}}
alert: ThanosBucketReplicateErrorRate
annotations:
  description: Thanos Replicate is failing to run, {{$value | humanize}}% of attempts
    failed.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosbucketreplicateerrorrate
  summary: Thanos Replicate is failing to run.
expr: |
  (
    sum by (job) (rate(thanos_replicate_replication_runs_total{result="error", job=~".*thanos-bucket-replicate.*"}[5m]))
  / on (job) group_left
    sum by (job) (rate(thanos_replicate_replication_runs_total{job=~".*thanos-bucket-replicate.*"}[5m]))
  ) * 100 >= 10
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosBucketReplicateRunLatency
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosbucketreplicaterunlatency

{{< code lang="yaml" >}}
alert: ThanosBucketReplicateRunLatency
annotations:
  description: Thanos Replicate {{$labels.job}} has a 99th percentile latency of {{$value}}
    seconds for the replicate operations.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosbucketreplicaterunlatency
  summary: Thanos Replicate has a high latency for replicate operations.
expr: |
  (
    histogram_quantile(0.99, sum by (job) (rate(thanos_replicate_replication_run_duration_seconds_bucket{job=~".*thanos-bucket-replicate.*"}[5m]))) > 20
  and
    sum by (job) (rate(thanos_replicate_replication_run_duration_seconds_bucket{job=~".*thanos-bucket-replicate.*"}[5m])) > 0
  )
for: 5m
labels:
  severity: critical
{{< /code >}}
 
### thanos-component-absent

##### ThanosCompactIsDown
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanoscompactisdown

{{< code lang="yaml" >}}
alert: ThanosCompactIsDown
annotations:
  description: ThanosCompact has disappeared. Prometheus target for the component
    cannot be discovered.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanoscompactisdown
  summary: Thanos component has disappeared.
expr: |
  absent(up{job=~".*thanos-compact.*"} == 1)
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosQueryIsDown
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosqueryisdown

{{< code lang="yaml" >}}
alert: ThanosQueryIsDown
annotations:
  description: ThanosQuery has disappeared. Prometheus target for the component cannot
    be discovered.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosqueryisdown
  summary: Thanos component has disappeared.
expr: |
  absent(up{job=~".*thanos-query.*"} == 1)
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosReceiveIsDown
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceiveisdown

{{< code lang="yaml" >}}
alert: ThanosReceiveIsDown
annotations:
  description: ThanosReceive has disappeared. Prometheus target for the component
    cannot be discovered.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosreceiveisdown
  summary: Thanos component has disappeared.
expr: |
  absent(up{job=~".*thanos-receive.*"} == 1)
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosRuleIsDown
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosruleisdown

{{< code lang="yaml" >}}
alert: ThanosRuleIsDown
annotations:
  description: ThanosRule has disappeared. Prometheus target for the component cannot
    be discovered.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosruleisdown
  summary: Thanos component has disappeared.
expr: |
  absent(up{job=~".*thanos-rule.*"} == 1)
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosSidecarIsDown
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanossidecarisdown

{{< code lang="yaml" >}}
alert: ThanosSidecarIsDown
annotations:
  description: ThanosSidecar has disappeared. Prometheus target for the component
    cannot be discovered.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanossidecarisdown
  summary: Thanos component has disappeared.
expr: |
  absent(up{job=~".*thanos-sidecar.*"} == 1)
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ThanosStoreIsDown
https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosstoreisdown

{{< code lang="yaml" >}}
alert: ThanosStoreIsDown
annotations:
  description: ThanosStore has disappeared. Prometheus target for the component cannot
    be discovered.
  runbook_url: https://github.com/thanos-io/thanos/tree/main/mixin/runbook.md#alert-name-thanosstoreisdown
  summary: Thanos component has disappeared.
expr: |
  absent(up{job=~".*thanos-store.*"} == 1)
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
    sum by (job) (rate(grpc_client_handled_total{grpc_code=~"Unknown|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~".*thanos-query.*", grpc_type="unary"}[5m]))
  /
    sum by (job) (rate(grpc_client_started_total{job=~".*thanos-query.*", grpc_type="unary"}[5m]))
  )
record: :grpc_client_failures_per_unary:sum_rate
{{< /code >}}
 
##### :grpc_client_failures_per_stream:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum by (job) (rate(grpc_client_handled_total{grpc_code=~"Unknown|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~".*thanos-query.*", grpc_type="server_stream"}[5m]))
  /
    sum by (job) (rate(grpc_client_started_total{job=~".*thanos-query.*", grpc_type="server_stream"}[5m]))
  )
record: :grpc_client_failures_per_stream:sum_rate
{{< /code >}}
 
##### :thanos_query_store_apis_dns_failures_per_lookup:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum by (job) (rate(thanos_query_store_apis_dns_failures_total{job=~".*thanos-query.*"}[5m]))
  /
    sum by (job) (rate(thanos_query_store_apis_dns_lookups_total{job=~".*thanos-query.*"}[5m]))
  )
record: :thanos_query_store_apis_dns_failures_per_lookup:sum_rate
{{< /code >}}
 
##### :query_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99,
    sum by (job, le) (rate(http_request_duration_seconds_bucket{job=~".*thanos-query.*", handler="query"}[5m]))
  )
labels:
  quantile: "0.99"
record: :query_duration_seconds:histogram_quantile
{{< /code >}}
 
##### :api_range_query_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99,
    sum by (job, le) (rate(http_request_duration_seconds_bucket{job=~".*thanos-query.*", handler="query_range"}[5m]))
  )
labels:
  quantile: "0.99"
record: :api_range_query_duration_seconds:histogram_quantile
{{< /code >}}
 
### thanos-receive.rules

##### :thanos_query_receive_grpc_server_failures_per_unary:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum by (job) (rate(grpc_server_handled_total{grpc_code=~"Unknown|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~".*thanos-receive.*", grpc_type="unary"}[5m]))
  /
    sum by (job) (rate(grpc_server_started_total{job=~".*thanos-receive.*", grpc_type="unary"}[5m]))
  )
record: :thanos_query_receive_grpc_server_failures_per_unary:sum_rate
{{< /code >}}
 
##### :thanos_query_receive_grpc_server_failures_per_stream:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum by (job) (rate(grpc_server_handled_total{grpc_code=~"Unknown|ResourceExhausted|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~".*thanos-receive.*", grpc_type="server_stream"}[5m]))
  /
    sum by (job) (rate(grpc_server_started_total{job=~".*thanos-receive.*", grpc_type="server_stream"}[5m]))
  )
record: :thanos_query_receive_grpc_server_failures_per_stream:sum_rate
{{< /code >}}
 
##### :http_failure_per_request:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum by (job) (rate(http_requests_total{handler="receive", job=~".*thanos-receive.*", code!~"5.."}[5m]))
  /
    sum by (job) (rate(http_requests_total{handler="receive", job=~".*thanos-receive.*"}[5m]))
  )
record: :http_failure_per_request:sum_rate
{{< /code >}}
 
##### :http_request_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99,
    sum by (job, le) (rate(http_request_duration_seconds_bucket{handler="receive", job=~".*thanos-receive.*"}[5m]))
  )
labels:
  quantile: "0.99"
record: :http_request_duration_seconds:histogram_quantile
{{< /code >}}
 
##### :thanos_receive_replication_failure_per_requests:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum by (job) (rate(thanos_receive_replications_total{result="error", job=~".*thanos-receive.*"}[5m]))
  /
    sum by (job) (rate(thanos_receive_replications_total{job=~".*thanos-receive.*"}[5m]))
  )
record: :thanos_receive_replication_failure_per_requests:sum_rate
{{< /code >}}
 
##### :thanos_receive_forward_failure_per_requests:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum by (job) (rate(thanos_receive_forward_requests_total{result="error", job=~".*thanos-receive.*"}[5m]))
  /
    sum by (job) (rate(thanos_receive_forward_requests_total{job=~".*thanos-receive.*"}[5m]))
  )
record: :thanos_receive_forward_failure_per_requests:sum_rate
{{< /code >}}
 
##### :thanos_receive_hashring_file_failure_per_refresh:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum by (job) (rate(thanos_receive_hashrings_file_errors_total{job=~".*thanos-receive.*"}[5m]))
  /
    sum by (job) (rate(thanos_receive_hashrings_file_refreshes_total{job=~".*thanos-receive.*"}[5m]))
  )
record: :thanos_receive_hashring_file_failure_per_refresh:sum_rate
{{< /code >}}
 
### thanos-store.rules

##### :thanos_query_store_grpc_server_failures_per_unary:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum by (job) (rate(grpc_server_handled_total{grpc_code=~"Unknown|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~".*thanos-store.*", grpc_type="unary"}[5m]))
  /
    sum by (job) (rate(grpc_server_started_total{job=~".*thanos-store.*", grpc_type="unary"}[5m]))
  )
record: :thanos_query_store_grpc_server_failures_per_unary:sum_rate
{{< /code >}}
 
##### :thanos_query_store_grpc_server_failures_per_stream:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum by (job) (rate(grpc_server_handled_total{grpc_code=~"Unknown|Internal|Unavailable|DataLoss|DeadlineExceeded", job=~".*thanos-store.*", grpc_type="server_stream"}[5m]))
  /
    sum by (job) (rate(grpc_server_started_total{job=~".*thanos-store.*", grpc_type="server_stream"}[5m]))
  )
record: :thanos_query_store_grpc_server_failures_per_stream:sum_rate
{{< /code >}}
 
##### :thanos_objstore_bucket_failures_per_operation:sum_rate

{{< code lang="yaml" >}}
expr: |
  (
    sum by (job) (rate(thanos_objstore_bucket_operation_failures_total{job=~".*thanos-store.*"}[5m]))
  /
    sum by (job) (rate(thanos_objstore_bucket_operations_total{job=~".*thanos-store.*"}[5m]))
  )
record: :thanos_objstore_bucket_failures_per_operation:sum_rate
{{< /code >}}
 
##### :thanos_objstore_bucket_operation_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99,
    sum by (job, le) (rate(thanos_objstore_bucket_operation_duration_seconds_bucket{job=~".*thanos-store.*"}[5m]))
  )
labels:
  quantile: "0.99"
record: :thanos_objstore_bucket_operation_duration_seconds:histogram_quantile
{{< /code >}}
 
### thanos-bucket-replicate.rules

## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [bucket-replicate](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/bucket-replicate.json)
- [compact](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/compact.json)
- [overview](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/overview.json)
- [query-frontend](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/query-frontend.json)
- [query](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/query.json)
- [receive](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/receive.json)
- [rule](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/rule.json)
- [sidecar](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/sidecar.json)
- [store](https://github.com/monitoring-mixins/website/blob/master/assets/thanos/dashboards/store.json)
