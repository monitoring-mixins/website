---
title: alertmanager
---

## Overview

The Alertmanager Mixin is a set of configurable, reusable, and extensible alerts (and eventually dashboards) for Alertmanager.

{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/prometheus/alertmanager](https://github.com/prometheus/alertmanager/tree/master/doc/alertmanager-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/alertmanager/alerts.yaml).
{{< /panel >}}

### alertmanager.rules

##### AlertmanagerFailedReload

{{< code lang="yaml" >}}
alert: AlertmanagerFailedReload
annotations:
  description: Configuration has failed to load for {{$labels.instance}}.
  summary: Reloading an Alertmanager configuration has failed.
expr: |
  # Without max_over_time, failed scrapes could create false negatives, see
  # https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.
  max_over_time(alertmanager_config_last_reload_successful{job="alertmanager"}[5m]) == 0
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### AlertmanagerMembersInconsistent

{{< code lang="yaml" >}}
alert: AlertmanagerMembersInconsistent
annotations:
  description: Alertmanager {{$labels.instance}} has only found {{ $value }} members
    of the {{$labels.job}} cluster.
  summary: A member of an Alertmanager cluster has not found all other cluster members.
expr: |
  # Without max_over_time, failed scrapes could create false negatives, see
  # https://www.robustperception.io/alerting-on-gauges-in-prometheus-2-0 for details.
    max_over_time(alertmanager_cluster_members{job="alertmanager"}[5m])
  < on (job) group_left
    count by (job) (max_over_time(alertmanager_cluster_members{job="alertmanager"}[5m]))
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### AlertmanagerFailedToSendAlerts

{{< code lang="yaml" >}}
alert: AlertmanagerFailedToSendAlerts
annotations:
  description: Alertmanager {{$labels.instance}} failed to send {{ $value | humanizePercentage
    }} of notifications to {{ $labels.integration }}.
  summary: An Alertmanager instance failed to send notifications.
expr: |
  (
    rate(alertmanager_notifications_failed_total{job="alertmanager"}[15m])
  /
    ignoring (reason) group_left rate(alertmanager_notifications_total{job="alertmanager"}[15m])
  )
  > 0.01
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### AlertmanagerClusterFailedToSendAlerts

{{< code lang="yaml" >}}
alert: AlertmanagerClusterFailedToSendAlerts
annotations:
  description: The minimum notification failure rate to {{ $labels.integration }}
    sent from any instance in the {{$labels.job}} cluster is {{ $value | humanizePercentage
    }}.
  summary: All Alertmanager instances in a cluster failed to send notifications to
    a critical integration.
expr: |
  min by (job, integration) (
    rate(alertmanager_notifications_failed_total{job="alertmanager", integration=~`.*`}[15m])
  /
    ignoring (reason) group_left rate(alertmanager_notifications_total{job="alertmanager", integration=~`.*`}[15m]) > 0
  )
  > 0.01
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### AlertmanagerClusterFailedToSendAlerts

{{< code lang="yaml" >}}
alert: AlertmanagerClusterFailedToSendAlerts
annotations:
  description: The minimum notification failure rate to {{ $labels.integration }}
    sent from any instance in the {{$labels.job}} cluster is {{ $value | humanizePercentage
    }}.
  summary: All Alertmanager instances in a cluster failed to send notifications to
    a non-critical integration.
expr: |
  min by (job, integration) (
    rate(alertmanager_notifications_failed_total{job="alertmanager", integration!~`.*`}[15m])
  /
    ignoring (reason) group_left rate(alertmanager_notifications_total{job="alertmanager", integration!~`.*`}[15m]) > 0
  )
  > 0.01
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### AlertmanagerConfigInconsistent

{{< code lang="yaml" >}}
alert: AlertmanagerConfigInconsistent
annotations:
  description: Alertmanager instances within the {{$labels.job}} cluster have different
    configurations.
  summary: Alertmanager instances within the same cluster have different configurations.
expr: |
  count by (job) (
    count_values by (job) ("config_hash", alertmanager_config_hash{job="alertmanager"})
  )
  != 1
for: 20m
labels:
  severity: critical
{{< /code >}}
 
##### AlertmanagerClusterDown

{{< code lang="yaml" >}}
alert: AlertmanagerClusterDown
annotations:
  description: '{{ $value | humanizePercentage }} of Alertmanager instances within
    the {{$labels.job}} cluster have been up for less than half of the last 5m.'
  summary: Half or more of the Alertmanager instances within the same cluster are
    down.
expr: |
  (
    count by (job) (
      avg_over_time(up{job="alertmanager"}[5m]) < 0.5
    )
  /
    count by (job) (
      up{job="alertmanager"}
    )
  )
  >= 0.5
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### AlertmanagerClusterCrashlooping

{{< code lang="yaml" >}}
alert: AlertmanagerClusterCrashlooping
annotations:
  description: '{{ $value | humanizePercentage }} of Alertmanager instances within
    the {{$labels.job}} cluster have restarted at least 5 times in the last 10m.'
  summary: Half or more of the Alertmanager instances within the same cluster are
    crashlooping.
expr: |
  (
    count by (job) (
      changes(process_start_time_seconds{job="alertmanager"}[10m]) > 4
    )
  /
    count by (job) (
      up{job="alertmanager"}
    )
  )
  >= 0.5
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [alertmanager-overview](https://github.com/monitoring-mixins/website/blob/master/assets/alertmanager/dashboards/alertmanager-overview.json)
