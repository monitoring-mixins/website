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
  description: Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint
    }}, at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available space
    left and is filling up.
  summary: Filesystem is predicted to run out of space within the next 24 hours.
expr: |
  (
    node_filesystem_avail_bytes{job="node",fstype!="",mountpoint!=""} / node_filesystem_size_bytes{job="node",fstype!="",mountpoint!=""} * 100 < 40
  and
    predict_linear(node_filesystem_avail_bytes{job="node",fstype!="",mountpoint!=""}[6h], 24*60*60) < 0
  and
    node_filesystem_readonly{job="node",fstype!="",mountpoint!=""} == 0
  )
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### NodeFilesystemSpaceFillingUp

{{< code lang="yaml" >}}
alert: NodeFilesystemSpaceFillingUp
annotations:
  description: Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint
    }}, at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available space
    left and is filling up fast.
  summary: Filesystem is predicted to run out of space within the next 4 hours.
expr: |
  (
    node_filesystem_avail_bytes{job="node",fstype!="",mountpoint!=""} / node_filesystem_size_bytes{job="node",fstype!="",mountpoint!=""} * 100 < 20
  and
    predict_linear(node_filesystem_avail_bytes{job="node",fstype!="",mountpoint!=""}[6h], 4*60*60) < 0
  and
    node_filesystem_readonly{job="node",fstype!="",mountpoint!=""} == 0
  )
for: 1h
labels:
  severity: critical
{{< /code >}}
 
##### NodeFilesystemAlmostOutOfSpace

{{< code lang="yaml" >}}
alert: NodeFilesystemAlmostOutOfSpace
annotations:
  description: Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint
    }}, at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available space
    left.
  summary: Filesystem has less than 5% space left.
expr: |
  (
    node_filesystem_avail_bytes{job="node",fstype!="",mountpoint!=""} / node_filesystem_size_bytes{job="node",fstype!="",mountpoint!=""} * 100 < 5
  and
    node_filesystem_readonly{job="node",fstype!="",mountpoint!=""} == 0
  )
for: 30m
labels:
  severity: warning
{{< /code >}}
 
##### NodeFilesystemAlmostOutOfSpace

{{< code lang="yaml" >}}
alert: NodeFilesystemAlmostOutOfSpace
annotations:
  description: Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint
    }}, at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available space
    left.
  summary: Filesystem has less than 3% space left.
expr: |
  (
    node_filesystem_avail_bytes{job="node",fstype!="",mountpoint!=""} / node_filesystem_size_bytes{job="node",fstype!="",mountpoint!=""} * 100 < 3
  and
    node_filesystem_readonly{job="node",fstype!="",mountpoint!=""} == 0
  )
for: 30m
labels:
  severity: critical
{{< /code >}}
 
##### NodeFilesystemFilesFillingUp

{{< code lang="yaml" >}}
alert: NodeFilesystemFilesFillingUp
annotations:
  description: Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint
    }}, at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available inodes
    left and is filling up.
  summary: Filesystem is predicted to run out of inodes within the next 24 hours.
expr: |
  (
    node_filesystem_files_free{job="node",fstype!="",mountpoint!=""} / node_filesystem_files{job="node",fstype!="",mountpoint!=""} * 100 < 40
  and
    predict_linear(node_filesystem_files_free{job="node",fstype!="",mountpoint!=""}[6h], 24*60*60) < 0
  and
    node_filesystem_readonly{job="node",fstype!="",mountpoint!=""} == 0
  )
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### NodeFilesystemFilesFillingUp

{{< code lang="yaml" >}}
alert: NodeFilesystemFilesFillingUp
annotations:
  description: Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint
    }}, at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available inodes
    left and is filling up fast.
  summary: Filesystem is predicted to run out of inodes within the next 4 hours.
expr: |
  (
    node_filesystem_files_free{job="node",fstype!="",mountpoint!=""} / node_filesystem_files{job="node",fstype!="",mountpoint!=""} * 100 < 20
  and
    predict_linear(node_filesystem_files_free{job="node",fstype!="",mountpoint!=""}[6h], 4*60*60) < 0
  and
    node_filesystem_readonly{job="node",fstype!="",mountpoint!=""} == 0
  )
for: 1h
labels:
  severity: critical
{{< /code >}}
 
