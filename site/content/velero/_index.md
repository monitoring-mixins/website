---
title: velero
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/velero-2-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/velero/alerts.yaml).
{{< /panel >}}

### velero

##### VeleroBackupFailure

{{< code lang="yaml" >}}
alert: VeleroBackupFailure
annotations:
  description: |
    Backup failures detected on {{ $labels.instance }}. This could lead to data loss or inability to recover in case of a disaster.
  summary: Velero backup failures detected.
expr: |
  increase(velero_backup_failure_total{job="integrations/velero"}[5m]) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### VeleroHighBackupDuration

{{< code lang="yaml" >}}
alert: VeleroHighBackupDuration
annotations:
  description: |
    Backup duration on {{ $labels.instance }} is higher than the average duration over the past 48 hours. This could indicate performance issues or network congestion. The current value is {{ $value | printf "%.2f" }} seconds.
  summary: Velero backups taking longer than usual.
expr: |
  histogram_quantile(0.5, sum(rate(velero_backup_duration_seconds_bucket{job="integrations/velero"}[5m])) by (le, schedule)) > 1.2 * 1.2 * avg_over_time(histogram_quantile(0.5, sum(rate(velero_backup_duration_seconds_bucket{job="integrations/velero"}[48h])) by (le, schedule))[5m:])
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### VeleroHighRestoreFailureRate

{{< code lang="yaml" >}}
alert: VeleroHighRestoreFailureRate
annotations:
  description: |
    Restore failures detected on {{ $labels.instance }}. This could prevent timely data recovery and business continuity.
  summary: Velero restore failures detected.
expr: |
  increase(velero_restore_failed_total{job="integrations/velero"}[5m]) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### VeleroUpStatus

{{< code lang="yaml" >}}
alert: VeleroUpStatus
annotations:
  description: "Cannot find any metrics related to Velero on {{ $labels.instance }}.
    This may indicate further issues with Velero or the scraping agent. 
"
  summary: Velero is down.
expr: |
  up{job="integrations/velero"} != 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [*](https://github.com/monitoring-mixins/website/blob/master/assets/velero/dashboards/*.json)
