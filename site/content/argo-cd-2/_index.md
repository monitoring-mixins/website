---
title: argo-cd-2
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/adinhodovic/argo-cd-mixin](https://github.com/adinhodovic/argo-cd-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/argo-cd-2/alerts.yaml).
{{< /panel >}}

### argo-cd

##### ArgoCdAppSyncFailed

{{< code lang="yaml" >}}
alert: ArgoCdAppSyncFailed
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-application-overview-kask/argocd-application-overview?var-dest_server={{
    $labels.dest_server }}&var-project={{ $labels.project }}&var-application={{ $labels.name
    }}
  description: The application {{ $labels.dest_server }}/{{ $labels.project }}/{{
    $labels.name }} has failed to sync with the status {{ $labels.phase }} the past
    10m.
  summary: An ArgoCD Application has Failed to Sync.
expr: |
  sum(
    round(
      increase(
        argocd_app_sync_total{
          job=~".*",
          phase!="Succeeded"
        }[10m]
      )
    )
  ) by (job, dest_server, project, name, phase) > 0
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdAppUnhealthy

{{< code lang="yaml" >}}
alert: ArgoCdAppUnhealthy
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-application-overview-kask/argocd-application-overview?var-dest_server={{
    $labels.dest_server }}&var-project={{ $labels.project }}&var-application={{ $labels.name
    }}
  description: The application {{ $labels.dest_server }}/{{ $labels.project }}/{{
    $labels.name }} is unhealthy with the health status {{ $labels.health_status }}
    for the past 15m.
  summary: An ArgoCD Application is Unhealthy.
expr: |
  sum(
    argocd_app_info{
      job=~".*",
      health_status!~"Healthy|Progressing"
    }
  ) by (job, dest_server, project, name, health_status)
  > 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdAppOutOfSync

{{< code lang="yaml" >}}
alert: ArgoCdAppOutOfSync
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-application-overview-kask/argocd-application-overview?var-dest_server={{
    $labels.dest_server }}&var-project={{ $labels.project }}&var-application={{ $labels.name
    }}
  description: The application {{ $labels.dest_server }}/{{ $labels.project }}/{{
    $labels.name }} is out of sync with the sync status {{ $labels.sync_status }}
    for the past 15m.
  summary: An ArgoCD Application is Out Of Sync.
expr: |
  sum(
    argocd_app_info{
      job=~".*",
      sync_status!="Synced"
    }
  ) by (job, dest_server, project, name, sync_status)
  > 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdAppAutoSyncDisabled

{{< code lang="yaml" >}}
alert: ArgoCdAppAutoSyncDisabled
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-application-overview-kask/argocd-application-overview?var-dest_server={{
    $labels.dest_server }}&var-project={{ $labels.project }}&var-application={{ $labels.name
    }}
  description: The application {{ $labels.dest_server }}/{{ $labels.project }}/{{
    $labels.name }} has autosync disabled for the past 2h.
  summary: An ArgoCD Application has AutoSync Disabled.
expr: |
  sum(
    argocd_app_info{
      job=~".*",
      autosync_enabled!="true",
      name!~""
    }
  ) by (job, dest_server, project, name, autosync_enabled)
  > 0
for: 2h
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdNotificationDeliveryFailed

{{< code lang="yaml" >}}
alert: ArgoCdNotificationDeliveryFailed
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-notifications-overview-kask/argocd-notifications-overview?var-job={{
    $labels.job }}&var-exported_service={{ $labels.exported_service }}
  description: The notification job {{ $labels.job }} has failed to deliver to {{
    $labels.exported_service }} for the past 10m.
  summary: ArgoCD Notification Delivery Failed.
expr: |
  sum(
    round(
      increase(
        argocd_notifications_deliveries_total{
          job=~".*",
          succeeded!="true"
        }[10m]
      )
    )
  ) by (job, exported_service, succeeded) > 0
for: 1m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [argo-cd-application-overview](https://github.com/monitoring-mixins/website/blob/master/assets/argo-cd-2/dashboards/argo-cd-application-overview.json)
- [argo-cd-notifications-overview](https://github.com/monitoring-mixins/website/blob/master/assets/argo-cd-2/dashboards/argo-cd-notifications-overview.json)
- [argo-cd-operational-overview](https://github.com/monitoring-mixins/website/blob/master/assets/argo-cd-2/dashboards/argo-cd-operational-overview.json)
