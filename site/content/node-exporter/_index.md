---
title: node-exporter
---

## Overview

The Node Mixin is a set of configurable, reusable, and extensible alerts and dashboards based on the metrics exported by the Node Exporter. The mixin creates recording and alerting rules for Prometheus and suitable dashboard descriptions for Grafana.

{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/prometheus/node_exporter](https://github.com/prometheus/node_exporter/tree/master/docs/node-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/node-exporter/alerts.yaml).
{{< /panel >}}

### node-exporter

##### NodeFilesystemSpaceFillingUp

{{< code lang="yaml" >}}
alert: NodeFilesystemSpaceFillingUp
annotations:
  description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available space left and is filling up.
  summary: Filesystem is predicted to run out of space within the next 24 hours.
expr: |
  (
    node_filesystem_avail_bytes{job="node",fstype!=""} / node_filesystem_size_bytes{job="node",fstype!=""} * 100 < 40
  and
    predict_linear(node_filesystem_avail_bytes{job="node",fstype!=""}[6h], 24*60*60) < 0
  and
    node_filesystem_readonly{job="node",fstype!=""} == 0
  )
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### NodeFilesystemSpaceFillingUp

{{< code lang="yaml" >}}
alert: NodeFilesystemSpaceFillingUp
annotations:
  description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available space left and is filling up fast.
  summary: Filesystem is predicted to run out of space within the next 4 hours.
expr: |
  (
    node_filesystem_avail_bytes{job="node",fstype!=""} / node_filesystem_size_bytes{job="node",fstype!=""} * 100 < 20
  and
    predict_linear(node_filesystem_avail_bytes{job="node",fstype!=""}[6h], 4*60*60) < 0
  and
    node_filesystem_readonly{job="node",fstype!=""} == 0
  )
for: 1h
labels:
  severity: critical
{{< /code >}}
 
##### NodeFilesystemAlmostOutOfSpace

{{< code lang="yaml" >}}
alert: NodeFilesystemAlmostOutOfSpace
annotations:
  description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available space left.
  summary: Filesystem has less than 5% space left.
expr: |
  (
    node_filesystem_avail_bytes{job="node",fstype!=""} / node_filesystem_size_bytes{job="node",fstype!=""} * 100 < 5
  and
    node_filesystem_readonly{job="node",fstype!=""} == 0
  )
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### NodeFilesystemAlmostOutOfSpace

{{< code lang="yaml" >}}
alert: NodeFilesystemAlmostOutOfSpace
annotations:
  description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available space left.
  summary: Filesystem has less than 3% space left.
expr: |
  (
    node_filesystem_avail_bytes{job="node",fstype!=""} / node_filesystem_size_bytes{job="node",fstype!=""} * 100 < 3
  and
    node_filesystem_readonly{job="node",fstype!=""} == 0
  )
for: 1h
labels:
  severity: critical
{{< /code >}}
 
##### NodeFilesystemFilesFillingUp

{{< code lang="yaml" >}}
alert: NodeFilesystemFilesFillingUp
annotations:
  description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available inodes left and is filling up.
  summary: Filesystem is predicted to run out of inodes within the next 24 hours.
expr: |
  (
    node_filesystem_files_free{job="node",fstype!=""} / node_filesystem_files{job="node",fstype!=""} * 100 < 40
  and
    predict_linear(node_filesystem_files_free{job="node",fstype!=""}[6h], 24*60*60) < 0
  and
    node_filesystem_readonly{job="node",fstype!=""} == 0
  )
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### NodeFilesystemFilesFillingUp

{{< code lang="yaml" >}}
alert: NodeFilesystemFilesFillingUp
annotations:
  description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available inodes left and is filling up fast.
  summary: Filesystem is predicted to run out of inodes within the next 4 hours.
expr: |
  (
    node_filesystem_files_free{job="node",fstype!=""} / node_filesystem_files{job="node",fstype!=""} * 100 < 20
  and
    predict_linear(node_filesystem_files_free{job="node",fstype!=""}[6h], 4*60*60) < 0
  and
    node_filesystem_readonly{job="node",fstype!=""} == 0
  )
for: 1h
labels:
  severity: critical
{{< /code >}}
 
##### NodeFilesystemAlmostOutOfFiles

{{< code lang="yaml" >}}
alert: NodeFilesystemAlmostOutOfFiles
annotations:
  description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available inodes left.
  summary: Filesystem has less than 5% inodes left.
expr: |
  (
    node_filesystem_files_free{job="node",fstype!=""} / node_filesystem_files{job="node",fstype!=""} * 100 < 5
  and
    node_filesystem_readonly{job="node",fstype!=""} == 0
  )
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### NodeFilesystemAlmostOutOfFiles

{{< code lang="yaml" >}}
alert: NodeFilesystemAlmostOutOfFiles
annotations:
  description: Filesystem on {{ $labels.device }} at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available inodes left.
  summary: Filesystem has less than 3% inodes left.
expr: |
  (
    node_filesystem_files_free{job="node",fstype!=""} / node_filesystem_files{job="node",fstype!=""} * 100 < 3
  and
    node_filesystem_readonly{job="node",fstype!=""} == 0
  )
for: 1h
labels:
  severity: critical
{{< /code >}}
 
##### NodeNetworkReceiveErrs

{{< code lang="yaml" >}}
alert: NodeNetworkReceiveErrs
annotations:
  description: '{{ $labels.instance }} interface {{ $labels.device }} has encountered {{ printf "%.0f" $value }} receive errors in the last two minutes.'
  summary: Network interface is reporting many receive errors.
expr: |
  increase(node_network_receive_errs_total[2m]) > 10
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### NodeNetworkTransmitErrs

{{< code lang="yaml" >}}
alert: NodeNetworkTransmitErrs
annotations:
  description: '{{ $labels.instance }} interface {{ $labels.device }} has encountered {{ printf "%.0f" $value }} transmit errors in the last two minutes.'
  summary: Network interface is reporting many transmit errors.
expr: |
  increase(node_network_transmit_errs_total[2m]) > 10
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### NodeHighNumberConntrackEntriesUsed

{{< code lang="yaml" >}}
alert: NodeHighNumberConntrackEntriesUsed
annotations:
  description: '{{ $value | humanizePercentage }} of conntrack entries are used.'
  summary: Number of conntrack are getting close to the limit.
expr: |
  (node_nf_conntrack_entries / node_nf_conntrack_entries_limit) > 0.75
labels:
  severity: warning
{{< /code >}}
 
##### NodeTextFileCollectorScrapeError

{{< code lang="yaml" >}}
alert: NodeTextFileCollectorScrapeError
annotations:
  description: Node Exporter text file collector failed to scrape.
  summary: Node Exporter text file collector failed to scrape.
expr: |
  node_textfile_scrape_error{job="node"} == 1
labels:
  severity: warning
{{< /code >}}
 
##### NodeClockSkewDetected

{{< code lang="yaml" >}}
alert: NodeClockSkewDetected
annotations:
  message: Clock on {{ $labels.instance }} is out of sync by more than 300s. Ensure NTP is configured correctly on this host.
  summary: Clock skew detected.
expr: |
  (
    node_timex_offset_seconds > 0.05
  and
    deriv(node_timex_offset_seconds[5m]) >= 0
  )
  or
  (
    node_timex_offset_seconds < -0.05
  and
    deriv(node_timex_offset_seconds[5m]) <= 0
  )
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### NodeClockNotSynchronising

{{< code lang="yaml" >}}
alert: NodeClockNotSynchronising
annotations:
  message: Clock on {{ $labels.instance }} is not synchronising. Ensure NTP is configured on this host.
  summary: Clock not synchronising.
expr: |
  min_over_time(node_timex_sync_status[5m]) == 0
for: 10m
labels:
  severity: warning
{{< /code >}}
 
## Recording rules

{{< panel style="warning" >}}
Complete list of pregenerated recording rules is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/node-exporter/rules.yaml).
{{< /panel >}}