##### NodeFilesystemAlmostOutOfFiles

{{< code lang="yaml" >}}
alert: NodeFilesystemAlmostOutOfFiles
annotations:
  description: Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint
    }}, at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available inodes
    left.
  summary: Filesystem has less than 5% inodes left.
expr: |
  (
    node_filesystem_files_free{job="node",fstype!="",mountpoint!=""} / node_filesystem_files{job="node",fstype!="",mountpoint!=""} * 100 < 5
  and
    node_filesystem_readonly{job="node",fstype!="",mountpoint!=""} == 0
  )
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### NodeFilesystemAlmostOutOfFiles

{{< code lang="yaml" >}}
alert: NodeFilesystemAlmostOutOfFiles
annotations:
  description: Filesystem on {{ $labels.device }}, mounted on {{ $labels.mountpoint
    }}, at {{ $labels.instance }} has only {{ printf "%.2f" $value }}% available inodes
    left.
  summary: Filesystem has less than 3% inodes left.
expr: |
  (
    node_filesystem_files_free{job="node",fstype!="",mountpoint!=""} / node_filesystem_files{job="node",fstype!="",mountpoint!=""} * 100 < 3
  and
    node_filesystem_readonly{job="node",fstype!="",mountpoint!=""} == 0
  )
for: 1h
labels:
  severity: critical
{{< /code >}}
 
##### NodeNetworkReceiveErrs

{{< code lang="yaml" >}}
alert: NodeNetworkReceiveErrs
annotations:
  description: '{{ $labels.instance }} interface {{ $labels.device }} has encountered
    {{ printf "%.0f" $value }} receive errors in the last two minutes.'
  summary: Network interface is reporting many receive errors.
expr: |
  rate(node_network_receive_errs_total{job="node"}[2m]) / rate(node_network_receive_packets_total{job="node"}[2m]) > 0.01
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### NodeNetworkTransmitErrs

{{< code lang="yaml" >}}
alert: NodeNetworkTransmitErrs
annotations:
  description: '{{ $labels.instance }} interface {{ $labels.device }} has encountered
    {{ printf "%.0f" $value }} transmit errors in the last two minutes.'
  summary: Network interface is reporting many transmit errors.
expr: |
  rate(node_network_transmit_errs_total{job="node"}[2m]) / rate(node_network_transmit_packets_total{job="node"}[2m]) > 0.01
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
  (node_nf_conntrack_entries{job="node"} / node_nf_conntrack_entries_limit) > 0.75
labels:
  severity: warning
{{< /code >}}
 
##### NodeTextFileCollectorScrapeError

{{< code lang="yaml" >}}
alert: NodeTextFileCollectorScrapeError
annotations:
  description: Node Exporter text file collector on {{ $labels.instance }} failed
    to scrape.
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
  description: Clock at {{ $labels.instance }} is out of sync by more than 0.05s.
    Ensure NTP is configured correctly on this host.
  summary: Clock skew detected.
expr: |
  (
    node_timex_offset_seconds{job="node"} > 0.05
  and
    deriv(node_timex_offset_seconds{job="node"}[5m]) >= 0
  )
  or
  (
    node_timex_offset_seconds{job="node"} < -0.05
  and
    deriv(node_timex_offset_seconds{job="node"}[5m]) <= 0
  )
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### NodeClockNotSynchronising

{{< code lang="yaml" >}}
alert: NodeClockNotSynchronising
annotations:
  description: Clock at {{ $labels.instance }} is not synchronising. Ensure NTP is
    configured on this host.
  summary: Clock not synchronising.
expr: |
  min_over_time(node_timex_sync_status{job="node"}[5m]) == 0
  and
  node_timex_maxerror_seconds{job="node"} >= 16
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### NodeRAIDDegraded

{{< code lang="yaml" >}}
alert: NodeRAIDDegraded
annotations:
  description: RAID array '{{ $labels.device }}' at {{ $labels.instance }} is in degraded
    state due to one or more disks failures. Number of spare drives is insufficient
    to fix issue automatically.
  summary: RAID Array is degraded.
expr: |
  node_md_disks_required{job="node",device!=""} - ignoring (state) (node_md_disks{state="active",job="node",device!=""}) > 0
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### NodeRAIDDiskFailure

