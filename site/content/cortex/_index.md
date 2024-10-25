---
title: cortex
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/cortexproject/cortex-jsonnet](https://github.com/cortexproject/cortex-jsonnet/tree/master/cortex-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/cortex/alerts.yaml).
{{< /panel >}}

### cortex_alerts

##### CortexIngesterUnhealthy

{{< code lang="yaml" >}}
alert: CortexIngesterUnhealthy
annotations:
  message: |
    Cortex cluster {{ $labels.cluster }}/{{ $labels.namespace }} has {{ printf "%f" $value }} unhealthy ingester(s).
expr: |
  min by (cluster, namespace) (cortex_ring_members{state="Unhealthy", name="ingester"}) > 0
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### CortexRequestErrors

{{< code lang="yaml" >}}
alert: CortexRequestErrors
annotations:
  message: |
    The route {{ $labels.route }} in {{ $labels.cluster }}/{{ $labels.namespace }} is experiencing {{ printf "%.2f" $value }}% errors.
expr: |
  100 * sum by (cluster, namespace, job, route) (rate(cortex_request_duration_seconds_count{status_code=~"5..",route!~"ready"}[1m]))
    /
  sum by (cluster, namespace, job, route) (rate(cortex_request_duration_seconds_count{route!~"ready"}[1m]))
    > 1
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### CortexRequestLatency

{{< code lang="yaml" >}}
alert: CortexRequestLatency
annotations:
  message: |
    {{ $labels.job }} {{ $labels.route }} is experiencing {{ printf "%.2f" $value }}s 99th percentile latency.
expr: |
  cluster_namespace_job_route:cortex_request_duration_seconds:99quantile{route!~"metrics|/frontend.Frontend/Process|ready|/schedulerpb.SchedulerForFrontend/FrontendLoop|/schedulerpb.SchedulerForQuerier/QuerierLoop"}
     >
  2.5
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### CortexQueriesIncorrect

{{< code lang="yaml" >}}
alert: CortexQueriesIncorrect
annotations:
  message: |
    The Cortex cluster {{ $labels.cluster }}/{{ $labels.namespace }} is experiencing {{ printf "%.2f" $value }}% incorrect query results.
expr: |
  100 * sum by (cluster, namespace) (rate(test_exporter_test_case_result_total{result="fail"}[5m]))
    /
  sum by (cluster, namespace) (rate(test_exporter_test_case_result_total[5m])) > 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### CortexInconsistentRuntimeConfig

{{< code lang="yaml" >}}
alert: CortexInconsistentRuntimeConfig
annotations:
  message: |
    An inconsistent runtime config file is used across cluster {{ $labels.cluster }}/{{ $labels.namespace }}.
expr: |
  count(count by(cluster, namespace, job, sha256) (cortex_runtime_config_hash)) without(sha256) > 1
for: 1h
labels:
  severity: critical
{{< /code >}}
 
##### CortexBadRuntimeConfig

{{< code lang="yaml" >}}
alert: CortexBadRuntimeConfig
annotations:
  message: |
    {{ $labels.job }} failed to reload runtime config.
expr: |
  # The metric value is reset to 0 on error while reloading the config at runtime.
  cortex_runtime_config_last_reload_successful == 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CortexFrontendQueriesStuck

{{< code lang="yaml" >}}
alert: CortexFrontendQueriesStuck
annotations:
  message: |
    There are {{ $value }} queued up queries in {{ $labels.cluster }}/{{ $labels.namespace }} query-frontend.
expr: |
  sum by (cluster, namespace) (cortex_query_frontend_queue_length) > 1
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CortexSchedulerQueriesStuck

{{< code lang="yaml" >}}
alert: CortexSchedulerQueriesStuck
annotations:
  message: |
    There are {{ $value }} queued up queries in {{ $labels.cluster }}/{{ $labels.namespace }} query-scheduler.
expr: |
  sum by (cluster, namespace) (cortex_query_scheduler_queue_length) > 1
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CortexMemcachedRequestErrors

{{< code lang="yaml" >}}
alert: CortexMemcachedRequestErrors
annotations:
  message: |
    Memcached {{ $labels.name }} used by Cortex {{ $labels.cluster }}/{{ $labels.namespace }} is experiencing {{ printf "%.2f" $value }}% errors for {{ $labels.operation }} operation.
expr: |
  (
    sum by(cluster, namespace, name, operation) (rate(thanos_memcached_operation_failures_total[1m])) /
    sum by(cluster, namespace, name, operation) (rate(thanos_memcached_operations_total[1m]))
  ) * 100 > 5
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### CortexIngesterRestarts

{{< code lang="yaml" >}}
alert: CortexIngesterRestarts
annotations:
  message: |
    {{ $labels.job }}/{{ $labels.instance }} has restarted {{ printf "%.2f" $value }} times in the last 30 mins.
expr: |
  changes(process_start_time_seconds{job=~".+(cortex|ingester.*)"}[30m]) >= 2
labels:
  severity: warning
{{< /code >}}
 
##### CortexKVStoreFailure

{{< code lang="yaml" >}}
alert: CortexKVStoreFailure
annotations:
  message: |
    Cortex {{ $labels.pod }} in  {{ $labels.cluster }}/{{ $labels.namespace }} is failing to talk to the KV store {{ $labels.kv_name }}.
expr: |
  (
    sum by(cluster, namespace, pod, status_code, kv_name) (rate(cortex_kv_request_duration_seconds_count{status_code!~"2.+"}[1m]))
    /
    sum by(cluster, namespace, pod, status_code, kv_name) (rate(cortex_kv_request_duration_seconds_count[1m]))
  )
  # We want to get alerted only in case there's a constant failure.
  == 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### CortexMemoryMapAreasTooHigh

{{< code lang="yaml" >}}
alert: CortexMemoryMapAreasTooHigh
annotations:
  message: |
    {{ $labels.job }}/{{ $labels.instance }} has a number of mmap-ed areas close to the limit.
expr: |
  process_memory_map_areas{job=~".+(cortex|ingester.*|store-gateway)"} / process_memory_map_areas_limit{job=~".+(cortex|ingester.*|store-gateway)"} > 0.8
for: 5m
labels:
  severity: critical
{{< /code >}}
 
### cortex_ingester_instance_alerts

##### CortexIngesterReachingSeriesLimit

{{< code lang="yaml" >}}
alert: CortexIngesterReachingSeriesLimit
annotations:
  message: |
    Ingester {{ $labels.job }}/{{ $labels.instance }} has reached {{ $value | humanizePercentage }} of its series limit.
expr: |
  (
      (cortex_ingester_memory_series / ignoring(limit) cortex_ingester_instance_limits{limit="max_series"})
      and ignoring (limit)
      (cortex_ingester_instance_limits{limit="max_series"} > 0)
  ) > 0.8
for: 3h
labels:
  severity: warning
{{< /code >}}
 
##### CortexIngesterReachingSeriesLimit

{{< code lang="yaml" >}}
alert: CortexIngesterReachingSeriesLimit
annotations:
  message: |
    Ingester {{ $labels.job }}/{{ $labels.instance }} has reached {{ $value | humanizePercentage }} of its series limit.
expr: |
  (
      (cortex_ingester_memory_series / ignoring(limit) cortex_ingester_instance_limits{limit="max_series"})
      and ignoring (limit)
      (cortex_ingester_instance_limits{limit="max_series"} > 0)
  ) > 0.9
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CortexIngesterReachingTenantsLimit

{{< code lang="yaml" >}}
alert: CortexIngesterReachingTenantsLimit
annotations:
  message: |
    Ingester {{ $labels.job }}/{{ $labels.instance }} has reached {{ $value | humanizePercentage }} of its tenant limit.
expr: |
  (
      (cortex_ingester_memory_users / ignoring(limit) cortex_ingester_instance_limits{limit="max_tenants"})
      and ignoring (limit)
      (cortex_ingester_instance_limits{limit="max_tenants"} > 0)
  ) > 0.7
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### CortexIngesterReachingTenantsLimit

{{< code lang="yaml" >}}
alert: CortexIngesterReachingTenantsLimit
annotations:
  message: |
    Ingester {{ $labels.job }}/{{ $labels.instance }} has reached {{ $value | humanizePercentage }} of its tenant limit.
expr: |
  (
      (cortex_ingester_memory_users / ignoring(limit) cortex_ingester_instance_limits{limit="max_tenants"})
      and ignoring (limit)
      (cortex_ingester_instance_limits{limit="max_tenants"} > 0)
  ) > 0.8
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CortexDistributorReachingInflightPushRequestLimit

{{< code lang="yaml" >}}
alert: CortexDistributorReachingInflightPushRequestLimit
annotations:
  message: |
    Distributor {{ $labels.job }}/{{ $labels.instance }} has reached {{ $value | humanizePercentage }} of its inflight push request limit.
expr: |
  (
      (cortex_distributor_inflight_push_requests / ignoring(limit) cortex_distributor_instance_limits{limit="max_inflight_push_requests"})
      and ignoring (limit)
      (cortex_distributor_instance_limits{limit="max_inflight_push_requests"} > 0)
  ) > 0.8
for: 5m
labels:
  severity: critical
{{< /code >}}
 
### cortex-rollout-alerts

##### CortexRolloutStuck

{{< code lang="yaml" >}}
alert: CortexRolloutStuck
annotations:
  message: |
    The {{ $labels.statefulset }} rollout is stuck in {{ $labels.cluster }}/{{ $labels.namespace }}.
expr: |
  (
    max without (revision) (
      kube_statefulset_status_current_revision
        unless
      kube_statefulset_status_update_revision
    )
      *
    (
      kube_statefulset_replicas
        !=
      kube_statefulset_status_replicas_updated
    )
  )  and (
    changes(kube_statefulset_status_replicas_updated[15m])
      ==
    0
  )
  * on(cluster, namespace) group_left max by(cluster, namespace) (cortex_build_info)
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### CortexRolloutStuck

{{< code lang="yaml" >}}
alert: CortexRolloutStuck
annotations:
  message: |
    The {{ $labels.deployment }} rollout is stuck in {{ $labels.cluster }}/{{ $labels.namespace }}.
expr: |
  (
    kube_deployment_spec_replicas
      !=
    kube_deployment_status_replicas_updated
  ) and (
    changes(kube_deployment_status_replicas_updated[15m])
      ==
    0
  )
  * on(cluster, namespace) group_left max by(cluster, namespace) (cortex_build_info)
for: 15m
labels:
  severity: warning
{{< /code >}}
 
### cortex-provisioning

##### CortexProvisioningTooManyActiveSeries

{{< code lang="yaml" >}}
alert: CortexProvisioningTooManyActiveSeries
annotations:
  message: |
    The number of in-memory series per ingester in {{ $labels.cluster }}/{{ $labels.namespace }} is too high.
expr: |
  avg by (cluster, namespace) (cortex_ingester_memory_series) > 3.2e6
for: 2h
labels:
  severity: warning
{{< /code >}}
 
##### CortexProvisioningTooManyWrites

{{< code lang="yaml" >}}
alert: CortexProvisioningTooManyWrites
annotations:
  message: |
    Ingesters in {{ $labels.cluster }}/{{ $labels.namespace }} ingest too many samples per second.
expr: |
  avg by (cluster, namespace) (rate(cortex_ingester_ingested_samples_total[1m])) > 160e3
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### CortexAllocatingTooMuchMemory

{{< code lang="yaml" >}}
alert: CortexAllocatingTooMuchMemory
annotations:
  message: |
    Ingester {{ $labels.pod }} in {{ $labels.cluster }}/{{ $labels.namespace }} is using too much memory.
expr: |
  (
    container_memory_working_set_bytes{container="ingester"}
      /
    container_spec_memory_limit_bytes{container="ingester"}
  ) > 0.65
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### CortexAllocatingTooMuchMemory

{{< code lang="yaml" >}}
alert: CortexAllocatingTooMuchMemory
annotations:
  message: |
    Ingester {{ $labels.pod }} in {{ $labels.cluster }}/{{ $labels.namespace }} is using too much memory.
expr: |
  (
    container_memory_working_set_bytes{container="ingester"}
      /
    container_spec_memory_limit_bytes{container="ingester"}
  ) > 0.8
for: 15m
labels:
  severity: critical
{{< /code >}}
 
### ruler_alerts

##### CortexRulerTooManyFailedPushes

{{< code lang="yaml" >}}
alert: CortexRulerTooManyFailedPushes
annotations:
  message: |
    Cortex Ruler {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} is experiencing {{ printf "%.2f" $value }}% write (push) errors.
expr: |
  100 * (
  sum by (cluster, namespace, instance) (rate(cortex_ruler_write_requests_failed_total[1m]))
    /
  sum by (cluster, namespace, instance) (rate(cortex_ruler_write_requests_total[1m]))
  ) > 1
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CortexRulerTooManyFailedQueries

{{< code lang="yaml" >}}
alert: CortexRulerTooManyFailedQueries
annotations:
  message: |
    Cortex Ruler {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} is experiencing {{ printf "%.2f" $value }}% errors while evaluating rules.
expr: |
  100 * (
  sum by (cluster, namespace, instance) (rate(cortex_ruler_queries_failed_total[1m]))
    /
  sum by (cluster, namespace, instance) (rate(cortex_ruler_queries_total[1m]))
  ) > 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### CortexRulerMissedEvaluations

{{< code lang="yaml" >}}
alert: CortexRulerMissedEvaluations
annotations:
  message: |
    Cortex Ruler {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} is experiencing {{ printf "%.2f" $value }}% missed iterations for the rule group {{ $labels.rule_group }}.
expr: |
  sum by (cluster, namespace, instance, rule_group) (rate(cortex_prometheus_rule_group_iterations_missed_total[1m]))
    /
  sum by (cluster, namespace, instance, rule_group) (rate(cortex_prometheus_rule_group_iterations_total[1m]))
    > 0.01
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### CortexRulerFailedRingCheck

{{< code lang="yaml" >}}
alert: CortexRulerFailedRingCheck
annotations:
  message: |
    Cortex Rulers in {{ $labels.cluster }}/{{ $labels.namespace }} are experiencing errors when checking the ring for rule group ownership.
expr: |
  sum by (cluster, namespace, job) (rate(cortex_ruler_ring_check_errors_total[1m]))
     > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
### gossip_alerts

##### CortexGossipMembersMismatch

{{< code lang="yaml" >}}
alert: CortexGossipMembersMismatch
annotations:
  message: |
    Cortex instance {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} sees incorrect number of gossip members.
expr: |
  memberlist_client_cluster_members_count
    != on (cluster, namespace) group_left
  sum by (cluster, namespace) (up{job=~".+/(compactor|distributor|ingester.*|querier.*|ruler|store-gateway|cortex)"})
for: 5m
labels:
  severity: warning
{{< /code >}}
 
### etcd_alerts

##### EtcdAllocatingTooMuchMemory

{{< code lang="yaml" >}}
alert: EtcdAllocatingTooMuchMemory
annotations:
  message: |
    Too much memory being used by {{ $labels.namespace }}/{{ $labels.pod }} - bump memory limit.
expr: |
  (
    container_memory_working_set_bytes{container="etcd"}
      /
    container_spec_memory_limit_bytes{container="etcd"}
  ) > 0.65
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### EtcdAllocatingTooMuchMemory

{{< code lang="yaml" >}}
alert: EtcdAllocatingTooMuchMemory
annotations:
  message: |
    Too much memory being used by {{ $labels.namespace }}/{{ $labels.pod }} - bump memory limit.
expr: |
  (
    container_memory_working_set_bytes{container="etcd"}
      /
    container_spec_memory_limit_bytes{container="etcd"}
  ) > 0.8
for: 15m
labels:
  severity: critical
{{< /code >}}
 
### alertmanager_alerts

##### CortexAlertmanagerSyncConfigsFailing

{{< code lang="yaml" >}}
alert: CortexAlertmanagerSyncConfigsFailing
annotations:
  message: |
    Cortex Alertmanager {{ $labels.job }}/{{ $labels.instance }} is failing to read tenant configurations from storage.
expr: |
  rate(cortex_alertmanager_sync_configs_failed_total[5m]) > 0
for: 30m
labels:
  severity: critical
{{< /code >}}
 
##### CortexAlertmanagerRingCheckFailing

{{< code lang="yaml" >}}
alert: CortexAlertmanagerRingCheckFailing
annotations:
  message: |
    Cortex Alertmanager {{ $labels.job }}/{{ $labels.instance }} is unable to check tenants ownership via the ring.
expr: |
  rate(cortex_alertmanager_ring_check_errors_total[2m]) > 0
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### CortexAlertmanagerPartialStateMergeFailing

{{< code lang="yaml" >}}
alert: CortexAlertmanagerPartialStateMergeFailing
annotations:
  message: |
    Cortex Alertmanager {{ $labels.job }}/{{ $labels.instance }} is failing to merge partial state changes received from a replica.
expr: |
  rate(cortex_alertmanager_partial_state_merges_failed_total[2m]) > 0
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### CortexAlertmanagerReplicationFailing

{{< code lang="yaml" >}}
alert: CortexAlertmanagerReplicationFailing
annotations:
  message: |
    Cortex Alertmanager {{ $labels.job }}/{{ $labels.instance }} is failing to replicating partial state to its replicas.
expr: |
  rate(cortex_alertmanager_state_replication_failed_total[2m]) > 0
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### CortexAlertmanagerPersistStateFailing

{{< code lang="yaml" >}}
alert: CortexAlertmanagerPersistStateFailing
annotations:
  message: |
    Cortex Alertmanager {{ $labels.job }}/{{ $labels.instance }} is unable to persist full state snaphots to remote storage.
expr: |
  rate(cortex_alertmanager_state_persist_failed_total[15m]) > 0
for: 1h
labels:
  severity: critical
{{< /code >}}
 
##### CortexAlertmanagerInitialSyncFailed

{{< code lang="yaml" >}}
alert: CortexAlertmanagerInitialSyncFailed
annotations:
  message: |
    Cortex Alertmanager {{ $labels.job }}/{{ $labels.instance }} was unable to obtain some initial state when starting up.
expr: |
  increase(cortex_alertmanager_state_initial_sync_completed_total{outcome="failed"}[1m]) > 0
labels:
  severity: critical
{{< /code >}}
 
### cortex_blocks_alerts

##### CortexIngesterHasNotShippedBlocks

{{< code lang="yaml" >}}
alert: CortexIngesterHasNotShippedBlocks
annotations:
  message: |
    Cortex Ingester {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} has not shipped any block in the last 4 hours.
expr: |
  (min by(cluster, namespace, instance) (time() - thanos_objstore_bucket_last_successful_upload_time{job=~".+/ingester.*"}) > 60 * 60 * 4)
  and
  (max by(cluster, namespace, instance) (thanos_objstore_bucket_last_successful_upload_time{job=~".+/ingester.*"}) > 0)
  and
  # Only if the ingester has ingested samples over the last 4h.
  (max by(cluster, namespace, instance) (rate(cortex_ingester_ingested_samples_total[4h])) > 0)
  and
  # Only if the ingester was ingesting samples 4h ago. This protects from the case the ingester instance
  # had ingested samples in the past, then no traffic was received for a long period and then it starts
  # receiving samples again. Without this check, the alert would fire as soon as it gets back receiving
  # samples, while the a block shipping is expected within the next 4h.
  (max by(cluster, namespace, instance) (rate(cortex_ingester_ingested_samples_total[1h] offset 4h)) > 0)
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### CortexIngesterHasNotShippedBlocksSinceStart

{{< code lang="yaml" >}}
alert: CortexIngesterHasNotShippedBlocksSinceStart
annotations:
  message: |
    Cortex Ingester {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} has not shipped any block in the last 4 hours.
expr: |
  (max by(cluster, namespace, instance) (thanos_objstore_bucket_last_successful_upload_time{job=~".+/ingester.*"}) == 0)
  and
  (max by(cluster, namespace, instance) (rate(cortex_ingester_ingested_samples_total[4h])) > 0)
for: 4h
labels:
  severity: critical
{{< /code >}}
 
##### CortexIngesterHasUnshippedBlocks

{{< code lang="yaml" >}}
alert: CortexIngesterHasUnshippedBlocks
annotations:
  message: |
    Cortex Ingester {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} has compacted a block {{ $value | humanizeDuration }} ago but it hasn't been successfully uploaded to the storage yet.
expr: |
  (time() - cortex_ingester_oldest_unshipped_block_timestamp_seconds > 3600)
  and
  (cortex_ingester_oldest_unshipped_block_timestamp_seconds > 0)
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### CortexIngesterTSDBHeadCompactionFailed

{{< code lang="yaml" >}}
alert: CortexIngesterTSDBHeadCompactionFailed
annotations:
  message: |
    Cortex Ingester {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} is failing to compact TSDB head.
expr: |
  rate(cortex_ingester_tsdb_compactions_failed_total[5m]) > 0
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### CortexIngesterTSDBHeadTruncationFailed

{{< code lang="yaml" >}}
alert: CortexIngesterTSDBHeadTruncationFailed
annotations:
  message: |
    Cortex Ingester {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} is failing to truncate TSDB head.
expr: |
  rate(cortex_ingester_tsdb_head_truncations_failed_total[5m]) > 0
labels:
  severity: critical
{{< /code >}}
 
##### CortexIngesterTSDBCheckpointCreationFailed

{{< code lang="yaml" >}}
alert: CortexIngesterTSDBCheckpointCreationFailed
annotations:
  message: |
    Cortex Ingester {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} is failing to create TSDB checkpoint.
expr: |
  rate(cortex_ingester_tsdb_checkpoint_creations_failed_total[5m]) > 0
labels:
  severity: critical
{{< /code >}}
 
##### CortexIngesterTSDBCheckpointDeletionFailed

{{< code lang="yaml" >}}
alert: CortexIngesterTSDBCheckpointDeletionFailed
annotations:
  message: |
    Cortex Ingester {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} is failing to delete TSDB checkpoint.
expr: |
  rate(cortex_ingester_tsdb_checkpoint_deletions_failed_total[5m]) > 0
labels:
  severity: critical
{{< /code >}}
 
##### CortexIngesterTSDBWALTruncationFailed

{{< code lang="yaml" >}}
alert: CortexIngesterTSDBWALTruncationFailed
annotations:
  message: |
    Cortex Ingester {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} is failing to truncate TSDB WAL.
expr: |
  rate(cortex_ingester_tsdb_wal_truncations_failed_total[5m]) > 0
labels:
  severity: warning
{{< /code >}}
 
##### CortexIngesterTSDBWALCorrupted

{{< code lang="yaml" >}}
alert: CortexIngesterTSDBWALCorrupted
annotations:
  message: |
    Cortex Ingester {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} got a corrupted TSDB WAL.
expr: |
  rate(cortex_ingester_tsdb_wal_corruptions_total[5m]) > 0
labels:
  severity: critical
{{< /code >}}
 
##### CortexIngesterTSDBWALWritesFailed

{{< code lang="yaml" >}}
alert: CortexIngesterTSDBWALWritesFailed
annotations:
  message: |
    Cortex Ingester {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} is failing to write to TSDB WAL.
expr: |
  rate(cortex_ingester_tsdb_wal_writes_failed_total[1m]) > 0
for: 3m
labels:
  severity: critical
{{< /code >}}
 
##### CortexQuerierHasNotScanTheBucket

{{< code lang="yaml" >}}
alert: CortexQuerierHasNotScanTheBucket
annotations:
  message: |
    Cortex Querier {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} has not successfully scanned the bucket since {{ $value | humanizeDuration }}.
expr: |
  (time() - cortex_querier_blocks_last_successful_scan_timestamp_seconds > 60 * 30)
  and
  cortex_querier_blocks_last_successful_scan_timestamp_seconds > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CortexQuerierHighRefetchRate

{{< code lang="yaml" >}}
alert: CortexQuerierHighRefetchRate
annotations:
  message: |
    Cortex Queries in {{ $labels.cluster }}/{{ $labels.namespace }} are refetching series from different store-gateways (because of missing blocks) for the {{ printf "%.0f" $value }}% of queries.
expr: |
  100 * (
    (
      sum by(cluster, namespace) (rate(cortex_querier_storegateway_refetches_per_query_count[5m]))
      -
      sum by(cluster, namespace) (rate(cortex_querier_storegateway_refetches_per_query_bucket{le="0.0"}[5m]))
    )
    /
    sum by(cluster, namespace) (rate(cortex_querier_storegateway_refetches_per_query_count[5m]))
  )
  > 1
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### CortexStoreGatewayHasNotSyncTheBucket

{{< code lang="yaml" >}}
alert: CortexStoreGatewayHasNotSyncTheBucket
annotations:
  message: |
    Cortex Store Gateway {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} has not successfully synched the bucket since {{ $value | humanizeDuration }}.
expr: |
  (time() - cortex_bucket_stores_blocks_last_successful_sync_timestamp_seconds{component="store-gateway"} > 60 * 30)
  and
  cortex_bucket_stores_blocks_last_successful_sync_timestamp_seconds{component="store-gateway"} > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CortexBucketIndexNotUpdated

{{< code lang="yaml" >}}
alert: CortexBucketIndexNotUpdated
annotations:
  message: |
    Cortex bucket index for tenant {{ $labels.user }} in {{ $labels.cluster }}/{{ $labels.namespace }} has not been updated since {{ $value | humanizeDuration }}.
expr: |
  min by(cluster, namespace, user) (time() - cortex_bucket_index_last_successful_update_timestamp_seconds) > 7200
labels:
  severity: critical
{{< /code >}}
 
##### CortexTenantHasPartialBlocks

{{< code lang="yaml" >}}
alert: CortexTenantHasPartialBlocks
annotations:
  message: |
    Cortex tenant {{ $labels.user }} in {{ $labels.cluster }}/{{ $labels.namespace }} has {{ $value }} partial blocks.
expr: |
  max by(cluster, namespace, user) (cortex_bucket_blocks_partials_count) > 0
for: 6h
labels:
  severity: warning
{{< /code >}}
 
### cortex_compactor_alerts

##### CortexCompactorHasNotSuccessfullyCleanedUpBlocks

{{< code lang="yaml" >}}
alert: CortexCompactorHasNotSuccessfullyCleanedUpBlocks
annotations:
  message: |
    Cortex Compactor {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} has not successfully cleaned up blocks in the last 6 hours.
expr: |
  (time() - cortex_compactor_block_cleanup_last_successful_run_timestamp_seconds > 60 * 60 * 6)
for: 1h
labels:
  severity: critical
{{< /code >}}
 
##### CortexCompactorHasNotSuccessfullyRunCompaction

{{< code lang="yaml" >}}
alert: CortexCompactorHasNotSuccessfullyRunCompaction
annotations:
  message: |
    Cortex Compactor {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} has not run compaction in the last 24 hours.
expr: |
  (time() - cortex_compactor_last_successful_run_timestamp_seconds > 60 * 60 * 24)
  and
  (cortex_compactor_last_successful_run_timestamp_seconds > 0)
for: 1h
labels:
  severity: critical
{{< /code >}}
 
##### CortexCompactorHasNotSuccessfullyRunCompaction

{{< code lang="yaml" >}}
alert: CortexCompactorHasNotSuccessfullyRunCompaction
annotations:
  message: |
    Cortex Compactor {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} has not run compaction in the last 24 hours.
expr: |
  cortex_compactor_last_successful_run_timestamp_seconds == 0
for: 24h
labels:
  severity: critical
{{< /code >}}
 
##### CortexCompactorHasNotSuccessfullyRunCompaction

{{< code lang="yaml" >}}
alert: CortexCompactorHasNotSuccessfullyRunCompaction
annotations:
  message: |
    Cortex Compactor {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} failed to run 2 consecutive compactions.
expr: |
  increase(cortex_compactor_runs_failed_total[2h]) >= 2
labels:
  severity: critical
{{< /code >}}
 
##### CortexCompactorHasNotUploadedBlocks

{{< code lang="yaml" >}}
alert: CortexCompactorHasNotUploadedBlocks
annotations:
  message: |
    Cortex Compactor {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} has not uploaded any block in the last 24 hours.
expr: |
  (time() - thanos_objstore_bucket_last_successful_upload_time{job=~".+/compactor.*"} > 60 * 60 * 24)
  and
  (thanos_objstore_bucket_last_successful_upload_time{job=~".+/compactor.*"} > 0)
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### CortexCompactorHasNotUploadedBlocks

{{< code lang="yaml" >}}
alert: CortexCompactorHasNotUploadedBlocks
annotations:
  message: |
    Cortex Compactor {{ $labels.instance }} in {{ $labels.cluster }}/{{ $labels.namespace }} has not uploaded any block in the last 24 hours.
expr: |
  thanos_objstore_bucket_last_successful_upload_time{job=~".+/compactor.*"} == 0
for: 24h
labels:
  severity: critical
{{< /code >}}
 
## Recording rules

{{< panel style="warning" >}}
Complete list of pregenerated recording rules is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/cortex/rules.yaml).
{{< /panel >}}