### node-exporter.rules

##### instance:node_num_cpu:sum

{{< code lang="yaml" >}}
expr: |
  count without (cpu) (
    count without (mode) (
      node_cpu_seconds_total{job="node"}
    )
  )
record: instance:node_num_cpu:sum
{{< /code >}}
 
##### instance:node_cpu_utilisation:rate1m

{{< code lang="yaml" >}}
expr: |
  1 - avg without (cpu, mode) (
    rate(node_cpu_seconds_total{job="node", mode="idle"}[1m])
  )
record: instance:node_cpu_utilisation:rate1m
{{< /code >}}
 
##### instance:node_load1_per_cpu:ratio

{{< code lang="yaml" >}}
expr: |
  (
    node_load1{job="node"}
  /
    instance:node_num_cpu:sum{job="node"}
  )
record: instance:node_load1_per_cpu:ratio
{{< /code >}}
 
##### instance:node_memory_utilisation:ratio

{{< code lang="yaml" >}}
expr: |
  1 - (
    node_memory_MemAvailable_bytes{job="node"}
  /
    node_memory_MemTotal_bytes{job="node"}
  )
record: instance:node_memory_utilisation:ratio
{{< /code >}}
 
##### instance:node_vmstat_pgmajfault:rate1m

{{< code lang="yaml" >}}
expr: |
  rate(node_vmstat_pgmajfault{job="node"}[1m])
