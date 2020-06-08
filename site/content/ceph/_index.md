---
title: ceph
---

## Overview

A set of Prometheus alerts for Ceph.

The scope of this project is to provide Ceph specific Prometheus rule files using Prometheus Mixins.

{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/ceph/ceph-mixins](https://github.com/ceph/ceph-mixins)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/ceph/alerts.yaml).
{{< /panel >}}

### ceph-mgr-status

##### CephMgrIsAbsent

{{< code lang="yaml" >}}
alert: CephMgrIsAbsent
annotations:
  description: Ceph Manager has disappeared from Prometheus target discovery.
  message: Storage metrics collector service not available anymore.
  severity_level: critical
  storage_type: ceph
expr: |
  absent(up{job="rook-ceph-mgr"} == 1)
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CephMgrIsMissingReplicas

{{< code lang="yaml" >}}
alert: CephMgrIsMissingReplicas
annotations:
  description: Ceph Manager is missing replicas.
  message: Storage metrics collector service doesn't have required no of replicas.
  severity_level: warning
  storage_type: ceph
expr: |
  sum(up{job="rook-ceph-mgr"}) < 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
### ceph-mds-status

##### CephMdsMissingReplicas

{{< code lang="yaml" >}}
alert: CephMdsMissingReplicas
annotations:
  description: Minimum required replicas for storage metadata service not available. Might affect the working of storage cluster.
  message: Insufficient replicas for storage metadata service.
  severity_level: warning
  storage_type: ceph
expr: |
  sum(ceph_mds_metadata{job="rook-ceph-mgr"} == 1) < 2
for: 5m
labels:
  severity: warning
{{< /code >}}
 
### quorum-alert.rules

##### CephMonQuorumAtRisk

{{< code lang="yaml" >}}
alert: CephMonQuorumAtRisk
annotations:
  description: Storage cluster quorum is low. Contact Support.
  message: Storage quorum at risk
  severity_level: error
  storage_type: ceph
expr: |
  count(ceph_mon_quorum_status{job="rook-ceph-mgr"} == 1) <= ((count(ceph_mon_metadata{job="rook-ceph-mgr"}) % 2) + 1)
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### CephMonHighNumberOfLeaderChanges

{{< code lang="yaml" >}}
alert: CephMonHighNumberOfLeaderChanges
annotations:
  description: Ceph Monitor {{ $labels.ceph_daemon }} on host {{ $labels.hostname }} has seen {{ $value | printf "%.2f" }} leader changes per minute recently.
  message: Storage Cluster has seen many leader changes recently.
  severity_level: warning
  storage_type: ceph
expr: |
  (ceph_mon_metadata{job="rook-ceph-mgr"} * on (ceph_daemon) group_left() (rate(ceph_mon_num_elections{job="rook-ceph-mgr"}[5m]) * 60)) > 0.95
for: 5m
labels:
  severity: warning
{{< /code >}}
 
### ceph-node-alert.rules

##### CephNodeDown

{{< code lang="yaml" >}}
alert: CephNodeDown
annotations:
  description: Storage node {{ $labels.node }} went down. Please check the node immediately.
  message: Storage node {{ $labels.node }} went down
  severity_level: error
  storage_type: ceph
expr: |
  cluster:ceph_node_down:join_kube == 0
for: 30s
labels:
  severity: critical
{{< /code >}}
 
### osd-alert.rules

##### CephOSDCriticallyFull

{{< code lang="yaml" >}}
alert: CephOSDCriticallyFull
annotations:
  description: Utilization of back-end storage device {{ $labels.ceph_daemon }} has crossed 85% on host {{ $labels.hostname }}. Immediately free up some space or expand the storage cluster or contact support.
  message: Back-end storage device is critically full.
  severity_level: error
  storage_type: ceph
expr: |
  (ceph_osd_metadata * on (ceph_daemon) group_left() (ceph_osd_stat_bytes_used / ceph_osd_stat_bytes)) >= 0.85
for: 40s
labels:
  severity: critical
{{< /code >}}
 
##### CephOSDNearFull

{{< code lang="yaml" >}}
alert: CephOSDNearFull
annotations:
  description: Utilization of back-end storage device {{ $labels.ceph_daemon }} has crossed 75% on host {{ $labels.hostname }}. Free up some space or expand the storage cluster or contact support.
  message: Back-end storage device is nearing full.
  severity_level: warning
  storage_type: ceph
expr: |
  (ceph_osd_metadata * on (ceph_daemon) group_left() (ceph_osd_stat_bytes_used / ceph_osd_stat_bytes)) >= 0.75
for: 40s
labels:
  severity: warning
{{< /code >}}
 
##### CephOSDDiskNotResponding

{{< code lang="yaml" >}}
alert: CephOSDDiskNotResponding
annotations:
  description: Disk device {{ $labels.device }} not responding, on host {{ $labels.host }}.
  message: Disk not responding
  severity_level: error
  storage_type: ceph
expr: |
  label_replace((ceph_osd_in == 1 and ceph_osd_up == 0),"disk","$1","ceph_daemon","osd.(.*)") + on(ceph_daemon) group_left(host, device) label_replace(ceph_disk_occupation,"host","$1","exported_instance","(.*)")
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### CephOSDDiskUnavailable

{{< code lang="yaml" >}}
alert: CephOSDDiskUnavailable
annotations:
  description: Disk device {{ $labels.device }} not accessible on host {{ $labels.host }}.
  message: Disk not accessible
  severity_level: error
  storage_type: ceph
expr: |
  label_replace((ceph_osd_in == 0 and ceph_osd_up == 0),"disk","$1","ceph_daemon","osd.(.*)") + on(ceph_daemon) group_left(host, device) label_replace(ceph_disk_occupation,"host","$1","exported_instance","(.*)")
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### CephDataRecoveryTakingTooLong

{{< code lang="yaml" >}}
alert: CephDataRecoveryTakingTooLong
annotations:
  description: Data recovery has been active for too long. Contact Support.
  message: Data recovery is slow
  severity_level: warning
  storage_type: ceph
expr: |
  ceph_pg_undersized > 0
for: 2h
labels:
  severity: warning
{{< /code >}}
 
##### CephPGRepairTakingTooLong

{{< code lang="yaml" >}}
alert: CephPGRepairTakingTooLong
annotations:
  description: Self heal operations taking too long. Contact Support.
  message: Self heal problems detected
  severity_level: warning
  storage_type: ceph
expr: |
  ceph_pg_inconsistent > 0
for: 1h
labels:
  severity: warning
{{< /code >}}
 
### cluster-state-alert.rules

##### CephClusterErrorState

{{< code lang="yaml" >}}
alert: CephClusterErrorState
annotations:
  description: Storage cluster is in error state for more than 10m.
  message: Storage cluster is in error state
  severity_level: error
  storage_type: ceph
expr: |
  ceph_health_status{job="rook-ceph-mgr"} > 1
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### CephClusterWarningState

{{< code lang="yaml" >}}
alert: CephClusterWarningState
annotations:
  description: Storage cluster is in warning state for more than 10m.
  message: Storage cluster is in degraded state
  severity_level: warning
  storage_type: ceph
expr: |
  ceph_health_status{job="rook-ceph-mgr"} == 1
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### CephOSDVersionMismatch

{{< code lang="yaml" >}}
alert: CephOSDVersionMismatch
annotations:
  description: There are {{ $value }} different versions of Ceph OSD components running.
  message: There are multiple versions of storage services running.
  severity_level: warning
  storage_type: ceph
expr: |
  count(count(ceph_osd_metadata{job="rook-ceph-mgr"}) by (ceph_version)) > 1
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### CephMonVersionMismatch

{{< code lang="yaml" >}}
alert: CephMonVersionMismatch
annotations:
  description: There are {{ $value }} different versions of Ceph Mon components running.
  message: There are multiple versions of storage services running.
  severity_level: warning
  storage_type: ceph
expr: |
  count(count(ceph_mon_metadata{job="rook-ceph-mgr"}) by (ceph_version)) > 1
for: 10m
labels:
  severity: warning
{{< /code >}}
 
### cluster-utilization-alert.rules

##### CephClusterNearFull

{{< code lang="yaml" >}}
alert: CephClusterNearFull
annotations:
  description: Storage cluster utilization has crossed 75%. Free up some space or expand the storage cluster.
  message: Storage cluster is nearing full. Data deletion or cluster expansion is required.
  severity_level: warning
  storage_type: ceph
expr: |
  sum(ceph_osd_stat_bytes_used) / sum(ceph_osd_stat_bytes) > 0.75
for: 30s
labels:
  severity: warning
{{< /code >}}
 
##### CephClusterCriticallyFull

{{< code lang="yaml" >}}
alert: CephClusterCriticallyFull
annotations:
  description: Storage cluster utilization has crossed 85%. Free up some space or expand the storage cluster immediately.
  message: Storage cluster is critically full and needs immediate data deletion or cluster expansion.
  severity_level: error
  storage_type: ceph
expr: |
  sum(ceph_osd_stat_bytes_used) / sum(ceph_osd_stat_bytes) > 0.85
for: 30s
labels:
  severity: critical
{{< /code >}}
 
## Recording rules

{{< panel style="warning" >}}
Complete list of pregenerated recording rules is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/ceph/rules.yaml).
{{< /panel >}}