### cortex_api_1

##### cluster_job:cortex_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_request_duration_seconds_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job:cortex_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_request_duration_seconds_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job:cortex_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_request_duration_seconds_sum[1m])) by (cluster, job) / sum(rate(cortex_request_duration_seconds_count[1m]))
  by (cluster, job)
record: cluster_job:cortex_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_job:cortex_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_request_duration_seconds_bucket[1m])) by (le, cluster, job)
record: cluster_job:cortex_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_request_duration_seconds_sum[1m])) by (cluster, job)
record: cluster_job:cortex_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_request_duration_seconds_count[1m])) by (cluster, job)
record: cluster_job:cortex_request_duration_seconds_count:sum_rate
{{< /code >}}
 
### cortex_api_2

##### cluster_job_route:cortex_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, route))
record: cluster_job_route:cortex_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job_route:cortex_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, route))
record: cluster_job_route:cortex_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job_route:cortex_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_request_duration_seconds_sum[1m])) by (cluster, job, route)
  / sum(rate(cortex_request_duration_seconds_count[1m])) by (cluster, job, route)
record: cluster_job_route:cortex_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_job_route:cortex_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_request_duration_seconds_bucket[1m])) by (le, cluster, job,
  route)
record: cluster_job_route:cortex_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job_route:cortex_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_request_duration_seconds_sum[1m])) by (cluster, job, route)
record: cluster_job_route:cortex_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job_route:cortex_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_request_duration_seconds_count[1m])) by (cluster, job, route)
record: cluster_job_route:cortex_request_duration_seconds_count:sum_rate
{{< /code >}}
 
