---
title: clickhouse
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/clickhouse-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/clickhouse/alerts.yaml).
{{< /panel >}}

### ClickHouseAlerts

##### ClickHouseReplicationQueueBackingUp

{{< code lang="yaml" >}}
alert: ClickHouseReplicationQueueBackingUp
annotations:
  description: |
    ClickHouse replication tasks are processing slower than expected on {{ $labels.instance }} causing replication queue size to back up at {{ $value }} exceeding the threshold value of 99.
  summary: ClickHouse replica max queue size backing up.
expr: |
  ClickHouseAsyncMetrics_ReplicasMaxQueueSize > 99
for: 5m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ClickHouseRejectedInserts

{{< code lang="yaml" >}}
alert: ClickHouseRejectedInserts
annotations:
  description: ClickHouse inserts are being rejected on {{ $labels.instance }} as
    items are being inserted faster than ClickHouse is able to merge them.
  summary: ClickHouse has too many rejected inserts.
expr: ClickHouseProfileEvents_RejectedInserts > 1
for: 5m
keep_firing_for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ClickHouseZookeeperSessions

{{< code lang="yaml" >}}
alert: ClickHouseZookeeperSessions
annotations:
  description: |
    ClickHouse has more than one connection to a Zookeeper on {{ $labels.instance }} which can lead to bugs due to stale reads in Zookeepers consistency model.
  summary: ClickHouse has too many Zookeeper sessions.
expr: ClickHouseMetrics_ZooKeeperSession > 1
for: 5m
keep_firing_for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ClickHouseReplicasInReadOnly

{{< code lang="yaml" >}}
alert: ClickHouseReplicasInReadOnly
annotations:
  description: |
    ClickHouse has replicas in a read only state on {{ $labels.instance }} after losing connection to Zookeeper or at startup.
  summary: ClickHouse has too many replicas in read only state.
expr: ClickHouseMetrics_ReadonlyReplica > 0
for: 5m
keep_firing_for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [clickhouse-latency](https://github.com/monitoring-mixins/website/blob/master/assets/clickhouse/dashboards/clickhouse-latency.json)
- [clickhouse-logs](https://github.com/monitoring-mixins/website/blob/master/assets/clickhouse/dashboards/clickhouse-logs.json)
- [clickhouse-overview](https://github.com/monitoring-mixins/website/blob/master/assets/clickhouse/dashboards/clickhouse-overview.json)
- [clickhouse-replica](https://github.com/monitoring-mixins/website/blob/master/assets/clickhouse/dashboards/clickhouse-replica.json)
