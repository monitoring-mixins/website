---
title: pgbouncer
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/pgbouncer-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/pgbouncer/alerts.yaml).
{{< /panel >}}

### pgbouncer

##### PGBouncerHighNumberClientWaitingConnections

{{< code lang="yaml" >}}
alert: PGBouncerHighNumberClientWaitingConnections
annotations:
  description: |
    The number of clients waiting for connections on {{ $labels.instance }} is now above 20. The current value is {{ $value | printf "%.2f" }}.
  summary: May indicate a bottleneck in connection pooling where too many clients
    are waiting for available server connections.
expr: |
  pgbouncer_pools_client_waiting_connections{job="integrations/pgbouncer"} > 20
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### PGBouncerHighClientWaitTime

{{< code lang="yaml" >}}
alert: PGBouncerHighClientWaitTime
annotations:
  description: |
    The wait time for user connections on {{ $labels.instance }}, is above 15. The current value is {{ $value | printf "%.2f" }}.
  summary: Clients are experiencing significant delays, which could indicate issues
    with connection pool saturation or server performance.
expr: |
  pgbouncer_pools_client_maxwait_seconds{job="integrations/pgbouncer"} > 15
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### PGBouncerHighServerConnectionSaturationWarning

{{< code lang="yaml" >}}
alert: PGBouncerHighServerConnectionSaturationWarning
annotations:
  description: |
    User connection capacity on {{ $labels.instance }}, is above 80%. The current value is {{ $value | printf "%.2f" }}.
  summary: PGBouncer is nearing user connection capacity.
expr: |
  100 * (sum without (database, user) (pgbouncer_pools_server_active_connections{job="integrations/pgbouncer"} + pgbouncer_pools_server_idle_connections{job="integrations/pgbouncer"} + pgbouncer_pools_server_used_connections{job="integrations/pgbouncer"}) / clamp_min(pgbouncer_config_max_user_connections{job="integrations/pgbouncer"},1)) > 80
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### PGBouncerHighServerConnectionSaturationCritical

{{< code lang="yaml" >}}
alert: PGBouncerHighServerConnectionSaturationCritical
annotations:
  description: |
    User connection capacity on {{ $labels.instance }}, is above 90%. The current value is {{ $value | printf "%.2f" }}.
  summary: PGBouncer is nearing critical levels of user connection capacity.
expr: |
  100 * (sum without (database, user) (pgbouncer_pools_server_active_connections{job="integrations/pgbouncer"} + pgbouncer_pools_server_idle_connections{job="integrations/pgbouncer"} + pgbouncer_pools_server_used_connections{job="integrations/pgbouncer"}) / clamp_min(pgbouncer_config_max_user_connections{job="integrations/pgbouncer"},1)) > 90
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [*](https://github.com/monitoring-mixins/website/blob/master/assets/pgbouncer/dashboards/*.json)