### cortex_api_3

##### cluster_namespace_job_route:cortex_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_request_duration_seconds_bucket[1m]))
  by (le, cluster, namespace, job, route))
record: cluster_namespace_job_route:cortex_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_namespace_job_route:cortex_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_request_duration_seconds_bucket[1m]))
  by (le, cluster, namespace, job, route))
record: cluster_namespace_job_route:cortex_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_namespace_job_route:cortex_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_request_duration_seconds_sum[1m])) by (cluster, namespace, job,
  route) / sum(rate(cortex_request_duration_seconds_count[1m])) by (cluster, namespace,
  job, route)
record: cluster_namespace_job_route:cortex_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_namespace_job_route:cortex_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_request_duration_seconds_bucket[1m])) by (le, cluster, namespace,
  job, route)
record: cluster_namespace_job_route:cortex_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_namespace_job_route:cortex_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_request_duration_seconds_sum[1m])) by (cluster, namespace, job,
  route)
record: cluster_namespace_job_route:cortex_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_namespace_job_route:cortex_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_request_duration_seconds_count[1m])) by (cluster, namespace,
  job, route)
record: cluster_namespace_job_route:cortex_request_duration_seconds_count:sum_rate
{{< /code >}}
 
### cortex_querier_api

##### cluster_job:cortex_querier_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_querier_request_duration_seconds_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_querier_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job:cortex_querier_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_querier_request_duration_seconds_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_querier_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job:cortex_querier_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_querier_request_duration_seconds_sum[1m])) by (cluster, job)
  / sum(rate(cortex_querier_request_duration_seconds_count[1m])) by (cluster, job)
