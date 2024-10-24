---
title: apache-cassandra
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/apache-cassandra-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/apache-cassandra/alerts.yaml).
{{< /panel >}}

### ApacheCassandraAlerts

##### HighReadLatency

{{< code lang="yaml" >}}
alert: HighReadLatency
annotations:
  description: 'An average of {{ printf "%.0f" $value }}ms of read latency has occurred
    over the last 5 minutes on {{$labels.instance}}, which is above the threshold
    of 200ms. '
  summary: There is a high level of read latency within the node.
expr: |
  sum(cassandra_table_readlatency_seconds_sum) by (instance) / sum(cassandra_table_readlatency_seconds_count) by (instance) * 1000 > 200
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### HighWriteLatency

{{< code lang="yaml" >}}
alert: HighWriteLatency
annotations:
  description: 'An average of {{ printf "%.0f" $value }}ms of write latency has occurred
    over the last 5 minutes on {{$labels.instance}}, which is above the threshold
    of 200ms. '
  summary: There is a high level of write latency within the node.
expr: |
  sum(cassandra_keyspace_writelatency_seconds_sum) by (instance) / sum(cassandra_keyspace_writelatency_seconds_count) by (instance) * 1000 > 200
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### HighPendingCompactionTasks

{{< code lang="yaml" >}}
alert: HighPendingCompactionTasks
annotations:
  description: '{{ printf "%.0f" $value }} compaction tasks have been pending over
    the last 15 minutes on {{$labels.instance}}, which is above the threshold of 30. '
  summary: Compaction task queue is filling up.
expr: |
  cassandra_compaction_pendingtasks > 30
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### BlockedCompactionTasksFound

{{< code lang="yaml" >}}
alert: BlockedCompactionTasksFound
annotations:
  description: '{{ printf "%.0f" $value }} compaction tasks have been blocked over
    the last 5 minutes on {{$labels.instance}}, which is above the threshold of 1. '
  summary: Compaction task queue is full.
expr: |
  cassandra_threadpools_currentlyblockedtasks_count{threadpools="CompactionExecutor", path="internal"} > 1
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### HintsStoredOnNode

{{< code lang="yaml" >}}
alert: HintsStoredOnNode
annotations:
  description: '{{ printf "%.0f" $value }} hints have been written to the node over
    the last minute on {{$labels.instance}}, which is above the threshold of 1. '
  summary: Hints have been recently written to this node.
expr: |
  increase(cassandra_storage_totalhints_count[5m]) > 1
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### UnavailableWriteRequestsFound

{{< code lang="yaml" >}}
alert: UnavailableWriteRequestsFound
annotations:
  description: '{{ printf "%.0f" $value }} unavailable write requests have been found
    over the last 5 minutes on {{$labels.instance}}, which is above the threshold
    of 1. '
  summary: Unavailable exceptions have been encountered while performing writes in
    this cluster.
expr: |
  sum(cassandra_clientrequest_unavailables_count{clientrequest="Write"}) by (cassandra_cluster) > 1
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### HighCpuUsage

{{< code lang="yaml" >}}
alert: HighCpuUsage
annotations:
  description: 'Cpu usage is at {{ printf "%.0f" $value }} percent over the last 5
    minutes on {{$labels.instance}}, which is above the threshold of 80. '
  summary: A node has a CPU usage higher than the configured threshold.
expr: |
  jvm_process_cpu_load{job=~"integrations/apache-cassandra"} * 100 > 80
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### HighMemoryUsage

{{< code lang="yaml" >}}
alert: HighMemoryUsage
annotations:
  description: 'Memory usage is at {{ printf "%.0f" $value }} percent over the last
    5 minutes on {{$labels.instance}}, which is above the threshold of 80 }}. '
  summary: A node has a higher memory utilization than the configured threshold.
expr: |
  sum(jvm_memory_usage_used_bytes{job=~"integrations/apache-cassandra", area="Heap"}) / sum(jvm_physical_memory_size{job=~"integrations/apache-cassandra"}) * 100 > 80
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [cassandra-keyspaces](https://github.com/monitoring-mixins/website/blob/master/assets/apache-cassandra/dashboards/cassandra-keyspaces.json)
- [cassandra-nodes](https://github.com/monitoring-mixins/website/blob/master/assets/apache-cassandra/dashboards/cassandra-nodes.json)
- [cassandra-overview](https://github.com/monitoring-mixins/website/blob/master/assets/apache-cassandra/dashboards/cassandra-overview.json)