### ceph.rules

##### cluster:ceph_node_down:join_kube

{{< code lang="yaml" >}}
expr: |
  kube_node_status_condition{condition="Ready",job="kube-state-metrics",status="true"} * on (node) group_right() max(label_replace(ceph_disk_occupation{job="rook-ceph-mgr"},"node","$1","exported_instance","(.*)")) by (node)
record: cluster:ceph_node_down:join_kube
{{< /code >}}
 
##### cluster:ceph_disk_latency:join_ceph_node_disk_irate1m

{{< code lang="yaml" >}}
expr: |
  avg(max by(instance) (label_replace(label_replace(ceph_disk_occupation{job="rook-ceph-mgr"}, "instance", "$1", "exported_instance", "(.*)"), "device", "$1", "device", "/dev/(.*)") * on(instance, device) group_right() (irate(node_disk_read_time_seconds_total[1m]) + irate(node_disk_write_time_seconds_total[1m]) / (clamp_min(irate(node_disk_reads_completed_total[1m]), 1) + irate(node_disk_writes_completed_total[1m])))))
record: cluster:ceph_disk_latency:join_ceph_node_disk_irate1m
{{< /code >}}
 
### telemeter.rules

##### job:ceph_osd_metadata:count

{{< code lang="yaml" >}}
expr: |
  count(ceph_osd_metadata{job="rook-ceph-mgr"})
