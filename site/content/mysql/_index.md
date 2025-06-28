---
title: mysql
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/prometheus/mysqld_exporter](https://github.com/prometheus/mysqld_exporter/tree/master/mysqld-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/mysql/alerts.yaml).
{{< /panel >}}

### MySQLdAlerts

##### MySQLDown

{{< code lang="yaml" >}}
alert: MySQLDown
annotations:
  description: MySQL {{$labels.job}} on {{$labels.instance}} is not up.
  summary: MySQL not up.
expr: mysql_up != 1
for: 5m
labels:
  severity: critical
{{< /code >}}
 
### GaleraAlerts

##### MySQLGaleraNotReady

{{< code lang="yaml" >}}
alert: MySQLGaleraNotReady
annotations:
  description: '{{$labels.job}} on {{$labels.instance}} is not ready.'
  summary: Galera cluster node not ready.
expr: mysql_global_status_wsrep_ready != 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MySQLGaleraOutOfSync

{{< code lang="yaml" >}}
alert: MySQLGaleraOutOfSync
annotations:
  description: '{{$labels.job}} on {{$labels.instance}} is not in sync ({{$value}}
    != 4).'
  summary: Galera cluster node out of sync.
expr: (mysql_global_status_wsrep_local_state != 4 and mysql_global_variables_wsrep_desync
  == 0)
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MySQLGaleraDonorFallingBehind

{{< code lang="yaml" >}}
alert: MySQLGaleraDonorFallingBehind
annotations:
  description: '{{$labels.job}} on {{$labels.instance}} is a donor (hotbackup) and
    is falling behind (queue size {{$value}}).'
  summary: XtraDB cluster donor node falling behind.
expr: (mysql_global_status_wsrep_local_state == 2 and mysql_global_status_wsrep_local_recv_queue
  > 100)
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### MySQLReplicationNotRunning

{{< code lang="yaml" >}}
alert: MySQLReplicationNotRunning
annotations:
  description: Replication on {{$labels.instance}} (IO or SQL) has been down for more
    than 2 minutes.
  summary: Replication is not running.
expr: mysql_slave_status_slave_io_running == 0 or mysql_slave_status_slave_sql_running
  == 0
for: 2m
labels:
  severity: critical
{{< /code >}}
 
##### MySQLReplicationLag

{{< code lang="yaml" >}}
alert: MySQLReplicationLag
annotations:
  description: Replication on {{$labels.instance}} has fallen behind and is not recovering.
  summary: MySQL slave replication is lagging.
expr: (instance:mysql_slave_lag_seconds > 30) and on(instance) (predict_linear(instance:mysql_slave_lag_seconds[5m],
  60 * 2) > 0)
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### MySQLHeartbeatLag

{{< code lang="yaml" >}}
alert: MySQLHeartbeatLag
annotations:
  description: The heartbeat is lagging on {{$labels.instance}} and is not recovering.
  summary: MySQL heartbeat is lagging.
expr: (instance:mysql_heartbeat_lag_seconds > 30) and on(instance) (predict_linear(instance:mysql_heartbeat_lag_seconds[5m],
  60 * 2) > 0)
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### MySQLInnoDBLogWaits

{{< code lang="yaml" >}}
alert: MySQLInnoDBLogWaits
annotations:
  description: The innodb logs are waiting for disk at a rate of {{$value}} / second
  summary: MySQL innodb log writes stalling.
expr: rate(mysql_global_status_innodb_log_waits[15m]) > 10
labels:
  severity: warning
{{< /code >}}
 
## Recording rules

{{< panel style="warning" >}}
Complete list of pregenerated recording rules is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/mysql/rules.yaml).
{{< /panel >}}

### mysqld_rules

##### instance:mysql_slave_lag_seconds

{{< code lang="yaml" >}}
expr: mysql_slave_status_seconds_behind_master - mysql_slave_status_sql_delay
record: instance:mysql_slave_lag_seconds
{{< /code >}}
 
##### instance:mysql_heartbeat_lag_seconds

{{< code lang="yaml" >}}
expr: mysql_heartbeat_now_timestamp_seconds - mysql_heartbeat_stored_timestamp_seconds
record: instance:mysql_heartbeat_lag_seconds
{{< /code >}}
 
##### job:mysql_transactions:rate5m

{{< code lang="yaml" >}}
expr: sum without (command) (rate(mysql_global_status_commands_total{command=~"(commit|rollback)"}[5m]))
record: job:mysql_transactions:rate5m
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [mysql-overview](https://github.com/monitoring-mixins/website/blob/master/assets/mysql/dashboards/mysql-overview.json)
