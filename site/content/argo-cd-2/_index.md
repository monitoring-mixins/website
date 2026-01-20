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
  ) by (cluster, job, dest_server, project, name, phase) > 0
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
      health_status!~"Healthy|Progressing",
      name!~""
    }
  ) by (cluster, job, dest_server, project, name, health_status)
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
  ) by (cluster, job, dest_server, project, name, sync_status)
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
  ) by (cluster, job, dest_server, project, name, autosync_enabled)
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
  ) by (cluster, job, exported_service, succeeded) > 0
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdAppControllerHighReconciliationDuration

{{< code lang="yaml" >}}
alert: ArgoCdAppControllerHighReconciliationDuration
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-operational-overview-kask/argocd-operational-overview
  description: ArgoCD app controller in {{ $labels.namespace }} is taking more than
    60s (0.95 percentile) to reconcile applications for the past 10m. This may indicate
    performance issues or the need to scale up.
  summary: ArgoCD App Controller has high reconciliation duration.
expr: |
  histogram_quantile(0.95,
    sum(
      rate(
        argocd_app_reconcile_bucket{
          job=~".*"
        }[10m]
      )
    ) by (cluster, namespace, le)
  ) > 60
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdRepoServerPendingRequests

{{< code lang="yaml" >}}
alert: ArgoCdRepoServerPendingRequests
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-operational-overview-kask/argocd-operational-overview
  description: ArgoCD repo server in {{ $labels.namespace }} has 50 or more pending
    requests for the past 5m. The repo server may be overloaded and need scaling.
  summary: ArgoCD Repo Server has pending requests.
expr: |
  sum(
    argocd_repo_pending_request_total{
      job=~".*"
    }
  ) by (cluster, namespace)
  > 50
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdRepoServerHighGitRequestDuration

{{< code lang="yaml" >}}
alert: ArgoCdRepoServerHighGitRequestDuration
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-operational-overview-kask/argocd-operational-overview
  description: ArgoCD repo server in {{ $labels.namespace }} is experiencing git operations
    (fetch/clone) taking more than 30s (0.95 percentile) for the past 10m. This may
    indicate slow git repository access or network issues.
  summary: ArgoCD Repo Server has high git request duration.
expr: |
  histogram_quantile(0.95,
    sum(
      rate(
        argocd_git_request_duration_seconds_bucket{
          job=~".*"
        }[10m]
      )
    ) by (cluster, namespace, le)
  ) > 30
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdClusterConnectionError

{{< code lang="yaml" >}}
alert: ArgoCdClusterConnectionError
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-operational-overview-kask/argocd-operational-overview
  description: ArgoCD in {{ $labels.namespace }} cannot connect to cluster {{ $labels.server
    }} for the past 5m. Check cluster credentials and network connectivity.
  summary: ArgoCD cannot connect to managed cluster.
expr: |
  argocd_cluster_connection_status{
    job=~".*"
  } < 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdGitRequestErrors

{{< code lang="yaml" >}}
alert: ArgoCdGitRequestErrors
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-operational-overview-kask/argocd-operational-overview
  description: ArgoCD in {{ $labels.namespace }} is experiencing git fetch failures
    for repository {{ $labels.repo }} for the past 5m. This may indicate repository
    access issues or network problems.
  summary: ArgoCD Git requests are failing.
expr: |
  sum(
    round(
      increase(
        argocd_git_fetch_fail_total{
          job=~".*"
        }[5m]
      )
    )
  ) by (cluster, namespace, repo) > 0
for: 1m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [argo-cd-application-overview](https://github.com/monitoring-mixins/website/blob/master/assets/argo-cd-2/dashboards/argo-cd-application-overview.json)
- [argo-cd-notifications-overview](https://github.com/monitoring-mixins/website/blob/master/assets/argo-cd-2/dashboards/argo-cd-notifications-overview.json)
- [argo-cd-operational-overview](https://github.com/monitoring-mixins/website/blob/master/assets/argo-cd-2/dashboards/argo-cd-operational-overview.json)