record: cluster_job:cortex_querier_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_job:cortex_querier_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_querier_request_duration_seconds_bucket[1m])) by (le, cluster,
  job)
record: cluster_job:cortex_querier_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_querier_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_querier_request_duration_seconds_sum[1m])) by (cluster, job)
record: cluster_job:cortex_querier_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_querier_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_querier_request_duration_seconds_count[1m])) by (cluster, job)
record: cluster_job:cortex_querier_request_duration_seconds_count:sum_rate
{{< /code >}}
 
##### cluster_job_route:cortex_querier_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_querier_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, route))
record: cluster_job_route:cortex_querier_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job_route:cortex_querier_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_querier_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, route))
record: cluster_job_route:cortex_querier_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job_route:cortex_querier_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_querier_request_duration_seconds_sum[1m])) by (cluster, job,
  route) / sum(rate(cortex_querier_request_duration_seconds_count[1m])) by (cluster,
  job, route)
record: cluster_job_route:cortex_querier_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_job_route:cortex_querier_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_querier_request_duration_seconds_bucket[1m])) by (le, cluster,
  job, route)
record: cluster_job_route:cortex_querier_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job_route:cortex_querier_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_querier_request_duration_seconds_sum[1m])) by (cluster, job,
  route)
record: cluster_job_route:cortex_querier_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job_route:cortex_querier_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_querier_request_duration_seconds_count[1m])) by (cluster, job,
  route)
record: cluster_job_route:cortex_querier_request_duration_seconds_count:sum_rate
{{< /code >}}
 
##### cluster_namespace_job_route:cortex_querier_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_querier_request_duration_seconds_bucket[1m]))
  by (le, cluster, namespace, job, route))
record: cluster_namespace_job_route:cortex_querier_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_namespace_job_route:cortex_querier_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_querier_request_duration_seconds_bucket[1m]))
  by (le, cluster, namespace, job, route))
record: cluster_namespace_job_route:cortex_querier_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_namespace_job_route:cortex_querier_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_querier_request_duration_seconds_sum[1m])) by (cluster, namespace,
  job, route) / sum(rate(cortex_querier_request_duration_seconds_count[1m])) by (cluster,
  namespace, job, route)