record: instance:node_vmstat_pgmajfault:rate1m
{{< /code >}}
 
##### instance_device:node_disk_io_time_seconds:rate1m

{{< code lang="yaml" >}}
expr: |
  rate(node_disk_io_time_seconds_total{job="node", device!=""}[1m])
record: instance_device:node_disk_io_time_seconds:rate1m
{{< /code >}}
 
##### instance_device:node_disk_io_time_weighted_seconds:rate1m

{{< code lang="yaml" >}}
expr: |
  rate(node_disk_io_time_weighted_seconds_total{job="node", device!=""}[1m])
record: instance_device:node_disk_io_time_weighted_seconds:rate1m
{{< /code >}}
 
##### instance:node_network_receive_bytes_excluding_lo:rate1m

{{< code lang="yaml" >}}
expr: |
  sum without (device) (
    rate(node_network_receive_bytes_total{job="node", device!="lo"}[1m])
  )
record: instance:node_network_receive_bytes_excluding_lo:rate1m
{{< /code >}}
 
##### instance:node_network_transmit_bytes_excluding_lo:rate1m

{{< code lang="yaml" >}}
expr: |
  sum without (device) (
    rate(node_network_transmit_bytes_total{job="node", device!="lo"}[1m])
  )
record: instance:node_network_transmit_bytes_excluding_lo:rate1m
{{< /code >}}
 
##### instance:node_network_receive_drop_excluding_lo:rate1m

{{< code lang="yaml" >}}
expr: |
  sum without (device) (
    rate(node_network_receive_drop_total{job="node", device!="lo"}[1m])
  )
record: instance:node_network_receive_drop_excluding_lo:rate1m
{{< /code >}}
 
##### instance:node_network_transmit_drop_excluding_lo:rate1m

{{< code lang="yaml" >}}
expr: |
  sum without (device) (
    rate(node_network_transmit_drop_total{job="node", device!="lo"}[1m])
  )
record: instance:node_network_transmit_drop_excluding_lo:rate1m
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [node-cluster-rsrc-use](https://github.com/monitoring-mixins/website/blob/master/assets/node-exporter/dashboards/node-cluster-rsrc-use.json)
- [node-rsrc-use](https://github.com/monitoring-mixins/website/blob/master/assets/node-exporter/dashboards/node-rsrc-use.json)
- [nodes](https://github.com/monitoring-mixins/website/blob/master/assets/node-exporter/dashboards/nodes.json)
