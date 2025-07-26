---
title: postgres-exporter
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/prometheus-community/postgres_exporter](https://github.com/prometheus-community/postgres_exporter/tree/master/postgres_mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/postgres-exporter/alerts.yaml).
{{< /panel >}}

### PostgreSQL

##### PostgreSQLMaxConnectionsReached

{{< code lang="yaml" >}}
alert: PostgreSQLMaxConnectionsReached
annotations:
  description: '{{ $labels.instance }} is exceeding the currently configured maximum
    Postgres connection limit (current value: {{ $value }}s). Services may be degraded
    - please take immediate action (you probably need to increase max_connections
    in the Docker image and re-deploy).'
  summary: Postgres connections count is over the maximum amount.
expr: |
  sum by (job, instance, server) (pg_stat_activity_count{})
  >=
  sum by (job, instance, server) (pg_settings_max_connections{})
  -
  sum by (job, instance, server) (pg_settings_superuser_reserved_connections{})
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### PostgreSQLHighConnections

{{< code lang="yaml" >}}
alert: PostgreSQLHighConnections
annotations:
  description: '{{ $labels.instance }} is exceeding 80% of the currently configured
    maximum Postgres connection limit (current value: {{ $value }}s). Please check
    utilization graphs and confirm if this is normal service growth, abuse or an otherwise
    temporary condition or if new resources need to be provisioned (or the limits
    increased, which is mostly likely).'
  summary: Postgres connections count is over 80% of maximum amount.
expr: |
  sum by (job, instance, server) (pg_stat_activity_count{})
  >
  (
    sum by (job, instance, server) (pg_settings_max_connections{})
    -
    sum by (job, instance, server) (pg_settings_superuser_reserved_connections{})
  ) * 0.8
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### PostgreSQLDown

{{< code lang="yaml" >}}
alert: PostgreSQLDown
annotations:
  description: '{{ $labels.instance }} is rejecting query requests from the exporter,
    and thus probably not allowing DNS requests to work either. User services should
    not be effected provided at least 1 node is still alive.'
  summary: PostgreSQL is not processing queries.
expr: pg_up{} != 1
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### PostgreSQLSlowQueries

{{< code lang="yaml" >}}
alert: PostgreSQLSlowQueries
annotations:
  description: 'PostgreSQL high number of slow queries {{ $labels.cluster }} for database
    {{ $labels.datname }} with a value of {{ $value }} '
  summary: PostgreSQL high number of slow queries.
expr: |
  avg by (datname, job, instance, server) (
    rate (
      pg_stat_activity_max_tx_duration{datname!~"template.*", }[2m]
    )
  ) > 2 * 60
for: 2m
labels:
  severity: warning
{{< /code >}}
 
##### PostgreSQLQPS

{{< code lang="yaml" >}}
alert: PostgreSQLQPS
annotations:
  description: PostgreSQL high number of queries per second on {{ $labels.cluster
    }} for database {{ $labels.datname }} with a value of {{ $value }}
  summary: PostgreSQL high number of queries per second.
expr: |
  avg by (datname, job, instance, server) (
    irate(
      pg_stat_database_xact_commit{datname!~"template.*", }[5m]
    )
    +
    irate(
      pg_stat_database_xact_rollback{datname!~"template.*", }[5m]
    )
  ) > 10000
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### PostgreSQLCacheHitRatio

{{< code lang="yaml" >}}
alert: PostgreSQLCacheHitRatio
annotations:
  description: PostgreSQL low on cache hit rate on {{ $labels.cluster }} for database
    {{ $labels.datname }} with a value of {{ $value }}
  summary: PostgreSQL low cache hit rate.
expr: |
  avg by (datname, job, instance, server) (
    rate(pg_stat_database_blks_hit{datname!~"template.*", }[5m])
    /
    (
      rate(
        pg_stat_database_blks_hit{datname!~"template.*", }[5m]
      )
      +
      rate(
        pg_stat_database_blks_read{datname!~"template.*", }[5m]
      )
    )
  ) < 0.98
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### PostgresHasTooManyRollbacks

{{< code lang="yaml" >}}
alert: PostgresHasTooManyRollbacks
annotations:
  description: PostgreSQL has too many rollbacks on {{ $labels.cluster }} for database
    {{ $labels.datname }} with a value of {{ $value }}
  summary: PostgreSQL has too many rollbacks.
expr: |
  avg without(pod, instance)
  (rate(pg_stat_database_xact_rollback{datname!~"template.*"}[5m]) /
  (rate(pg_stat_database_xact_commit{datname!~"template.*"}[5m]) + rate(pg_stat_database_xact_rollback{datname!~"template.*"}[5m]))) > 0.10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### PostgresHasHighDeadLocks

{{< code lang="yaml" >}}
alert: PostgresHasHighDeadLocks
annotations:
  description: PostgreSQL has too high deadlocks on {{ $labels.cluster }} for database
    {{ $labels.datname }} with a value of {{ $value }}
  summary: PostgreSQL has high number of deadlocks.
expr: |
  max without(pod, instance) (rate(pg_stat_database_deadlocks{datname!~"template.*"}[5m]) * 60) > 5
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### PostgresAcquiredTooManyLocks

{{< code lang="yaml" >}}
alert: PostgresAcquiredTooManyLocks
annotations:
  description: PostgreSQL has acquired too many locks on {{ $labels.cluster }} for
    database {{ $labels.datname }} with a value of {{ $value }}
  summary: PostgreSQL has high number of acquired locks.
expr: "max by(datname, job,instance,server) (
  (pg_locks_count{datname!~\"template.*\"})
  
  /
  on(job,instance) group_left(server) (
    pg_settings_max_locks_per_transaction{}
  * pg_settings_max_connections{}
  )
) > 0.20
"
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### PostgresReplicationLaggingMore1Hour

{{< code lang="yaml" >}}
alert: PostgresReplicationLaggingMore1Hour
annotations:
  description: '{{ $labels.instance }} replication lag exceeds 1 hour. Check for network
    issues or load imbalances.'
  summary: PostgreSQL replication lagging more than 1 hour.
expr: |
  (pg_replication_lag{} > 3600) and on (job, instance, server) (pg_replication_is_replica{} == 1)
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### PostgresHasReplicationSlotUsed

{{< code lang="yaml" >}}
alert: PostgresHasReplicationSlotUsed
annotations:
  description: '{{ $labels.instance }} has replication slots that are not used, which
    might lead to replication lag or data inconsistency.'
  summary: PostgreSQL has unused replication slots.
expr: pg_replication_slots_active{} == 0
for: 30m
labels:
  severity: critical
{{< /code >}}
 
##### PostgresReplicationRoleChanged

{{< code lang="yaml" >}}
alert: PostgresReplicationRoleChanged
annotations:
  description: '{{ $labels.instance }} replication role has changed. Verify if this
    is expected or if it indicates a failover.'
  summary: PostgreSQL replication role change detected.
expr: pg_replication_is_replica{} and changes(pg_replication_is_replica{}[1m]) > 0
labels:
  severity: warning
{{< /code >}}
 
##### PostgresHasExporterErrors

{{< code lang="yaml" >}}
alert: PostgresHasExporterErrors
annotations:
  description: '{{ $labels.instance }} exporter is experiencing errors. Verify exporter
    health and configuration.'
  summary: PostgreSQL exporter errors detected.
expr: pg_exporter_last_scrape_error{} > 0
for: 30m
labels:
  severity: critical
{{< /code >}}
 
##### PostgresTablesNotVaccumed

{{< code lang="yaml" >}}
alert: PostgresTablesNotVaccumed
annotations:
  description: '{{ $labels.instance }} tables have not been vacuumed recently within
    the last hour, which may lead to performance degradation.'
  summary: PostgreSQL tables not vacuumed.
expr: |
  group without(pod, instance)(
    timestamp(
      pg_stat_user_tables_n_dead_tup{} >
        pg_stat_user_tables_n_live_tup{}
          * on(job, instance, server) group_left pg_settings_autovacuum_vacuum_scale_factor{}
          + on(job, instance, server) group_left pg_settings_autovacuum_vacuum_threshold{}
    )
    < time() - 36000
  )
for: 30m
labels:
  severity: critical
{{< /code >}}
 
##### PostgresTooManyCheckpointsRequested

{{< code lang="yaml" >}}
alert: PostgresTooManyCheckpointsRequested
annotations:
  description: '{{ $labels.instance }} is requesting too many checkpoints, which may
    lead to performance degradation.'
  summary: PostgreSQL too many checkpoints requested.
expr: |
  rate(pg_stat_bgwriter_checkpoints_timed_total{}[5m]) /
  (rate(pg_stat_bgwriter_checkpoints_timed_total{}[5m]) + rate(pg_stat_bgwriter_checkpoints_req_total{}[5m]))
  < 0.5
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [postgres-overview](https://github.com/monitoring-mixins/website/blob/master/assets/postgres-exporter/dashboards/postgres-overview.json)