record: cluster_namespace_job_route:cortex_querier_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_namespace_job_route:cortex_querier_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_querier_request_duration_seconds_bucket[1m])) by (le, cluster,
  namespace, job, route)
record: cluster_namespace_job_route:cortex_querier_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_namespace_job_route:cortex_querier_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_querier_request_duration_seconds_sum[1m])) by (cluster, namespace,
  job, route)
record: cluster_namespace_job_route:cortex_querier_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_namespace_job_route:cortex_querier_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_querier_request_duration_seconds_count[1m])) by (cluster, namespace,
  job, route)
record: cluster_namespace_job_route:cortex_querier_request_duration_seconds_count:sum_rate
{{< /code >}}
 
### cortex_cache

##### cluster_job_method:cortex_memcache_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_memcache_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, method))
record: cluster_job_method:cortex_memcache_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job_method:cortex_memcache_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_memcache_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, method))
record: cluster_job_method:cortex_memcache_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job_method:cortex_memcache_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_memcache_request_duration_seconds_sum[1m])) by (cluster, job,
  method) / sum(rate(cortex_memcache_request_duration_seconds_count[1m])) by (cluster,
  job, method)
record: cluster_job_method:cortex_memcache_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_job_method:cortex_memcache_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_memcache_request_duration_seconds_bucket[1m])) by (le, cluster,
  job, method)
record: cluster_job_method:cortex_memcache_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job_method:cortex_memcache_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_memcache_request_duration_seconds_sum[1m])) by (cluster, job,
  method)
record: cluster_job_method:cortex_memcache_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job_method:cortex_memcache_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_memcache_request_duration_seconds_count[1m])) by (cluster, job,
  method)
record: cluster_job_method:cortex_memcache_request_duration_seconds_count:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_cache_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_cache_request_duration_seconds_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_cache_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job:cortex_cache_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_cache_request_duration_seconds_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_cache_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job:cortex_cache_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_cache_request_duration_seconds_sum[1m])) by (cluster, job) /
  sum(rate(cortex_cache_request_duration_seconds_count[1m])) by (cluster, job)
record: cluster_job:cortex_cache_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_job:cortex_cache_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_cache_request_duration_seconds_bucket[1m])) by (le, cluster,
  job)
record: cluster_job:cortex_cache_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_cache_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_cache_request_duration_seconds_sum[1m])) by (cluster, job)
record: cluster_job:cortex_cache_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_cache_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_cache_request_duration_seconds_count[1m])) by (cluster, job)
record: cluster_job:cortex_cache_request_duration_seconds_count:sum_rate
{{< /code >}}
 
##### cluster_job_method:cortex_cache_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_cache_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, method))
record: cluster_job_method:cortex_cache_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job_method:cortex_cache_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_cache_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, method))
record: cluster_job_method:cortex_cache_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job_method:cortex_cache_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_cache_request_duration_seconds_sum[1m])) by (cluster, job, method)
  / sum(rate(cortex_cache_request_duration_seconds_count[1m])) by (cluster, job, method)
record: cluster_job_method:cortex_cache_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_job_method:cortex_cache_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_cache_request_duration_seconds_bucket[1m])) by (le, cluster,
  job, method)
record: cluster_job_method:cortex_cache_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job_method:cortex_cache_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_cache_request_duration_seconds_sum[1m])) by (cluster, job, method)
record: cluster_job_method:cortex_cache_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job_method:cortex_cache_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_cache_request_duration_seconds_count[1m])) by (cluster, job,
  method)
record: cluster_job_method:cortex_cache_request_duration_seconds_count:sum_rate
{{< /code >}}
 
### cortex_storage

##### cluster_job_operation:cortex_bigtable_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_bigtable_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, operation))
record: cluster_job_operation:cortex_bigtable_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job_operation:cortex_bigtable_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_bigtable_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, operation))
record: cluster_job_operation:cortex_bigtable_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job_operation:cortex_bigtable_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_bigtable_request_duration_seconds_sum[1m])) by (cluster, job,
  operation) / sum(rate(cortex_bigtable_request_duration_seconds_count[1m])) by (cluster,
  job, operation)
record: cluster_job_operation:cortex_bigtable_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_job_operation:cortex_bigtable_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_bigtable_request_duration_seconds_bucket[1m])) by (le, cluster,
  job, operation)
record: cluster_job_operation:cortex_bigtable_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job_operation:cortex_bigtable_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_bigtable_request_duration_seconds_sum[1m])) by (cluster, job,
  operation)
record: cluster_job_operation:cortex_bigtable_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job_operation:cortex_bigtable_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_bigtable_request_duration_seconds_count[1m])) by (cluster, job,
  operation)
record: cluster_job_operation:cortex_bigtable_request_duration_seconds_count:sum_rate
{{< /code >}}
 
##### cluster_job_operation:cortex_cassandra_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_cassandra_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, operation))
record: cluster_job_operation:cortex_cassandra_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job_operation:cortex_cassandra_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_cassandra_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, operation))
record: cluster_job_operation:cortex_cassandra_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job_operation:cortex_cassandra_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_cassandra_request_duration_seconds_sum[1m])) by (cluster, job,
  operation) / sum(rate(cortex_cassandra_request_duration_seconds_count[1m])) by (cluster,
  job, operation)
record: cluster_job_operation:cortex_cassandra_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_job_operation:cortex_cassandra_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_cassandra_request_duration_seconds_bucket[1m])) by (le, cluster,
  job, operation)
record: cluster_job_operation:cortex_cassandra_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job_operation:cortex_cassandra_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_cassandra_request_duration_seconds_sum[1m])) by (cluster, job,
  operation)
record: cluster_job_operation:cortex_cassandra_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job_operation:cortex_cassandra_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_cassandra_request_duration_seconds_count[1m])) by (cluster,
  job, operation)
record: cluster_job_operation:cortex_cassandra_request_duration_seconds_count:sum_rate
{{< /code >}}
 
##### cluster_job_operation:cortex_dynamo_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_dynamo_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, operation))
record: cluster_job_operation:cortex_dynamo_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job_operation:cortex_dynamo_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_dynamo_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, operation))
record: cluster_job_operation:cortex_dynamo_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job_operation:cortex_dynamo_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_dynamo_request_duration_seconds_sum[1m])) by (cluster, job,
  operation) / sum(rate(cortex_dynamo_request_duration_seconds_count[1m])) by (cluster,
  job, operation)
record: cluster_job_operation:cortex_dynamo_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_job_operation:cortex_dynamo_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_dynamo_request_duration_seconds_bucket[1m])) by (le, cluster,
  job, operation)
record: cluster_job_operation:cortex_dynamo_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job_operation:cortex_dynamo_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_dynamo_request_duration_seconds_sum[1m])) by (cluster, job,
  operation)
record: cluster_job_operation:cortex_dynamo_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job_operation:cortex_dynamo_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_dynamo_request_duration_seconds_count[1m])) by (cluster, job,
  operation)
record: cluster_job_operation:cortex_dynamo_request_duration_seconds_count:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_index_lookups_per_query:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_chunk_store_index_lookups_per_query_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_chunk_store_index_lookups_per_query:99quantile
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_index_lookups_per_query:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_chunk_store_index_lookups_per_query_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_chunk_store_index_lookups_per_query:50quantile
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_index_lookups_per_query:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_index_lookups_per_query_sum[1m])) by (cluster, job)
  / sum(rate(cortex_chunk_store_index_lookups_per_query_count[1m])) by (cluster, job)
record: cluster_job:cortex_chunk_store_index_lookups_per_query:avg
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_index_lookups_per_query_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_index_lookups_per_query_bucket[1m])) by (le, cluster,
  job)
record: cluster_job:cortex_chunk_store_index_lookups_per_query_bucket:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_index_lookups_per_query_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_index_lookups_per_query_sum[1m])) by (cluster, job)
record: cluster_job:cortex_chunk_store_index_lookups_per_query_sum:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_index_lookups_per_query_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_index_lookups_per_query_count[1m])) by (cluster,
  job)
record: cluster_job:cortex_chunk_store_index_lookups_per_query_count:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_series_pre_intersection_per_query:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_chunk_store_series_pre_intersection_per_query_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_chunk_store_series_pre_intersection_per_query:99quantile
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_series_pre_intersection_per_query:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_chunk_store_series_pre_intersection_per_query_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_chunk_store_series_pre_intersection_per_query:50quantile
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_series_pre_intersection_per_query:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_series_pre_intersection_per_query_sum[1m])) by (cluster,
  job) / sum(rate(cortex_chunk_store_series_pre_intersection_per_query_count[1m]))
  by (cluster, job)
