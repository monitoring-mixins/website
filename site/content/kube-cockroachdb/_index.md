---
title: kube-cockroachdb
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/metalmatze/kube-cockroachdb](https://github.com/metalmatze/kube-cockroachdb/tree/master/monitoring)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/kube-cockroachdb/alerts.yaml).
{{< /panel >}}

### cockroachdb

##### CockroachInstanceFlapping

{{< code lang="yaml" >}}
alert: CockroachInstanceFlapping
annotations:
  description: '{{ $labels.instance }} for cluster {{ $labels.cluster }} restarted
    {{ $value }} time(s) in 10m.'
  summary: CockroachDB instances have restarted in the last 10 minutes.
expr: |
  resets(cockroachdb_sys_uptime{job="cockroachdb-public"}[10m]) > 5
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### CockroachLivenessMismatch

{{< code lang="yaml" >}}
alert: CockroachLivenessMismatch
annotations:
  description: Liveness mismatch for {{ $labels.instance }}
  summary: CockroachDB has liveness mismatches.
expr: |
  (cockroachdb_liveness_livenodes{job="cockroachdb-public"})
    !=
  ignoring(instance) group_left() (count by(cluster, job) (up{job="cockroachdb-public"} == 1))
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### CockroachVersionMismatch

{{< code lang="yaml" >}}
alert: CockroachVersionMismatch
annotations:
  description: Cluster {{ $labels.cluster }} running {{ $value }} different versions
  summary: CockroachDB cluster is running different versions.
expr: |
  count by(cluster) (count_values by(tag, cluster) ("version", cockroachdb_build_timestamp{job="cockroachdb-public"})) > 1
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### CockroachStoreDiskLow

{{< code lang="yaml" >}}
alert: CockroachStoreDiskLow
annotations:
  description: Store {{ $labels.store }} on node {{ $labels.instance }} at {{ $value
    }} available disk fraction
  summary: CockroachDB is at low disk capacity.
expr: |
  :cockroachdb_capacity_available:ratio{job="cockroachdb-public"} < 0.15
for: 30m
labels:
  severity: critical
{{< /code >}}
 
##### CockroachClusterDiskLow

{{< code lang="yaml" >}}
alert: CockroachClusterDiskLow
annotations:
  description: Cluster {{ $labels.cluster }} at {{ $value }} available disk fraction
  summary: CockroachDB cluster is at critically low disk capacity.
expr: |
  cluster:cockroachdb_capacity_available:ratio{job="cockroachdb-public"} < 0.2
for: 30m
labels:
  severity: critical
{{< /code >}}
 
##### CockroachUnavailableRanges

{{< code lang="yaml" >}}
alert: CockroachUnavailableRanges
annotations:
  description: Instance {{ $labels.instance }} has {{ $value }} unavailable ranges
  summary: CockroachDB has unavailable ranges.
expr: |
  (sum by(instance, cluster) (cockroachdb_ranges_unavailable{job="cockroachdb-public"})) > 0
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### CockroachNoLeaseRanges

{{< code lang="yaml" >}}
alert: CockroachNoLeaseRanges
annotations:
  description: Instance {{ $labels.instance }} has {{ $value }} ranges without leases
  summary: CockroachDB has ranges without leases.
expr: |
  (sum by(instance, cluster) (cockroachdb_replicas_leaders_not_leaseholders{job="cockroachdb-public"})) > 0
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### CockroachHighOpenFDCount

{{< code lang="yaml" >}}
alert: CockroachHighOpenFDCount
annotations:
  description: 'Too many open file descriptors on {{ $labels.instance }}: {{ $value
    }} fraction used'
  summary: CockroachDB has too many open file descriptors.
expr: |
  cockroachdb_sys_fd_open{job="cockroachdb-public"} / cockroachdb_sys_fd_softlimit{job="cockroachdb-public"} > 0.8
for: 10m
labels:
  severity: warning
{{< /code >}}
 
## Recording rules

{{< panel style="warning" >}}
Complete list of pregenerated recording rules is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/kube-cockroachdb/rules.yaml).
{{< /panel >}}

### cockroachdb.rules

##### node:cockroachdb_capacity:sum

{{< code lang="yaml" >}}
expr: |
  sum without(store) (cockroachdb_capacity{job="cockroachdb-public"})
record: node:cockroachdb_capacity:sum
{{< /code >}}
 
##### cluster:cockroachdb_capacity:sum

{{< code lang="yaml" >}}
expr: |
  sum without(instance) (node:cockroachdb_capacity:sum{job="cockroachdb-public"})
record: cluster:cockroachdb_capacity:sum
{{< /code >}}
 
##### node:cockroachdb_capacity_available:sum

{{< code lang="yaml" >}}
expr: |
  sum without(store) (cockroachdb_capacity_available{job="cockroachdb-public"})
record: node:cockroachdb_capacity_available:sum
{{< /code >}}
 
##### cluster:cockroachdb_capacity_available:sum

{{< code lang="yaml" >}}
expr: |
  sum without(instance) (node:cockroachdb_capacity_available:sum{job="cockroachdb-public"})
record: cluster:cockroachdb_capacity_available:sum
{{< /code >}}
 
##### :cockroachdb_capacity_available:ratio

{{< code lang="yaml" >}}
expr: |
  cockroachdb_capacity_available{job="cockroachdb-public"} / cockroachdb_capacity{job="cockroachdb-public"}
record: :cockroachdb_capacity_available:ratio
{{< /code >}}
 
##### node:cockroachdb_capacity_available:ratio

{{< code lang="yaml" >}}
expr: |
  node:cockroachdb_capacity_available:sum{job="cockroachdb-public"} / node:cockroachdb_capacity:sum{job="cockroachdb-public"}
record: node:cockroachdb_capacity_available:ratio
{{< /code >}}
 
##### cluster:cockroachdb_capacity_available:ratio

{{< code lang="yaml" >}}
expr: |
  cluster:cockroachdb_capacity_available:sum{job="cockroachdb-public"} / cluster:cockroachdb_capacity:sum{job="cockroachdb-public"}
record: cluster:cockroachdb_capacity_available:ratio
{{< /code >}}
 
