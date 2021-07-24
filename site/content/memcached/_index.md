---
title: memcached
---

## Overview

Grafana dashboard for operating Memcached, in the form of a monitoring mixin.

{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/memcached-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/memcached/alerts.yaml).
{{< /panel >}}

### memcached

##### MemcachedDown

{{< code lang="yaml" >}}
alert: MemcachedDown
annotations:
  message: |
    Memcached Instance {{ $labels.job }} / {{ $labels.instance }} is down for more than 15mins.
expr: |
  memcached_up == 0
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### MemcachedConnectionLimitApproaching

{{< code lang="yaml" >}}
alert: MemcachedConnectionLimitApproaching
annotations:
  message: |
    Memcached Instance {{ $labels.job }} / {{ $labels.instance }} connection usage is at {{ printf "%0.0f" $value }}% for at least 15m.
expr: |
  (memcached_current_connections / memcached_max_connections * 100) > 80
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### MemcachedConnectionLimitApproaching

{{< code lang="yaml" >}}
alert: MemcachedConnectionLimitApproaching
annotations:
  message: |
    Memcached Instance {{ $labels.job }} / {{ $labels.instance }} connection usage is at {{ printf "%0.0f" $value }}% for at least 15m.
expr: |
  (memcached_current_connections / memcached_max_connections * 100) > 95
for: 15m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [memcached-overview](https://github.com/monitoring-mixins/website/blob/master/assets/memcached/dashboards/memcached-overview.json)
