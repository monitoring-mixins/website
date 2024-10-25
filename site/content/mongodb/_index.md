---
title: mongodb
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/mongodb-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/mongodb/alerts.yaml).
{{< /panel >}}

### MongodbAlerts

##### MongodbDown

{{< code lang="yaml" >}}
alert: MongodbDown
annotations:
  description: |-
    MongoDB instance is down
      VALUE = {{ $value }}
      LABELS = {{ $labels }}
  summary: MongoDB Instance is Down.
expr: mongodb_up == 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### MongodbReplicaMemberUnhealthy

{{< code lang="yaml" >}}
alert: MongodbReplicaMemberUnhealthy
annotations:
  description: Mongodb replica member unhealthy (instance {{ $labels.instance }})
  summary: MongoDB replica member unhealthy.
expr: mongodb_mongod_replset_member_health == 0
labels:
  severity: critical
{{< /code >}}
 
##### MongodbReplicationLag

{{< code lang="yaml" >}}
alert: MongodbReplicationLag
annotations:
  description: |-
    Mongodb replication lag is more than 10s
      VALUE = {{ $value }}
      LABELS = {{ $labels }}
  summary: MongoDB replication lag is exceeding the threshold.
expr: mongodb_mongod_replset_member_replication_lag{state="SECONDARY"} > 60
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### MongodbReplicationHeadroom

{{< code lang="yaml" >}}
alert: MongodbReplicationHeadroom
annotations:
  description: |-
    MongoDB replication headroom is <= 0
      VALUE = {{ $value }}
      LABELS = {{ $labels }}
  summary: MongoDB replication headroom is exceeding the threshold.
expr: (avg(mongodb_mongod_replset_oplog_tail_timestamp - mongodb_mongod_replset_oplog_head_timestamp)
  - (avg(mongodb_mongod_replset_member_optime_date{state="PRIMARY"}) - avg(mongodb_mongod_replset_member_optime_date{state="SECONDARY"})))
  <= 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### MongodbNumberCursorsOpen

{{< code lang="yaml" >}}
alert: MongodbNumberCursorsOpen
annotations:
  description: |-
    Too many cursors opened by MongoDB for clients (> 10k)
      VALUE = {{ $value }}
      LABELS = {{ $labels }}
  summary: MongoDB number cursors open too high.
expr: mongodb_mongod_metrics_cursor_open{state="total"} > 10 * 1000
for: 2m
labels:
  severity: warning
{{< /code >}}
 
##### MongodbCursorsTimeouts

{{< code lang="yaml" >}}
alert: MongodbCursorsTimeouts
annotations:
  description: |-
    Too many cursors are timing out
      VALUE = {{ $value }}
      LABELS = {{ $labels }}
  summary: MongoDB cursors timeouts is exceeding the threshold.
expr: increase(mongodb_mongod_metrics_cursor_timed_out_total[1m]) > 100
for: 2m
labels:
  severity: warning
{{< /code >}}
 
##### MongodbTooManyConnections

{{< code lang="yaml" >}}
alert: MongodbTooManyConnections
annotations:
  description: |-
    Too many connections (> 80%)
      VALUE = {{ $value }}
      LABELS = {{ $labels }}
  summary: MongoDB too many connections.
expr: avg by(instance) (rate(mongodb_connections{state="current"}[1m])) / avg by(instance)
  (sum (mongodb_connections) by (instance)) * 100 > 80
for: 2m
labels:
  severity: warning
{{< /code >}}
 
##### MongodbVirtualMemoryUsage

{{< code lang="yaml" >}}
alert: MongodbVirtualMemoryUsage
annotations:
  description: |-
    High memory usage
      VALUE = {{ $value }}
      LABELS = {{ $labels }}
  summary: MongoDB virtual memory usage is too high.
expr: (sum(mongodb_memory{type="virtual"}) BY (instance) / sum(mongodb_memory{type="mapped"})
  BY (instance)) > 3
for: 2m
labels:
  severity: warning
{{< /code >}}
 
##### MongodbReadRequestsQueueingUp

{{< code lang="yaml" >}}
alert: MongodbReadRequestsQueueingUp
annotations:
  description: |-
    MongoDB requests are queuing up
      VALUE = {{ $value }}
      LABELS = {{ $labels }}
  summary: MongoDB read requests queuing up.
expr: delta(mongodb_mongod_global_lock_current_queue{type="reader"}[1m]) > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MongodbWriteRequestsQueueingUp

{{< code lang="yaml" >}}
alert: MongodbWriteRequestsQueueingUp
annotations:
  description: |-
    MongoDB write requests are queueing up
      VALUE = {{ $value }}
      LABELS = {{ $labels }}
  summary: MongoDB write requests queuing up.
expr: delta(mongodb_mongod_global_lock_current_queue{type="writer"}[1m]) > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [MongoDB_Cluster](https://github.com/monitoring-mixins/website/blob/master/assets/mongodb/dashboards/MongoDB_Cluster.json)
- [MongoDB_Instance](https://github.com/monitoring-mixins/website/blob/master/assets/mongodb/dashboards/MongoDB_Instance.json)
- [MongoDB_ReplicaSet](https://github.com/monitoring-mixins/website/blob/master/assets/mongodb/dashboards/MongoDB_ReplicaSet.json)