record: job:ceph_osd_metadata:count
{{< /code >}}
 
##### job:kube_pv:count

{{< code lang="yaml" >}}
expr: |
  count(kube_persistentvolume_info)
record: job:kube_pv:count
{{< /code >}}
 
##### job:ceph_pools_iops:total

{{< code lang="yaml" >}}
expr: |
  sum(ceph_pool_rd{job="rook-ceph-mgr"}+ ceph_pool_wr{job="rook-ceph-mgr"})
record: job:ceph_pools_iops:total
{{< /code >}}
 
##### job:ceph_pools_iops_bytes:total

{{< code lang="yaml" >}}
expr: |
  sum(ceph_pool_rd_bytes{job="rook-ceph-mgr"}+ ceph_pool_wr_bytes{job="rook-ceph-mgr"})
record: job:ceph_pools_iops_bytes:total
{{< /code >}}
 
##### job:ceph_versions_running:count

{{< code lang="yaml" >}}
expr: |
  count(count(ceph_mon_metadata{job="rook-ceph-mgr"} or ceph_osd_metadata{job="rook-ceph-mgr"} or ceph_rgw_metadata{job="rook-ceph-mgr"} or ceph_mds_metadata{job="rook-ceph-mgr"} or ceph_mgr_metadata{job="rook-ceph-mgr"}) by(ceph_version))
record: job:ceph_versions_running:count
{{< /code >}}
 
