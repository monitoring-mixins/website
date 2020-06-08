---
title: gluster
---

## Overview

A set of Grafana dashboards and Prometheus alerts for Gluster.

The scope of this project is to provide Gluster specific Grafana dashboard configs and Prometheus rule files using Prometheus Mixins.

{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/gluster/gluster-mixins](https://github.com/gluster/gluster-mixins)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/gluster/alerts.yaml).
{{< /panel >}}

### exporter-absent

##### GlusterExporterDown

{{< code lang="yaml" >}}
alert: GlusterExporterDown
annotations:
  message: GlusterExporter has disappeared from Prometheus target discovery.
expr: |
  absent(up{job="glusterd2-client"}==1)
for: 15m
labels:
  severity: critical
{{< /code >}}
 
### status-alert.rules

##### GlusterBrickStatus

{{< code lang="yaml" >}}
alert: GlusterBrickStatus
annotations:
  message: Gluster Brick {{$labels.hostname}}:{{$labels.brick_path}} is down.
expr: |
  gluster_brick_up{job="glusterd2-client"} == 0
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### GlusterVolumeStatus

{{< code lang="yaml" >}}
alert: GlusterVolumeStatus
annotations:
  message: Gluster Volume {{$labels.volume}} is down.
expr: |
  gluster_volume_up{job="glusterd2-client"} == 0
for: 1m
labels:
  severity: critical
{{< /code >}}
 
### gluster-utilization

##### GlusterVolumeUtilization

{{< code lang="yaml" >}}
alert: GlusterVolumeUtilization
annotations:
  message: Gluster Volume {{$labels.volume}} Utilization more than 80%
expr: |
  100 * gluster:volume_capacity_used_bytes_total:sum
      / gluster:volume_capacity_total_bytes:sum > 80
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### GlusterVolumeUtilization

{{< code lang="yaml" >}}
alert: GlusterVolumeUtilization
annotations:
  message: Gluster Volume {{$labels.volume}} Utilization more than 90%
expr: |
  100 * gluster:volume_capacity_used_bytes_total:sum
      / gluster:volume_capacity_total_bytes:sum > 90
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### GlusterBrickUtilization

{{< code lang="yaml" >}}
alert: GlusterBrickUtilization
annotations:
  message: Gluster Brick {{$labels.host}}:{{$labels.brick_path}} Utilization more than 80%
expr: |
  100 * gluster_brick_capacity_used_bytes{job="glusterd2-client"}
      / gluster_brick_capacity_bytes_total{job="glusterd2-client"} > 80
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### GlusterBrickUtilization

{{< code lang="yaml" >}}
alert: GlusterBrickUtilization
annotations:
  message: Gluster Brick {{$labels.host}}:{{$labels.brick_path}} Utilization more than 90%
expr: |
  100 * gluster_brick_capacity_used_bytes{job="glusterd2-client"}
      / gluster_brick_capacity_bytes_total{job="glusterd2-client"} > 90
for: 5m
labels:
  severity: critical
{{< /code >}}
 
### thinpool-utilization

##### GlusterThinpoolDataUtilization

{{< code lang="yaml" >}}
alert: GlusterThinpoolDataUtilization
annotations:
  message: Gluster Thinpool {{ $labels.thinpool_name }} Data Utilization more than 80%
expr: |
  gluster_thinpool_data_used_bytes{job="glusterd2-client"} / gluster_thinpool_data_total_bytes{job="glusterd2-client"} > 0.8
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### GlusterThinpoolDataUtilization

{{< code lang="yaml" >}}
alert: GlusterThinpoolDataUtilization
annotations:
  message: Gluster Thinpool {{ $labels.thinpool_name }} Data Utilization more than 90%
expr: |
  gluster_thinpool_data_used_bytes{job="glusterd2-client"} / gluster_thinpool_data_total_bytes{job="glusterd2-client"} > 0.9
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### GlusterThinpoolMetadataUtilization

{{< code lang="yaml" >}}
alert: GlusterThinpoolMetadataUtilization
annotations:
  message: Gluster Thinpool {{ $labels.thinpool_name }} Metadata Utilization more than 80%
expr: |
  gluster_thinpool_metadata_used_bytes{job="glusterd2-client"} / gluster_thinpool_metadata_total_bytes{job="glusterd2-client"} > 0.8
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### GlusterThinpoolMetadataUtilization

{{< code lang="yaml" >}}
alert: GlusterThinpoolMetadataUtilization
annotations:
  message: Gluster Thinpool {{ $labels.thinpool_name }} Metadata Utilization more than 90%
expr: |
  gluster_thinpool_metadata_used_bytes{job="glusterd2-client"} / gluster_thinpool_metadata_total_bytes{job="glusterd2-client"} > 0.9
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Recording rules

{{< panel style="warning" >}}
Complete list of pregenerated recording rules is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/gluster/rules.yaml).
{{< /panel >}}

### gluster-volume.rules

##### gluster:volume_capacity_used_bytes_total:sum

{{< code lang="yaml" >}}
expr: |
  sum(max(gluster_subvol_capacity_used_bytes{job="glusterd2-client"}) BY (volume, subvolume)) BY (volume)
record: gluster:volume_capacity_used_bytes_total:sum
{{< /code >}}
 
##### gluster:volume_capacity_total_bytes:sum

{{< code lang="yaml" >}}
expr: |
  sum(max(gluster_subvol_capacity_total_bytes{job="glusterd2-client"}) BY (volume, subvolume)) BY (volume)
record: gluster:volume_capacity_total_bytes:sum
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [k8s-storage-resources-glusterfs-pv](https://github.com/monitoring-mixins/website/blob/master/assets/gluster/dashboards/k8s-storage-resources-glusterfs-pv.json)
