---
title: couchbase
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/couchbase-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/couchbase/alerts.yaml).
{{< /panel >}}

### couchbase

##### CouchbaseHighCPUUsage

{{< code lang="yaml" >}}
alert: CouchbaseHighCPUUsage
annotations:
  description: '{{ printf "%.0f" $value }} percent CPU usage on node {{$labels.instance}}
    and on cluster {{$labels.couchbase_cluster}}, which is above the threshold of
    85.'
  summary: The node CPU usage has exceeded the critical threshold.
expr: |
  (sys_cpu_utilization_rate) > 85
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CouchbaseHighMemoryUsage

{{< code lang="yaml" >}}
alert: CouchbaseHighMemoryUsage
annotations:
  description: '{{ printf "%.0f" $value }} percent memory usage on node {{$labels.instance}}
    and on cluster {{$labels.couchbase_cluster}}, which is above the threshold of
    85.'
  summary: There is a limited amount of memory available for a node.
expr: |
  100 * (sys_mem_actual_used / clamp_min(sys_mem_actual_used + sys_mem_actual_free, 1)) > 85
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CouchbaseMemoryEvictionRate

{{< code lang="yaml" >}}
alert: CouchbaseMemoryEvictionRate
annotations:
  description: '{{ printf "%.0f" $value }} evictions in bucket {{$labels.bucket}},
    on node {{$labels.instance}}, and on cluster {{$labels.couchbase_cluster}}, which
    is above the threshold of 10.'
  summary: There is a spike in evictions in a bucket, which indicates high memory
    pressure.
expr: |
  (kv_ep_num_value_ejects) > 10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### CouchbaseInvalidRequestVolume

{{< code lang="yaml" >}}
alert: CouchbaseInvalidRequestVolume
annotations:
  description: '{{ printf "%.0f" $value }} invalid requests to {{$labels.couchbase_cluster}},
    which is above the threshold of 1000.'
  summary: There is a high volume of incoming invalid requests, which may indicate
    a DOS or injection attack.
expr: |
  sum without(instance, job) (rate(n1ql_invalid_requests[2m])) > 1000
for: 2m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [couchbase-bucket-overview](https://github.com/monitoring-mixins/website/blob/master/assets/couchbase/dashboards/couchbase-bucket-overview.json)
- [couchbase-cluster-overview](https://github.com/monitoring-mixins/website/blob/master/assets/couchbase/dashboards/couchbase-cluster-overview.json)
- [couchbase-logs](https://github.com/monitoring-mixins/website/blob/master/assets/couchbase/dashboards/couchbase-logs.json)
- [couchbase-node-overview](https://github.com/monitoring-mixins/website/blob/master/assets/couchbase/dashboards/couchbase-node-overview.json)
