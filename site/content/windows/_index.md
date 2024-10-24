---
title: windows
---

## Overview

Windows mixins based on flexible windows-observ-lib.

{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/windows-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/windows/alerts.yaml).
{{< /panel >}}

### windows-alerts-windows

##### WindowsCPUHighUsage

{{< code lang="yaml" >}}
alert: WindowsCPUHighUsage
annotations:
  description: |
    CPU usage on host {{ $labels.instance }} is above 90%. The current value is {{ $value | printf "%.2f" }}%.
  summary: High CPU usage on Windows host.
expr: |
  100 - (avg without (mode, core) (rate(windows_cpu_time_total{job=~".*windows.*", mode="idle"}[2m])) * 100) > 90
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### WindowsMemoryHighUtilization

{{< code lang="yaml" >}}
alert: WindowsMemoryHighUtilization
annotations:
  description: |
    Memory usage on host {{ $labels.instance }} is above 90%. The current value is {{ $value | printf "%.2f" }}%.
  summary: High memory usage on Windows host.
expr: |
  100 - ((windows_os_physical_memory_free_bytes{job=~".*windows.*"}
  /
  windows_cs_physical_memory_bytes{job=~".*windows.*"}) * 100) > 90
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### WindowsDiskAlmostOutOfSpace

{{< code lang="yaml" >}}
alert: WindowsDiskAlmostOutOfSpace
annotations:
  description: |
    Volume {{ $labels.volume }} is almost full on host {{ $labels.instance }}, more than 90% of space is used. The current volume utilization is {{ $value | printf "%.2f" }}%.
  summary: Disk is almost full on Windows host.
expr: |
  100 - ((windows_logical_disk_free_bytes{job=~".*windows.*"} ) / (windows_logical_disk_size_bytes{job=~".*windows.*"})) * 100  > 90
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### WindowsServiceNotHealthy

{{< code lang="yaml" >}}
alert: WindowsServiceNotHealthy
annotations:
  description: |
    Windows service {{ $labels.name }} is not in healthy state, currently in '{{ $labels.status }}'.
  summary: Windows service is not healthy.
expr: |
  windows_service_status{job=~".*windows.*", status!~"starting|stopping|ok"} > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### WindowsDiskDriveNotHealthy

{{< code lang="yaml" >}}
alert: WindowsDiskDriveNotHealthy
annotations:
  description: |
    Windows disk {{ $labels.name }} is not in healthy state, currently in '{{ $labels.status }}' status.
  summary: Windows physical disk is not healthy.
expr: |
  windows_disk_drive_status{job=~".*windows.*", status="OK"} != 1
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### WindowsNTPClientDelay

{{< code lang="yaml" >}}
alert: WindowsNTPClientDelay
annotations:
  description: |
    'Round-trip time of NTP client on instance {{ $labels.instance }} is greater than 1 second. Delay is {{ $value }} sec.'
  summary: NTP client delay.
expr: |
  windows_time_ntp_round_trip_delay_seconds{job=~".*windows.*"} > 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### WindowsNTPTimeOffset

{{< code lang="yaml" >}}
alert: WindowsNTPTimeOffset
annotations:
  description: |
    'NTP time offset for instance {{ $labels.instance }} is greater than 1 second. Offset is {{ $value }} sec.'
  summary: NTP time offset is too large.
expr: |
  windows_time_computed_time_offset_seconds{job=~".*windows.*"} > 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [*](https://github.com/monitoring-mixins/website/blob/master/assets/windows/dashboards/*.json)