record: cluster_job:cortex_chunk_store_series_pre_intersection_per_query:avg
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_series_pre_intersection_per_query_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_series_pre_intersection_per_query_bucket[1m])) by
  (le, cluster, job)
record: cluster_job:cortex_chunk_store_series_pre_intersection_per_query_bucket:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_series_pre_intersection_per_query_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_series_pre_intersection_per_query_sum[1m])) by (cluster,
  job)
record: cluster_job:cortex_chunk_store_series_pre_intersection_per_query_sum:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_series_pre_intersection_per_query_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_series_pre_intersection_per_query_count[1m])) by
  (cluster, job)
record: cluster_job:cortex_chunk_store_series_pre_intersection_per_query_count:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_series_post_intersection_per_query:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_chunk_store_series_post_intersection_per_query_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_chunk_store_series_post_intersection_per_query:99quantile
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_series_post_intersection_per_query:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_chunk_store_series_post_intersection_per_query_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_chunk_store_series_post_intersection_per_query:50quantile
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_series_post_intersection_per_query:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_series_post_intersection_per_query_sum[1m])) by
  (cluster, job) / sum(rate(cortex_chunk_store_series_post_intersection_per_query_count[1m]))
  by (cluster, job)
record: cluster_job:cortex_chunk_store_series_post_intersection_per_query:avg
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_series_post_intersection_per_query_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_series_post_intersection_per_query_bucket[1m]))
  by (le, cluster, job)
record: cluster_job:cortex_chunk_store_series_post_intersection_per_query_bucket:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_series_post_intersection_per_query_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_series_post_intersection_per_query_sum[1m])) by
  (cluster, job)
record: cluster_job:cortex_chunk_store_series_post_intersection_per_query_sum:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_series_post_intersection_per_query_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_series_post_intersection_per_query_count[1m])) by
  (cluster, job)
record: cluster_job:cortex_chunk_store_series_post_intersection_per_query_count:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_chunks_per_query:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_chunk_store_chunks_per_query_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_chunk_store_chunks_per_query:99quantile
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_chunks_per_query:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_chunk_store_chunks_per_query_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_chunk_store_chunks_per_query:50quantile
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_chunks_per_query:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_chunks_per_query_sum[1m])) by (cluster, job) / sum(rate(cortex_chunk_store_chunks_per_query_count[1m]))
  by (cluster, job)
record: cluster_job:cortex_chunk_store_chunks_per_query:avg
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_chunks_per_query_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_chunks_per_query_bucket[1m])) by (le, cluster, job)
record: cluster_job:cortex_chunk_store_chunks_per_query_bucket:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_chunks_per_query_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_chunks_per_query_sum[1m])) by (cluster, job)
record: cluster_job:cortex_chunk_store_chunks_per_query_sum:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_chunk_store_chunks_per_query_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_chunk_store_chunks_per_query_count[1m])) by (cluster, job)
record: cluster_job:cortex_chunk_store_chunks_per_query_count:sum_rate
{{< /code >}}
 
##### cluster_job_method:cortex_database_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_database_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, method))
record: cluster_job_method:cortex_database_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job_method:cortex_database_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_database_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, method))
record: cluster_job_method:cortex_database_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job_method:cortex_database_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_database_request_duration_seconds_sum[1m])) by (cluster, job,
  method) / sum(rate(cortex_database_request_duration_seconds_count[1m])) by (cluster,
  job, method)
record: cluster_job_method:cortex_database_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_job_method:cortex_database_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_database_request_duration_seconds_bucket[1m])) by (le, cluster,
  job, method)
record: cluster_job_method:cortex_database_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job_method:cortex_database_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_database_request_duration_seconds_sum[1m])) by (cluster, job,
  method)
record: cluster_job_method:cortex_database_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job_method:cortex_database_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_database_request_duration_seconds_count[1m])) by (cluster, job,
  method)
record: cluster_job_method:cortex_database_request_duration_seconds_count:sum_rate
{{< /code >}}
 
##### cluster_job_operation:cortex_gcs_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_gcs_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, operation))
record: cluster_job_operation:cortex_gcs_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job_operation:cortex_gcs_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_gcs_request_duration_seconds_bucket[1m]))
  by (le, cluster, job, operation))
record: cluster_job_operation:cortex_gcs_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job_operation:cortex_gcs_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_gcs_request_duration_seconds_sum[1m])) by (cluster, job, operation)
  / sum(rate(cortex_gcs_request_duration_seconds_count[1m])) by (cluster, job, operation)
record: cluster_job_operation:cortex_gcs_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_job_operation:cortex_gcs_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_gcs_request_duration_seconds_bucket[1m])) by (le, cluster, job,
  operation)
record: cluster_job_operation:cortex_gcs_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job_operation:cortex_gcs_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_gcs_request_duration_seconds_sum[1m])) by (cluster, job, operation)
record: cluster_job_operation:cortex_gcs_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job_operation:cortex_gcs_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_gcs_request_duration_seconds_count[1m])) by (cluster, job, operation)
record: cluster_job_operation:cortex_gcs_request_duration_seconds_count:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_kv_request_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_kv_request_duration_seconds_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_kv_request_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job:cortex_kv_request_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_kv_request_duration_seconds_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_kv_request_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job:cortex_kv_request_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_kv_request_duration_seconds_sum[1m])) by (cluster, job) / sum(rate(cortex_kv_request_duration_seconds_count[1m]))
  by (cluster, job)
record: cluster_job:cortex_kv_request_duration_seconds:avg
{{< /code >}}
 
##### cluster_job:cortex_kv_request_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_kv_request_duration_seconds_bucket[1m])) by (le, cluster, job)
record: cluster_job:cortex_kv_request_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_kv_request_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_kv_request_duration_seconds_sum[1m])) by (cluster, job)
record: cluster_job:cortex_kv_request_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_kv_request_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_kv_request_duration_seconds_count[1m])) by (cluster, job)
record: cluster_job:cortex_kv_request_duration_seconds_count:sum_rate
{{< /code >}}
 
### cortex_queries

##### cluster_job:cortex_query_frontend_retries:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_query_frontend_retries_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_query_frontend_retries:99quantile
{{< /code >}}
 
##### cluster_job:cortex_query_frontend_retries:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_query_frontend_retries_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_query_frontend_retries:50quantile
{{< /code >}}
 
##### cluster_job:cortex_query_frontend_retries:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_query_frontend_retries_sum[1m])) by (cluster, job) / sum(rate(cortex_query_frontend_retries_count[1m]))
  by (cluster, job)
record: cluster_job:cortex_query_frontend_retries:avg
{{< /code >}}
 
##### cluster_job:cortex_query_frontend_retries_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_query_frontend_retries_bucket[1m])) by (le, cluster, job)
record: cluster_job:cortex_query_frontend_retries_bucket:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_query_frontend_retries_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_query_frontend_retries_sum[1m])) by (cluster, job)
record: cluster_job:cortex_query_frontend_retries_sum:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_query_frontend_retries_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_query_frontend_retries_count[1m])) by (cluster, job)
record: cluster_job:cortex_query_frontend_retries_count:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_query_frontend_queue_duration_seconds:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_query_frontend_queue_duration_seconds_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_query_frontend_queue_duration_seconds:99quantile
{{< /code >}}
 
##### cluster_job:cortex_query_frontend_queue_duration_seconds:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_query_frontend_queue_duration_seconds_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_query_frontend_queue_duration_seconds:50quantile
{{< /code >}}
 
##### cluster_job:cortex_query_frontend_queue_duration_seconds:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_query_frontend_queue_duration_seconds_sum[1m])) by (cluster,
  job) / sum(rate(cortex_query_frontend_queue_duration_seconds_count[1m])) by (cluster,
  job)
record: cluster_job:cortex_query_frontend_queue_duration_seconds:avg
{{< /code >}}
 
##### cluster_job:cortex_query_frontend_queue_duration_seconds_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_query_frontend_queue_duration_seconds_bucket[1m])) by (le, cluster,
  job)
record: cluster_job:cortex_query_frontend_queue_duration_seconds_bucket:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_query_frontend_queue_duration_seconds_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_query_frontend_queue_duration_seconds_sum[1m])) by (cluster,
  job)
record: cluster_job:cortex_query_frontend_queue_duration_seconds_sum:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_query_frontend_queue_duration_seconds_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_query_frontend_queue_duration_seconds_count[1m])) by (cluster,
  job)
record: cluster_job:cortex_query_frontend_queue_duration_seconds_count:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_series:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_ingester_queried_series_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_ingester_queried_series:99quantile
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_series:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_ingester_queried_series_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_ingester_queried_series:50quantile
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_series:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_ingester_queried_series_sum[1m])) by (cluster, job) / sum(rate(cortex_ingester_queried_series_count[1m]))
  by (cluster, job)
