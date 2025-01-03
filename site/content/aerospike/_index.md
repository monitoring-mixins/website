---
title: aerospike
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/aerospike-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/aerospike/alerts.yaml).
{{< /panel >}}

### aerospike

##### AerospikeNodeHighMemoryUsage

{{< code lang="yaml" >}}
alert: AerospikeNodeHighMemoryUsage
annotations:
  description: '{{ printf "%.0f" $value }} percent of system memory used on node {{$labels.instance}}
    on cluster {{$labels.aerospike_cluster}}, which is above the threshold of 80.'
  summary: There is a limited amount of memory available for a node.
expr: |
  100 - sum without (service) (aerospike_node_stats_system_free_mem_pct) >= 80
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### AerospikeNamespaceHighDiskUsage

{{< code lang="yaml" >}}
alert: AerospikeNamespaceHighDiskUsage
annotations:
  description: '{{ printf "%.0f" $value }} percent of disk space available for namespace
    {{$labels.ns}} on node {{$labels.instance}}, on cluster {{$labels.aerospike_cluster}},
    which is above the threshold of 80.'
  summary: There is a limited amount of disk space available for a node.
expr: |
  100 - sum without (service) (aerospike_namespace_device_free_pct) >= 80
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### AerospikeUnavailablePartitions

{{< code lang="yaml" >}}
alert: AerospikeUnavailablePartitions
annotations:
  description: '{{ printf "%.0f" $value }} unavailable partition(s) in namespace {{$labels.ns}},
    on node {{$labels.instance}}, on cluster {{$labels.aerospike_cluster}}, which
    is above the threshold of 0.'
  summary: There are unavailable partitions in the Aerospike cluster.
expr: |
  sum without(service) (aerospike_namespace_unavailable_partitions) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### AerospikeDeadPartitions

{{< code lang="yaml" >}}
alert: AerospikeDeadPartitions
annotations:
  description: '{{ printf "%.0f" $value }} dead partition(s) in namespace {{$labels.ns}},
    on node {{$labels.instance}}, on cluster {{$labels.aerospike_cluster}}, which
    is above the threshold of 0.'
  summary: There are dead partitions in the Aerospike cluster.
expr: |
  sum without(service) (aerospike_namespace_dead_partitions) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### AerospikeNamespaceRejectingWrites

{{< code lang="yaml" >}}
alert: AerospikeNamespaceRejectingWrites
annotations:
  description: Namespace {{$labels.ns}} on node {{$labels.instance}} on cluster {{$labels.aerospike_cluster}}
    is currently rejecting all client-originated writes.
  summary: A namespace is currently rejecting all writes. Check for unavailable/dead
    partitions, clock skew, or nodes running out of memory/disk.
expr: |
  sum without(service) (aerospike_namespace_stop_writes + aerospike_namespace_clock_skew_stop_writes) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### AerospikeHighClientReadErrorRate

{{< code lang="yaml" >}}
alert: AerospikeHighClientReadErrorRate
annotations:
  description: '{{ printf "%.0f" $value }} percent of client read transactions are
    resulting in errors for namespace {{$labels.ns}}, on node {{$labels.instance}},
    on cluster {{$labels.aerospike_cluster}}, which is above the threshold of 25.'
  summary: There is a high rate of errors for client read transactions.
expr: |
  sum without(service) (rate(aerospike_namespace_client_read_error[5m])) / (clamp_min(sum without(service) (rate(aerospike_namespace_client_read_error[5m])) + sum without(service) (rate(aerospike_namespace_client_read_success[5m])), 1)) > 25
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### AerospikeHighClientWriteErrorRate

{{< code lang="yaml" >}}
alert: AerospikeHighClientWriteErrorRate
annotations:
  description: '{{ printf "%.0f" $value }} percent of client write transactions are
    resulting in errors for namespace {{$labels.ns}}, on node {{$labels.instance}},
    on cluster {{$labels.aerospike_cluster}}, which is above the threshold of 25.'
  summary: There is a high rate of errors for client write transactions.
expr: |
  sum without(service) (rate(aerospike_namespace_client_write_error[5m])) / (clamp_min(sum without(service) (rate(aerospike_namespace_client_write_error[5m])) + sum without(service) (rate(aerospike_namespace_client_write_success[5m])), 1)) > 25
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### AerospikeHighClientUDFErrorRate

{{< code lang="yaml" >}}
alert: AerospikeHighClientUDFErrorRate
annotations:
  description: '{{ printf "%.0f" $value }} percent of client UDF transactions are
    resulting in errors for namespace {{$labels.ns}}, on node {{$labels.instance}},
    on cluster {{$labels.aerospike_cluster}}, which is above the threshold of 25.'
  summary: There is a high rate of errors for client UDF transactions.
expr: |
  sum without(service) (rate(aerospike_namespace_client_udf_error[5m])) / (clamp_min(sum without(service) (rate(aerospike_namespace_client_udf_error[5m])) + sum without(service) (rate(aerospike_namespace_client_udf_complete[5m])), 1)) > 25
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [aerospike-instance-overview](https://github.com/monitoring-mixins/website/blob/master/assets/aerospike/dashboards/aerospike-instance-overview.json)
- [aerospike-logs](https://github.com/monitoring-mixins/website/blob/master/assets/aerospike/dashboards/aerospike-logs.json)
- [aerospike-namespace-overview](https://github.com/monitoring-mixins/website/blob/master/assets/aerospike/dashboards/aerospike-namespace-overview.json)
- [aerospike-overview](https://github.com/monitoring-mixins/website/blob/master/assets/aerospike/dashboards/aerospike-overview.json)
