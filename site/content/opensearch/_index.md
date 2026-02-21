---
title: opensearch
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/opensearch-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/opensearch/alerts.yaml).
{{< /panel >}}

### opensearch-alerts

##### OpenSearchYellowCluster

{{< code lang="yaml" >}}
alert: OpenSearchYellowCluster
annotations:
  description: '{{$labels.cluster}} health status is yellow over the last 5 minutes'
  summary: At least one of the clusters is reporting a yellow status.
expr: |
  opensearch_cluster_status{} == 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### OpenSearchRedCluster

{{< code lang="yaml" >}}
alert: OpenSearchRedCluster
annotations:
  description: '{{$labels.cluster}} health status is red over the last 5 minutes'
  summary: At least one of the clusters is reporting a red status.
expr: |
  opensearch_cluster_status{} == 2
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### OpenSearchUnstableShardReallocation

{{< code lang="yaml" >}}
alert: OpenSearchUnstableShardReallocation
annotations:
  description: |
    {{$labels.cluster}} has had {{ printf "%.0f" $value }} shard reallocation over the last 1m which is above the threshold of 0.
  summary: A node has gone offline or has been disconnected triggering shard reallocation.
expr: |
  sum without(type) (opensearch_cluster_shards_number{type="relocating", }) > 0
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### OpenSearchUnstableShardUnassigned

{{< code lang="yaml" >}}
alert: OpenSearchUnstableShardUnassigned
annotations:
  description: |
    {{$labels.cluster}} has had {{ printf "%.0f" $value }} shard unassigned over the last 5m which is above the threshold of 0.
  summary: There are shards that have been detected as unassigned.
expr: |
  sum without(type) (opensearch_cluster_shards_number{type="unassigned", }) > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### OpenSearchHighNodeDiskUsage

{{< code lang="yaml" >}}
alert: OpenSearchHighNodeDiskUsage
annotations:
  description: |
    {{$labels.node}} has had {{ printf "%.0f" $value }} disk usage over the last 5m which is above the threshold of 60.
  summary: The node disk usage has exceeded the warning threshold.
expr: |
  100 * sum without(nodeid, path, mount, type) ((opensearch_fs_path_total_bytes{} - opensearch_fs_path_free_bytes{}) / opensearch_fs_path_total_bytes{}) > 60
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### OpenSearchHighNodeDiskUsage

{{< code lang="yaml" >}}
alert: OpenSearchHighNodeDiskUsage
annotations:
  description: |
    {{$labels.node}} has had {{ printf "%.0f" $value }}% disk usage over the last 5m which is above the threshold of 80.
  summary: The node disk usage has exceeded the critical threshold.
expr: |
  100 * sum without(nodeid, path, mount, type) ((opensearch_fs_path_total_bytes{} - opensearch_fs_path_free_bytes{}) / opensearch_fs_path_total_bytes{}) > 80
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### OpenSearchHighNodeCpuUsage

{{< code lang="yaml" >}}
alert: OpenSearchHighNodeCpuUsage
annotations:
  description: |
    {{$labels.node}} has had {{ printf "%.0f" $value }}% CPU usage over the last 5m which is above the threshold of 70.
  summary: The node CPU usage has exceeded the warning threshold.
expr: |
  sum without(nodeid) (opensearch_os_cpu_percent{}) > 70
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### OpenSearchHighNodeCpuUsage

{{< code lang="yaml" >}}
alert: OpenSearchHighNodeCpuUsage
annotations:
  description: |
    {{$labels.node}} has had {{ printf "%.0f" $value }}% CPU usage over the last 5m which is above the threshold of 85.
  summary: The node CPU usage has exceeded the critical threshold.
expr: |
  sum without(nodeid) (opensearch_os_cpu_percent{}) > 85
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### OpenSearchHighNodeMemoryUsage

{{< code lang="yaml" >}}
alert: OpenSearchHighNodeMemoryUsage
annotations:
  description: |
    {{$labels.node}} has had {{ printf "%.0f" $value }}% memory usage over the last 5m which is above the threshold of 70.
  summary: The node memory usage has exceeded the warning threshold.
expr: |
  sum without(nodeid) (opensearch_os_mem_used_percent{}) > 70
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### OpenSearchHighNodeMemoryUsage

{{< code lang="yaml" >}}
alert: OpenSearchHighNodeMemoryUsage
annotations:
  description: |
    {{$labels.node}} has had {{ printf "%.0f" $value }}% memory usage over the last 5m which is above the threshold of 85.
  summary: The node memory usage has exceeded the critical threshold.
expr: |
  sum without(nodeid) (opensearch_os_mem_used_percent{}) > 85
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### OpenSearchModerateRequestLatency

{{< code lang="yaml" >}}
alert: OpenSearchModerateRequestLatency
annotations:
  description: |
    {{$labels.index}} has had {{ printf "%.0f" $value }}s of request latency over the last 5m which is above the threshold of 500ms.
  summary: The request latency has exceeded the warning threshold.
expr: |
  sum without(context) ((increase(opensearch_index_search_fetch_time_seconds{context="total", }[5m])+increase(opensearch_index_search_query_time_seconds{context="total"}[5m])+increase(opensearch_index_search_scroll_time_seconds{context="total"}[5m])) / clamp_min(increase(opensearch_index_search_fetch_count{context="total"}[5m])+increase(opensearch_index_search_query_count{context="total"}[5m])+increase(opensearch_index_search_scroll_count{context="total"}[5m]), 1)) > 500 / 1000
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### OpenSearchModerateIndexLatency

{{< code lang="yaml" >}}
alert: OpenSearchModerateIndexLatency
annotations:
  description: |
    {{$labels.index}} has had {{ printf "%.0f" $value }}s of index latency over the last 5m which is above the threshold of 500ms.
  summary: The index latency has exceeded the warning threshold.
expr: |
  sum without(context) (increase(opensearch_index_indexing_index_time_seconds{context="total", }[5m]) / clamp_min(increase(opensearch_index_indexing_index_count{context="total"}[5m]), 1)) > 500 / 1000
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [opensearch-cluster-overview](https://github.com/monitoring-mixins/website/blob/master/assets/opensearch/dashboards/opensearch-cluster-overview.json)
- [opensearch-logs](https://github.com/monitoring-mixins/website/blob/master/assets/opensearch/dashboards/opensearch-logs.json)
- [opensearch-node-overview](https://github.com/monitoring-mixins/website/blob/master/assets/opensearch/dashboards/opensearch-node-overview.json)
- [opensearch-search-and-index-overview](https://github.com/monitoring-mixins/website/blob/master/assets/opensearch/dashboards/opensearch-search-and-index-overview.json)