record: cluster_job:cortex_ingester_queried_series:avg
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_series_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_ingester_queried_series_bucket[1m])) by (le, cluster, job)
record: cluster_job:cortex_ingester_queried_series_bucket:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_series_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_ingester_queried_series_sum[1m])) by (cluster, job)
record: cluster_job:cortex_ingester_queried_series_sum:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_series_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_ingester_queried_series_count[1m])) by (cluster, job)
record: cluster_job:cortex_ingester_queried_series_count:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_chunks:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_ingester_queried_chunks_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_ingester_queried_chunks:99quantile
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_chunks:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_ingester_queried_chunks_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_ingester_queried_chunks:50quantile
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_chunks:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_ingester_queried_chunks_sum[1m])) by (cluster, job) / sum(rate(cortex_ingester_queried_chunks_count[1m]))
  by (cluster, job)
record: cluster_job:cortex_ingester_queried_chunks:avg
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_chunks_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_ingester_queried_chunks_bucket[1m])) by (le, cluster, job)
record: cluster_job:cortex_ingester_queried_chunks_bucket:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_chunks_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_ingester_queried_chunks_sum[1m])) by (cluster, job)
record: cluster_job:cortex_ingester_queried_chunks_sum:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_chunks_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_ingester_queried_chunks_count[1m])) by (cluster, job)
record: cluster_job:cortex_ingester_queried_chunks_count:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_samples:99quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.99, sum(rate(cortex_ingester_queried_samples_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_ingester_queried_samples:99quantile
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_samples:50quantile

{{< code lang="yaml" >}}
expr: histogram_quantile(0.50, sum(rate(cortex_ingester_queried_samples_bucket[1m]))
  by (le, cluster, job))
record: cluster_job:cortex_ingester_queried_samples:50quantile
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_samples:avg

{{< code lang="yaml" >}}
expr: sum(rate(cortex_ingester_queried_samples_sum[1m])) by (cluster, job) / sum(rate(cortex_ingester_queried_samples_count[1m]))
  by (cluster, job)
record: cluster_job:cortex_ingester_queried_samples:avg
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_samples_bucket:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_ingester_queried_samples_bucket[1m])) by (le, cluster, job)
record: cluster_job:cortex_ingester_queried_samples_bucket:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_samples_sum:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_ingester_queried_samples_sum[1m])) by (cluster, job)
record: cluster_job:cortex_ingester_queried_samples_sum:sum_rate
{{< /code >}}
 
##### cluster_job:cortex_ingester_queried_samples_count:sum_rate

{{< code lang="yaml" >}}
expr: sum(rate(cortex_ingester_queried_samples_count[1m])) by (cluster, job)
record: cluster_job:cortex_ingester_queried_samples_count:sum_rate
{{< /code >}}
 
### cortex_received_samples

##### cluster_namespace_job:cortex_distributor_received_samples:rate5m

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, namespace, job) (rate(cortex_distributor_received_samples_total[5m]))
record: cluster_namespace_job:cortex_distributor_received_samples:rate5m
{{< /code >}}
 
### cortex_scaling_rules

##### cluster_namespace_deployment:actual_replicas:count

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, namespace, deployment) (
    label_replace(
      kube_deployment_spec_replicas,
      # The question mark in "(.*?)" is used to make it non-greedy, otherwise it
      # always matches everything and the (optional) zone is not removed.
      "deployment", "$1", "deployment", "(.*?)(?:-zone-[a-z])?"
    )
  )
  or
  sum by (cluster, namespace, deployment) (
    label_replace(kube_statefulset_replicas, "deployment", "$1", "statefulset", "(.*?)(?:-zone-[a-z])?")
  )
record: cluster_namespace_deployment:actual_replicas:count
{{< /code >}}
 
##### cluster_namespace_deployment_reason:required_replicas:count

{{< code lang="yaml" >}}
expr: |
  ceil(
    quantile_over_time(0.99,
      sum by (cluster, namespace) (
        cluster_namespace_job:cortex_distributor_received_samples:rate5m
      )[24h:]
    )
    / 240000
  )
labels:
  deployment: distributor
  reason: sample_rate
record: cluster_namespace_deployment_reason:required_replicas:count
{{< /code >}}
 
##### cluster_namespace_deployment_reason:required_replicas:count

{{< code lang="yaml" >}}
expr: |
  ceil(
    sum by (cluster, namespace) (cortex_overrides{limit_name="ingestion_rate"})
    * 0.59999999999999998 / 240000
  )
labels:
  deployment: distributor
  reason: sample_rate_limits
record: cluster_namespace_deployment_reason:required_replicas:count
{{< /code >}}
 
##### cluster_namespace_deployment_reason:required_replicas:count

{{< code lang="yaml" >}}
expr: |
  ceil(
    quantile_over_time(0.99,
      sum by (cluster, namespace) (
        cluster_namespace_job:cortex_distributor_received_samples:rate5m
      )[24h:]
    )
    * 3 / 80000
  )
labels:
  deployment: ingester
  reason: sample_rate
record: cluster_namespace_deployment_reason:required_replicas:count
{{< /code >}}
 
##### cluster_namespace_deployment_reason:required_replicas:count

{{< code lang="yaml" >}}
expr: |
  ceil(
    quantile_over_time(0.99,
      sum by(cluster, namespace) (
        cortex_ingester_memory_series
      )[24h:]
    )
    / 3000000
  )
labels:
  deployment: ingester
  reason: active_series
record: cluster_namespace_deployment_reason:required_replicas:count
{{< /code >}}
 
##### cluster_namespace_deployment_reason:required_replicas:count

{{< code lang="yaml" >}}
expr: |
  ceil(
    sum by (cluster, namespace) (cortex_overrides{limit_name="max_global_series_per_user"})
    * 3 * 0.59999999999999998 / 3000000
  )
labels:
  deployment: ingester
  reason: active_series_limits
record: cluster_namespace_deployment_reason:required_replicas:count
{{< /code >}}
 
##### cluster_namespace_deployment_reason:required_replicas:count

{{< code lang="yaml" >}}
expr: |
  ceil(
    sum by (cluster, namespace) (cortex_overrides{limit_name="ingestion_rate"})
    * 0.59999999999999998 / 80000
  )
labels:
  deployment: ingester
  reason: sample_rate_limits
record: cluster_namespace_deployment_reason:required_replicas:count
{{< /code >}}
 
##### cluster_namespace_deployment_reason:required_replicas:count

{{< code lang="yaml" >}}
expr: |
  ceil(
    (sum by (cluster, namespace) (
      cortex_ingester_tsdb_storage_blocks_bytes{job=~".+/ingester.*"}
    ) / 4)
      /
    avg by (cluster, namespace) (
      memcached_limit_bytes{job=~".+/memcached"}
    )
  )
labels:
  deployment: memcached
  reason: active_series
record: cluster_namespace_deployment_reason:required_replicas:count
{{< /code >}}
 
##### cluster_namespace_deployment:container_cpu_usage_seconds_total:sum_rate

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, namespace, deployment) (
    label_replace(
      label_replace(
        node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate,
        "deployment", "$1", "pod", "(.*)-(?:([0-9]+)|([a-z0-9]+)-([a-z0-9]+))"
      ),
      # The question mark in "(.*?)" is used to make it non-greedy, otherwise it
      # always matches everything and the (optional) zone is not removed.
      "deployment", "$1", "deployment", "(.*?)(?:-zone-[a-z])?"
    )
  )
record: cluster_namespace_deployment:container_cpu_usage_seconds_total:sum_rate
{{< /code >}}
 
##### 
cluster_namespace_deployment:kube_pod_container_resource_requests_cpu_cores:sum

{{< code lang="yaml" >}}
expr: |
  # This recording rule is made compatible with the breaking changes introduced in kube-state-metrics v2
  # that remove resource metrics, ref:
  # - https://github.com/kubernetes/kube-state-metrics/blob/master/CHANGELOG.md#v200-alpha--2020-09-16
  # - https://github.com/kubernetes/kube-state-metrics/pull/1004
  #
  # This is the old expression, compatible with kube-state-metrics < v2.0.0,
  # where kube_pod_container_resource_requests_cpu_cores was removed:
  (
    sum by (cluster, namespace, deployment) (
      label_replace(
        label_replace(
          kube_pod_container_resource_requests_cpu_cores,
          "deployment", "$1", "pod", "(.*)-(?:([0-9]+)|([a-z0-9]+)-([a-z0-9]+))"
        ),
        # The question mark in "(.*?)" is used to make it non-greedy, otherwise it
        # always matches everything and the (optional) zone is not removed.
        "deployment", "$1", "deployment", "(.*?)(?:-zone-[a-z])?"
      )
    )
  )
  or
  # This expression is compatible with kube-state-metrics >= v1.4.0,
  # where kube_pod_container_resource_requests was introduced.
  (
    sum by (cluster, namespace, deployment) (
      label_replace(
        label_replace(
          kube_pod_container_resource_requests{resource="cpu"},
          "deployment", "$1", "pod", "(.*)-(?:([0-9]+)|([a-z0-9]+)-([a-z0-9]+))"
        ),
        # The question mark in "(.*?)" is used to make it non-greedy, otherwise it
        # always matches everything and the (optional) zone is not removed.
        "deployment", "$1", "deployment", "(.*?)(?:-zone-[a-z])?"
      )
    )
  )
