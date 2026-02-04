---
title: mongodb-atlas
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/mongodb-atlas-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/mongodb-atlas/alerts.yaml).
{{< /panel >}}

### mongodb-atlas-alerts

##### MongoDBAtlasCollExclusiveDeadlocks

{{< code lang="yaml" >}}
alert: MongoDBAtlasCollExclusiveDeadlocks
annotations:
  description: The number of collection exclusive-lock deadlocks occurring on node
    {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%.0f" $value}}
    which is above the threshold of 10.
  summary: There is a high number of collection exclusive deadlocks occurring.
expr: |
  sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Collection_deadlockCount_W[5m])) > 10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MongoDBAtlasCollIntentExclDeadlocks

{{< code lang="yaml" >}}
alert: MongoDBAtlasCollIntentExclDeadlocks
annotations:
  description: The number of collection intent-exclusive-lock deadlocks occurring
    on node {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%.0f"
    $value}} which is above the threshold of 10.
  summary: There is a high number of collection intent-exclusive deadlocks occurring.
expr: |
  sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Collection_deadlockCount_w[5m])) > 10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MongoDBAtlasCollSharedDeadlocks

{{< code lang="yaml" >}}
alert: MongoDBAtlasCollSharedDeadlocks
annotations:
  description: The number of collection shared-lock deadlocks occurring on node {{$labels.instance}}
    in cluster {{$labels.cl_name}} is {{printf "%.0f" $value}} which is above the
    threshold of 10.
  summary: There is a high number of collection shared deadlocks occurring.
expr: |
  sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Collection_deadlockCount_R[5m])) > 10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MongoDBAtlasCollIntentSharedDeadlocks

{{< code lang="yaml" >}}
alert: MongoDBAtlasCollIntentSharedDeadlocks
annotations:
  description: The number of collection intent-shared-lock deadlocks occurring on
    node {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%.0f" $value}}
    which is above the threshold of 10.
  summary: There is a high number of collection intent-shared deadlocks occurring.
expr: |
  sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Collection_deadlockCount_r[5m])) > 10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MongoDBAtlasDBExclusiveDeadlocks

{{< code lang="yaml" >}}
alert: MongoDBAtlasDBExclusiveDeadlocks
annotations:
  description: The number of database exclusive-lock deadlocks occurring on node {{$labels.instance}}
    in cluster {{$labels.cl_name}} is {{printf "%.0f" $value}} which is above the
    threshold of 10.
  summary: There is a high number of database exclusive deadlocks occurring.
expr: |
  sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Database_deadlockCount_W[5m])) > 10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MongoDBAtlasDBIntentExclDeadlocks

{{< code lang="yaml" >}}
alert: MongoDBAtlasDBIntentExclDeadlocks
annotations:
  description: The number of database intent-exclusive-lock deadlocks occurring on
    node {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%.0f" $value}}
    which is above the threshold of 10.
  summary: There is a high number of database intent-exclusive deadlocks occurring.
expr: |
  sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Database_deadlockCount_w[5m])) > 10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MongoDBAtlasDBSharedDeadlocks

{{< code lang="yaml" >}}
alert: MongoDBAtlasDBSharedDeadlocks
annotations:
  description: The number of database shared-lock deadlocks occurring on node {{$labels.instance}}
    in cluster {{$labels.cl_name}} is {{printf "%.0f" $value}} which is above the
    threshold of 10.
  summary: There is a high number of database shared deadlocks occurring.
expr: |
  sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Database_deadlockCount_R[5m])) > 10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MongoDBAtlasDBIntentSharedDeadlocks

{{< code lang="yaml" >}}
alert: MongoDBAtlasDBIntentSharedDeadlocks
annotations:
  description: The number of database intent-shared-lock deadlocks occurring on node
    {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%.0f" $value}}
    which is above the threshold of 10.
  summary: There is a high number of database intent-shared deadlocks occurring.
expr: |
  sum without(cl_role,process_port,rs_nm,rs_state) (increase(mongodb_locks_Database_deadlockCount_r[5m])) > 10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MongoDBAtlasSlowNetworkRequests

{{< code lang="yaml" >}}
alert: MongoDBAtlasSlowNetworkRequests
annotations:
  description: The number of DNS and SSL operations taking more than 1 second to complete
    on node {{$labels.instance}} in cluster {{$labels.cl_name}} is {{printf "%.0f"
    $value}} which is above the threshold of 10.
  summary: There is a high number of slow network requests.
expr: |
  sum without (cl_role,rs_nm,rs_state,process_port) (increase(mongodb_network_numSlowSSLOperations[5m])) + sum without (cl_role,rs_nm,rs_state,process_port) (increase(mongodb_network_numSlowDNSOperations[5m])) > 10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MongoDBAtlasDiskSpaceLow

{{< code lang="yaml" >}}
alert: MongoDBAtlasDiskSpaceLow
annotations:
  description: The amount of hardware disk space being used on node {{$labels.instance}}
    in cluster {{$labels.cl_name}} is {{printf "%.0f" $value}}% which is above the
    threshold of 90%.
  summary: Hardware is running out of disk space.
expr: |
  100 * ((sum without (disk_name) (hardware_disk_metrics_disk_space_used_bytes)) / clamp_min((sum without (disk_name) (hardware_disk_metrics_disk_space_used_bytes)) + (sum without (disk_name) (hardware_disk_metrics_disk_space_free_bytes)), 1)) > 90
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MongoDBAtlasSlowHardwareIO

{{< code lang="yaml" >}}
alert: MongoDBAtlasSlowHardwareIO
annotations:
  description: The latency time for read and write I/Os on node {{$labels.instance}}
    in cluster {{$labels.cl_name}} is {{printf "%.0f" $value}} milliseconds which
    is above the threshold of 3000 milliseconds.
  summary: Read and write I/Os are taking too long to complete.
expr: |
  (sum without (disk_name) (increase(hardware_disk_metrics_read_time_milliseconds[5m])) + sum without (disk_name) (increase(hardware_disk_metrics_write_time_milliseconds[5m]))) > 3000
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MongoDBAtlasElectionTimeouts

{{< code lang="yaml" >}}
alert: MongoDBAtlasElectionTimeouts
annotations:
  description: The number of elections being called due to the primary node timing
    out in replica set {{$labels.rs_nm}} in cluster {{$labels.cl_name}} is {{printf
    "%.0f" $value}} which is above the threshold of 10.
  summary: There is a high number of elections being called due to the primary node
    timing out.
expr: |
  sum without (cl_role,process_port,instance,rs_state) (increase(mongodb_electionMetrics_electionTimeout_called[5m])) > 10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [mongodb-atlas-cluster-overview](https://github.com/monitoring-mixins/website/blob/master/assets/mongodb-atlas/dashboards/mongodb-atlas-cluster-overview.json)
- [mongodb-atlas-elections-overview](https://github.com/monitoring-mixins/website/blob/master/assets/mongodb-atlas/dashboards/mongodb-atlas-elections-overview.json)
- [mongodb-atlas-operations-overview](https://github.com/monitoring-mixins/website/blob/master/assets/mongodb-atlas/dashboards/mongodb-atlas-operations-overview.json)
- [mongodb-atlas-performance-overview](https://github.com/monitoring-mixins/website/blob/master/assets/mongodb-atlas/dashboards/mongodb-atlas-performance-overview.json)
- [mongodb-atlas-sharding-overview](https://github.com/monitoring-mixins/website/blob/master/assets/mongodb-atlas/dashboards/mongodb-atlas-sharding-overview.json)