{{< code lang="yaml" >}}
alert: NodeRAIDDiskFailure
annotations:
  description: At least one device in RAID array at {{ $labels.instance }} failed.
    Array '{{ $labels.device }}' needs attention and possibly a disk swap.
  summary: Failed device in RAID array.
expr: |
  node_md_disks{state="failed",job="node",device!=""} > 0
labels:
  severity: warning
{{< /code >}}
 
##### NodeFileDescriptorLimit

{{< code lang="yaml" >}}
alert: NodeFileDescriptorLimit
annotations:
  description: File descriptors limit at {{ $labels.instance }} is currently at {{
    printf "%.2f" $value }}%.
  summary: Kernel is predicted to exhaust file descriptors limit soon.
expr: |
  (
    node_filefd_allocated{job="node"} * 100 / node_filefd_maximum{job="node"} > 70
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### NodeFileDescriptorLimit

{{< code lang="yaml" >}}
alert: NodeFileDescriptorLimit
annotations:
  description: File descriptors limit at {{ $labels.instance }} is currently at {{
    printf "%.2f" $value }}%.
  summary: Kernel is predicted to exhaust file descriptors limit soon.
expr: |
  (
    node_filefd_allocated{job="node"} * 100 / node_filefd_maximum{job="node"} > 90
  )
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### NodeCPUHighUsage

{{< code lang="yaml" >}}
alert: NodeCPUHighUsage
annotations:
  description: |
    CPU usage at {{ $labels.instance }} has been above 90% for the last 15 minutes, is currently at {{ printf "%.2f" $value }}%.
  summary: High CPU usage.
expr: |
  sum without(mode) (avg without (cpu) (rate(node_cpu_seconds_total{job="node", mode!="idle"}[2m]))) * 100 > 90
for: 15m
labels:
  severity: info
{{< /code >}}
 
##### NodeSystemSaturation

{{< code lang="yaml" >}}
alert: NodeSystemSaturation
annotations:
  description: |
    System load per core at {{ $labels.instance }} has been above 2 for the last 15 minutes, is currently at {{ printf "%.2f" $value }}.
    This might indicate this instance resources saturation and can cause it becoming unresponsive.
  summary: System saturated, load per core is very high.
expr: |
  node_load1{job="node"}
  / count without (cpu, mode) (node_cpu_seconds_total{job="node", mode="idle"}) > 2
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### NodeMemoryMajorPagesFaults

{{< code lang="yaml" >}}
alert: NodeMemoryMajorPagesFaults
annotations:
  description: |
    Memory major pages are occurring at very high rate at {{ $labels.instance }}, 500 major page faults per second for the last 15 minutes, is currently at {{ printf "%.2f" $value }}.
    Please check that there is enough memory available at this instance.
  summary: Memory major page faults are occurring at very high rate.
expr: |
  rate(node_vmstat_pgmajfault{job="node"}[5m]) > 500
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### NodeMemoryHighUtilization

{{< code lang="yaml" >}}
alert: NodeMemoryHighUtilization
annotations:
  description: |
    Memory is filling up at {{ $labels.instance }}, has been above 90% for the last 15 minutes, is currently at {{ printf "%.2f" $value }}%.
  summary: Host is running out of memory.
expr: |
  100 - (node_memory_MemAvailable_bytes{job="node"} / node_memory_MemTotal_bytes{job="node"} * 100) > 90
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### NodeDiskIOSaturation

{{< code lang="yaml" >}}
alert: NodeDiskIOSaturation
annotations:
  description: |
    Disk IO queue (aqu-sq) is high on {{ $labels.device }} at {{ $labels.instance }}, has been above 10 for the last 30 minutes, is currently at {{ printf "%.2f" $value }}.
    This symptom might indicate disk saturation.
  summary: Disk IO queue is high.
expr: |
  rate(node_disk_io_time_weighted_seconds_total{job="node", device!=""}[5m]) > 10
for: 30m
labels:
  severity: warning
{{< /code >}}
 
##### NodeSystemdServiceFailed

{{< code lang="yaml" >}}
alert: NodeSystemdServiceFailed
annotations:
  description: Systemd service {{ $labels.name }} has entered failed state at {{ $labels.instance
    }}
  summary: Systemd service has entered failed state.
expr: |
  node_systemd_unit_state{job="node", state="failed"} == 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### NodeBondingDegraded

{{< code lang="yaml" >}}
alert: NodeBondingDegraded
annotations:
  description: Bonding interface {{ $labels.master }} on {{ $labels.instance }} is
    in degraded state due to one or more slave failures.
  summary: Bonding interface is degraded
expr: |
  (node_bonding_slaves - node_bonding_active) != 0
for: 5m
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
  count without (cpu, mode) (
    node_cpu_seconds_total{job="node",mode="idle"}
  )
record: instance:node_num_cpu:sum
{{< /code >}}
 
##### instance:node_cpu_utilisation:rate5m

{{< code lang="yaml" >}}
expr: |
  1 - avg without (cpu) (
    sum without (mode) (rate(node_cpu_seconds_total{job="node", mode=~"idle|iowait|steal"}[5m]))
  )
record: instance:node_cpu_utilisation:rate5m
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
    (
      node_memory_MemAvailable_bytes{job="node"}
      or
      (
        node_memory_Buffers_bytes{job="node"}
        +
        node_memory_Cached_bytes{job="node"}
        +
        node_memory_MemFree_bytes{job="node"}
        +
        node_memory_Slab_bytes{job="node"}
      )
    )
  /
    node_memory_MemTotal_bytes{job="node"}
  )