record: cluster_namespace_deployment:kube_pod_container_resource_requests_cpu_cores:sum
{{< /code >}}
 
##### cluster_namespace_deployment_reason:required_replicas:count

{{< code lang="yaml" >}}
expr: |
  ceil(
    cluster_namespace_deployment:actual_replicas:count
      *
    quantile_over_time(0.99, cluster_namespace_deployment:container_cpu_usage_seconds_total:sum_rate[24h])
      /
    cluster_namespace_deployment:kube_pod_container_resource_requests_cpu_cores:sum
  )
labels:
  reason: cpu_usage
record: cluster_namespace_deployment_reason:required_replicas:count
{{< /code >}}
 
##### cluster_namespace_deployment:container_memory_usage_bytes:sum

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, namespace, deployment) (
    label_replace(
      label_replace(
        container_memory_usage_bytes,
        "deployment", "$1", "pod", "(.*)-(?:([0-9]+)|([a-z0-9]+)-([a-z0-9]+))"
      ),
      # The question mark in "(.*?)" is used to make it non-greedy, otherwise it
      # always matches everything and the (optional) zone is not removed.
      "deployment", "$1", "deployment", "(.*?)(?:-zone-[a-z])?"
    )
  )
record: cluster_namespace_deployment:container_memory_usage_bytes:sum
{{< /code >}}
 
##### 
cluster_namespace_deployment:kube_pod_container_resource_requests_memory_bytes:sum

{{< code lang="yaml" >}}
expr: |
  # This recording rule is made compatible with the breaking changes introduced in kube-state-metrics v2
  # that remove resource metrics, ref:
  # - https://github.com/kubernetes/kube-state-metrics/blob/master/CHANGELOG.md#v200-alpha--2020-09-16
  # - https://github.com/kubernetes/kube-state-metrics/pull/1004
  #
  # This is the old expression, compatible with kube-state-metrics < v2.0.0,
  # where kube_pod_container_resource_requests_memory_bytes was removed:
  (
    sum by (cluster, namespace, deployment) (
      label_replace(
        label_replace(
          kube_pod_container_resource_requests_memory_bytes,
          "deployment", "$1", "pod", "(.*)-(?:([0-9]+)|([a-z0-9]+)-([a-z0-9]+))"
        ),
        # The question mark in "(.*?)" is used to make it non-greedy, otherwise it
        # always matches everything and the (optional) zone is not removed.
        "deployment", "$1", "deployment", "(.*?)(?:-zone-[a-z])?"
      )
    )
  )
  or
  # This expression is compatible with kube-state-metrics >= v1.4.0,
  # where kube_pod_container_resource_requests was introduced.
  (
    sum by (cluster, namespace, deployment) (
      label_replace(
        label_replace(
          kube_pod_container_resource_requests{resource="memory"},
          "deployment", "$1", "pod", "(.*)-(?:([0-9]+)|([a-z0-9]+)-([a-z0-9]+))"
        ),
        # The question mark in "(.*?)" is used to make it non-greedy, otherwise it
        # always matches everything and the (optional) zone is not removed.
        "deployment", "$1", "deployment", "(.*?)(?:-zone-[a-z])?"
      )
    )
  )
record: cluster_namespace_deployment:kube_pod_container_resource_requests_memory_bytes:sum
{{< /code >}}
 
##### cluster_namespace_deployment_reason:required_replicas:count

{{< code lang="yaml" >}}
expr: |
  ceil(
    cluster_namespace_deployment:actual_replicas:count
      *
    quantile_over_time(0.99, cluster_namespace_deployment:container_memory_usage_bytes:sum[24h])
      /
    cluster_namespace_deployment:kube_pod_container_resource_requests_memory_bytes:sum
  )
labels:
  reason: memory_usage
record: cluster_namespace_deployment_reason:required_replicas:count
{{< /code >}}
 
### cortex_alertmanager_rules

##### cluster_job_pod:cortex_alertmanager_alerts:sum

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, job, pod) (cortex_alertmanager_alerts)
record: cluster_job_pod:cortex_alertmanager_alerts:sum
{{< /code >}}
 
##### cluster_job_pod:cortex_alertmanager_silences:sum

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, job, pod) (cortex_alertmanager_silences)
record: cluster_job_pod:cortex_alertmanager_silences:sum
{{< /code >}}
 
##### cluster_job:cortex_alertmanager_alerts_received_total:rate5m

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, job) (rate(cortex_alertmanager_alerts_received_total[5m]))
record: cluster_job:cortex_alertmanager_alerts_received_total:rate5m
{{< /code >}}
 
##### cluster_job:cortex_alertmanager_alerts_invalid_total:rate5m

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, job) (rate(cortex_alertmanager_alerts_invalid_total[5m]))
record: cluster_job:cortex_alertmanager_alerts_invalid_total:rate5m
{{< /code >}}
 
##### cluster_job_integration:cortex_alertmanager_notifications_total:rate5m

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, job, integration) (rate(cortex_alertmanager_notifications_total[5m]))
record: cluster_job_integration:cortex_alertmanager_notifications_total:rate5m
{{< /code >}}
 
##### cluster_job_integration:cortex_alertmanager_notifications_failed_total:rate5m

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, job, integration) (rate(cortex_alertmanager_notifications_failed_total[5m]))
record: cluster_job_integration:cortex_alertmanager_notifications_failed_total:rate5m
{{< /code >}}
 
##### cluster_job:cortex_alertmanager_state_replication_total:rate5m

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, job) (rate(cortex_alertmanager_state_replication_total[5m]))
record: cluster_job:cortex_alertmanager_state_replication_total:rate5m
{{< /code >}}
 
##### cluster_job:cortex_alertmanager_state_replication_failed_total:rate5m

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, job) (rate(cortex_alertmanager_state_replication_failed_total[5m]))
record: cluster_job:cortex_alertmanager_state_replication_failed_total:rate5m
{{< /code >}}
 
##### cluster_job:cortex_alertmanager_partial_state_merges_total:rate5m

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, job) (rate(cortex_alertmanager_partial_state_merges_total[5m]))
record: cluster_job:cortex_alertmanager_partial_state_merges_total:rate5m
{{< /code >}}
 
##### cluster_job:cortex_alertmanager_partial_state_merges_failed_total:rate5m

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, job) (rate(cortex_alertmanager_partial_state_merges_failed_total[5m]))
record: cluster_job:cortex_alertmanager_partial_state_merges_failed_total:rate5m
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [alertmanager](https://github.com/monitoring-mixins/website/blob/master/assets/cortex/dashboards/alertmanager.json)
- [cortex-compactor-resources](https://github.com/monitoring-mixins/website/blob/master/assets/cortex/dashboards/cortex-compactor-resources.json)
- [cortex-compactor](https://github.com/monitoring-mixins/website/blob/master/assets/cortex/dashboards/cortex-compactor.json)
- [cortex-config](https://github.com/monitoring-mixins/website/blob/master/assets/cortex/dashboards/cortex-config.json)
- [cortex-object-store](https://github.com/monitoring-mixins/website/blob/master/assets/cortex/dashboards/cortex-object-store.json)
- [cortex-queries](https://github.com/monitoring-mixins/website/blob/master/assets/cortex/dashboards/cortex-queries.json)
- [cortex-reads](https://github.com/monitoring-mixins/website/blob/master/assets/cortex/dashboards/cortex-reads.json)
- [cortex-rollout-progress](https://github.com/monitoring-mixins/website/blob/master/assets/cortex/dashboards/cortex-rollout-progress.json)
- [cortex-scaling](https://github.com/monitoring-mixins/website/blob/master/assets/cortex/dashboards/cortex-scaling.json)
- [cortex-slow-queries](https://github.com/monitoring-mixins/website/blob/master/assets/cortex/dashboards/cortex-slow-queries.json)
- [cortex-writes](https://github.com/monitoring-mixins/website/blob/master/assets/cortex/dashboards/cortex-writes.json)
- [ruler](https://github.com/monitoring-mixins/website/blob/master/assets/cortex/dashboards/ruler.json)
