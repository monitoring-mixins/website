---
title: windows-active-directory
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/windows-active-directory-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/windows-active-directory/alerts.yaml).
{{< /panel >}}

### windows-alerts-active-directory

##### WindowsCPUHighUsage

{{< code lang="yaml" >}}
alert: WindowsCPUHighUsage
annotations:
  description: |
    CPU usage on host {{ $labels.instance }} is above 90%. The current value is {{ $value | printf "%.2f" }}%.
  summary: High CPU usage on Windows host.
expr: |
  100 - (avg without (mode, core) (rate(windows_cpu_time_total{mode="idle", }[2m])) * 100) > 90
for: 15m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### WindowsMemoryHighUtilization

{{< code lang="yaml" >}}
alert: WindowsMemoryHighUtilization
annotations:
  description: |
    Memory usage on host {{ $labels.instance }} is critically high, with {{ printf "%.2f" $value }}% of total memory used.
    This exceeds the threshold of 90%.
    Current memory free: {{ with printf `windows_os_physical_memory_free_bytes{}` | query | first | value | humanize }}{{ . }}{{ end }}.
    Total memory: {{ with printf `windows_cs_physical_memory_bytes{}` | query | first | value | humanize }}{{ . }}{{ end }}.
    Consider investigating processes consuming high memory or increasing available memory.
  summary: High memory usage on Windows host.
expr: |
  100 - ((windows_os_physical_memory_free_bytes{}
  /
  windows_cs_physical_memory_bytes{}) * 100) > 90
for: 15m
keep_firing_for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### WindowsDiskAlmostOutOfSpace

{{< code lang="yaml" >}}
alert: WindowsDiskAlmostOutOfSpace
annotations:
  description: |
    Disk space on volume {{ $labels.volume }} of host {{ $labels.instance }} is critically low, with {{ printf "%.2f" $value }}% of total space used.
    This exceeds the threshold of 90%.
    Current disk free: {{ with printf `windows_logical_disk_free_bytes{volume="%s", }` $labels.volume | query | first | value | humanize }}{{ . }}{{ end }}.
    Total disk size: {{ with printf `windows_logical_disk_size_bytes{volume="%s", }` $labels.volume | query | first | value | humanize }}{{ . }}{{ end }}.
    Consider cleaning up unnecessary files or increasing disk capacity.
  summary: Disk is almost full on Windows host.
expr: |
  100 - ((windows_logical_disk_free_bytes{} ) / (windows_logical_disk_size_bytes{})) * 100  > 90
for: 15m
keep_firing_for: 5m
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
  windows_service_status{status!~"starting|stopping|ok", } > 0
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
  windows_disk_drive_status{status="OK", } != 1
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### WindowsNTPClientDelay

{{< code lang="yaml" >}}
alert: WindowsNTPClientDelay
annotations:
  description: |
    Round-trip time of NTP client on instance {{ $labels.instance }} is greater than 1 second. Delay is {{ $value }} sec.
  summary: NTP client delay.
expr: |
  windows_time_ntp_round_trip_delay_seconds{} > 1
for: 5m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### WindowsNTPTimeOffset

{{< code lang="yaml" >}}
alert: WindowsNTPTimeOffset
annotations:
  description: |
    NTP time offset for instance {{ $labels.instance }} is greater than 1 second. Offset is {{ $value }} sec.
  summary: NTP time offset is too large.
expr: |
  windows_time_computed_time_offset_seconds{} > 1
for: 5m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### WindowsNodeHasRebooted

{{< code lang="yaml" >}}
alert: WindowsNodeHasRebooted
annotations:
  description: Node {{ $labels.instance }} has rebooted {{ $value | humanize }} seconds
    ago.
  summary: Node has rebooted.
expr: |
  (time() - windows_system_system_up_time{}) < 600
  and
  (time() - (windows_system_system_up_time{} offset 10m)) > 600
labels:
  severity: info
{{< /code >}}
 
##### WindowsActiveDirectoryHighPendingReplicationOperations

{{< code lang="yaml" >}}
alert: WindowsActiveDirectoryHighPendingReplicationOperations
annotations:
  description: The number of pending replication operations on {{$labels.instance}}
    is {{ printf "%.0f" $value }} which is above the threshold of 50.
  summary: There is a high number of pending replication operations in Active Directory.
    A high number of pending operations sustained over a period of time can indicate
    a problem with replication.
expr: "windows_ad_replication_pending_operations{} >= 50 
"
for: 10m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### WindowsActiveDirectoryHighReplicationSyncRequestFailures

{{< code lang="yaml" >}}
alert: WindowsActiveDirectoryHighReplicationSyncRequestFailures
annotations:
  description: The number of replication sync request failures on {{$labels.instance}}
    is {{ printf "%.0f" $value }} which is above the threshold of 0.
  summary: There are a number of replication synchronization request failures. These
    can cause authentication failures, outdated information being propagated across
    domain controllers, and potentially data loss or inconsistencies.
expr: "increase(windows_ad_replication_sync_requests_schema_mismatch_failure_total{}[5m])
  > 0 
"
for: 5m
keep_firing_for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### WindowsActiveDirectoryHighPasswordChanges

{{< code lang="yaml" >}}
alert: WindowsActiveDirectoryHighPasswordChanges
annotations:
  description: The number of password changes on {{$labels.instance}} is {{ printf
    "%.0f" $value }} which is greater than the threshold of 25. This alert would resolve
    itself if no new anomalies are detected within 24 hours.
  summary: There is a high number of password changes. This may indicate unauthorized
    changes or attacks.
expr: |
  increase(windows_ad_sam_password_changes_total{}[5m]) > 25
for: 5m
labels:
  keep_firing_for: 24h
  severity: warning
{{< /code >}}
 
##### WindowsActiveDirectoryMetricsDown

{{< code lang="yaml" >}}
alert: WindowsActiveDirectoryMetricsDown
annotations:
  description: There are no available metrics for Windows Active Directory integration
    from instance {{$labels.instance}}.
  summary: Windows Active Directory metrics are down.
expr: |
  up{job="integrations/windows_exporter"} == 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [*](https://github.com/monitoring-mixins/website/blob/master/assets/windows-active-directory/dashboards/*.json)