record: instance:node_memory_utilisation:ratio
{{< /code >}}
 
##### instance:node_vmstat_pgmajfault:rate5m

{{< code lang="yaml" >}}
expr: |
  rate(node_vmstat_pgmajfault{job="node"}[5m])
record: instance:node_vmstat_pgmajfault:rate5m
{{< /code >}}
 
##### instance_device:node_disk_io_time_seconds:rate5m

{{< code lang="yaml" >}}
expr: |
  rate(node_disk_io_time_seconds_total{job="node", device!=""}[5m])
record: instance_device:node_disk_io_time_seconds:rate5m
{{< /code >}}
 
##### instance_device:node_disk_io_time_weighted_seconds:rate5m

{{< code lang="yaml" >}}
expr: |
  rate(node_disk_io_time_weighted_seconds_total{job="node", device!=""}[5m])
record: instance_device:node_disk_io_time_weighted_seconds:rate5m
{{< /code >}}
 
##### instance:node_network_receive_bytes_excluding_lo:rate5m

{{< code lang="yaml" >}}
expr: |
  sum without (device) (
    rate(node_network_receive_bytes_total{job="node", device!="lo"}[5m])
  )
record: instance:node_network_receive_bytes_excluding_lo:rate5m
{{< /code >}}
 
##### instance:node_network_transmit_bytes_excluding_lo:rate5m

{{< code lang="yaml" >}}
expr: |
  sum without (device) (
    rate(node_network_transmit_bytes_total{job="node", device!="lo"}[5m])
  )
record: instance:node_network_transmit_bytes_excluding_lo:rate5m
{{< /code >}}
 
##### instance:node_network_receive_drop_excluding_lo:rate5m

{{< code lang="yaml" >}}
expr: |
  sum without (device) (
    rate(node_network_receive_drop_total{job="node", device!="lo"}[5m])
  )
record: instance:node_network_receive_drop_excluding_lo:rate5m
{{< /code >}}
 
##### instance:node_network_transmit_drop_excluding_lo:rate5m

{{< code lang="yaml" >}}
expr: |
  sum without (device) (
    rate(node_network_transmit_drop_total{job="node", device!="lo"}[5m])
  )
record: instance:node_network_transmit_drop_excluding_lo:rate5m
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [node-cluster-rsrc-use](https://github.com/monitoring-mixins/website/blob/master/assets/node-exporter/dashboards/node-cluster-rsrc-use.json)
- [node-rsrc-use](https://github.com/monitoring-mixins/website/blob/master/assets/node-exporter/dashboards/node-rsrc-use.json)
- [nodes-aix](https://github.com/monitoring-mixins/website/blob/master/assets/node-exporter/dashboards/nodes-aix.json)
- [nodes-darwin](https://github.com/monitoring-mixins/website/blob/master/assets/node-exporter/dashboards/nodes-darwin.json)
- [nodes](https://github.com/monitoring-mixins/website/blob/master/assets/node-exporter/dashboards/nodes.json)
