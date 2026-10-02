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
  description: Application {{ $labels.dest_server }}/{{ $labels.project }}/{{ $labels.name
    }} had at least one sync attempt fail with phase {{ $labels.phase }} in the last
    10m.
  summary: ArgoCD application sync failed.
expr: |
  sum(
    round(
      increase(
        argocd_app_sync_total{
          job=~"(argocd|argo-cd).*",
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
  description: Application {{ $labels.dest_server }}/{{ $labels.project }}/{{ $labels.name
    }} has reported health status {{ $labels.health_status }} for at least 15m.
  summary: ArgoCD application is unhealthy.
expr: |
  sum(
    argocd_app_info{
      job=~"(argocd|argo-cd).*",
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
  description: Application {{ $labels.dest_server }}/{{ $labels.project }}/{{ $labels.name
    }} has reported sync status {{ $labels.sync_status }} for at least 15m.
  summary: ArgoCD application is out of sync.
expr: |
  sum(
    argocd_app_info{
      job=~"(argocd|argo-cd).*",
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
  description: Application {{ $labels.dest_server }}/{{ $labels.project }}/{{ $labels.name
    }} has had auto-sync disabled for at least 2h.
  summary: ArgoCD application auto-sync is disabled.
expr: |
  sum(
    argocd_app_info{
      job=~"(argocd|argo-cd).*",
      autosync_enabled!="true",
      name!~""
    }
  ) by (cluster, job, dest_server, project, name, autosync_enabled)
  > 0
for: 2h
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdRolloutProgressing

{{< code lang="yaml" >}}
alert: ArgoCdRolloutProgressing
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-application-overview-kask/argocd-application-overview?var-dest_server={{
    $labels.dest_server }}&var-project={{ $labels.project }}&var-application={{ $labels.name
    }}
  description: Application {{ $labels.dest_server }}/{{ $labels.project }}/{{ $labels.name
    }} has remained in health status Progressing for more than 1h.
  summary: ArgoCD application rollout is still progressing.
expr: |
  sum(
    argocd_app_info{
      job=~"(argocd|argo-cd).*",
      health_status="Progressing",
      name!~""
    }
  ) by (cluster, job, dest_server, project, name, health_status)
  > 0
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdNotificationDeliveryFailed

{{< code lang="yaml" >}}
alert: ArgoCdNotificationDeliveryFailed
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-notifications-overview-kask/argocd-notifications-overview?var-job={{
    $labels.job }}&var-exported_service={{ $labels.exported_service }}
  description: Notification job {{ $labels.job }} failed to deliver to {{ $labels.exported_service
    }} at least once in the last 10m.
  summary: ArgoCD notification delivery failed.
expr: |
  sum(
    round(
      increase(
        argocd_notifications_deliveries_total{
          job=~"(argocd|argo-cd).*",
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
  description: The P0.95 application reconciliation duration in namespace {{ $labels.namespace
    }} has been at or above 16s for 10m. The application controller may be overloaded
    or blocked on Kubernetes API calls.
  summary: ArgoCD application reconciliation is slow.
expr: |
  histogram_quantile(0.95,
    sum(
      rate(
        argocd_app_reconcile_bucket{
          job=~"(argocd|argo-cd).*"
        }[2m]
      )
    ) by (cluster, namespace, le)
  ) >= 16
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdRepoServerPendingRequests

{{< code lang="yaml" >}}
alert: ArgoCdRepoServerPendingRequests
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-operational-overview-kask/argocd-operational-overview
  description: Repo server in namespace {{ $labels.namespace }} has had more than
    50 pending requests for 10m. The repo server may be overloaded or waiting on slow
    repository operations.
  summary: ArgoCD repo server has pending requests.
expr: |
  sum(
    argocd_repo_pending_request_total{
      job=~"(argocd|argo-cd).*"
    }
  ) by (cluster, namespace)
  > 50
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdRepoServerHighGitRequestDuration

{{< code lang="yaml" >}}
alert: ArgoCdRepoServerHighGitRequestDuration
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-operational-overview-kask/argocd-operational-overview
  description: The P0.95 Git request duration in namespace {{ $labels.namespace }}
    has been at or above 20s for 10m. Repository access, network latency, or repo
    server load may be degraded.
  summary: ArgoCD repo server Git requests are slow.
expr: |
  histogram_quantile(0.95,
    sum(
      rate(
        argocd_git_request_duration_seconds_bucket{
          job=~"(argocd|argo-cd).*"
        }[2m]
      )
    ) by (cluster, namespace, le)
  ) >= 20
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdClusterConnectionError

{{< code lang="yaml" >}}
alert: ArgoCdClusterConnectionError
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-operational-overview-kask/argocd-operational-overview
  description: ArgoCD in namespace {{ $labels.namespace }} has been unable to connect
    to cluster {{ $labels.server }} for 5m. Check cluster credentials, API server
    reachability, and network policy.
  summary: ArgoCD cannot connect to a managed cluster.
expr: |
  argocd_cluster_connection_status{
    job=~"(argocd|argo-cd).*"
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
  description: ArgoCD in namespace {{ $labels.namespace }} has had Git fetch failures
    for repository {{ $labels.repo }} for 5m. Check repository availability, credentials,
    and network connectivity.
  summary: ArgoCD Git requests are failing.
expr: |
  sum(
    round(
      increase(
        argocd_git_fetch_fail_total{
          job=~"(argocd|argo-cd).*"
        }[2m]
      )
    )
  ) by (cluster, namespace, repo) > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdHighKubectlRateLimiterDuration

{{< code lang="yaml" >}}
alert: ArgoCdHighKubectlRateLimiterDuration
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-operational-overview-kask/argocd-operational-overview
  description: The P0.95 kubectl rate limiter wait time in namespace {{ $labels.namespace
    }} has been above 1s for 10m. ArgoCD may be throttling requests before they reach
    the Kubernetes API server.
  summary: ArgoCD kubectl client-side throttling is high.
expr: |
  histogram_quantile(0.95,
    sum(
      rate(
        argocd_kubectl_rate_limiter_duration_seconds_bucket{
          job=~"(argocd|argo-cd).*"
        }[2m]
      )
    ) by (cluster, namespace, le)
  ) > 1
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdHighKubectlRequestDuration

{{< code lang="yaml" >}}
alert: ArgoCdHighKubectlRequestDuration
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-operational-overview-kask/argocd-operational-overview
  description: The P0.95 kubectl request duration in namespace {{ $labels.namespace
    }} has been above 5s for 10m. The Kubernetes API server or network path may be
    slow.
  summary: ArgoCD kubectl requests are slow.
expr: |
  histogram_quantile(0.95,
    sum(
      rate(
        argocd_kubectl_request_duration_seconds_bucket{
          job=~"(argocd|argo-cd).*"
        }[2m]
      )
    ) by (cluster, namespace, le)
  ) > 5
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdHighKubectlRequestRetryRate

{{< code lang="yaml" >}}
alert: ArgoCdHighKubectlRequestRetryRate
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-operational-overview-kask/argocd-operational-overview
  description: ArgoCD in namespace {{ $labels.namespace }} has had more than 50 kubectl
    request retries per minute for 10m. This usually points to Kubernetes API errors,
    throttling, or network instability.
  summary: ArgoCD kubectl request retry rate is high.
expr: |
  sum(
    increase(
      argocd_kubectl_request_retries_total{
        job=~"(argocd|argo-cd).*"
      }[1m]
    )
  ) by (cluster, namespace) > 50
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdHighGrpcErrorRate

{{< code lang="yaml" >}}
alert: ArgoCdHighGrpcErrorRate
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-operational-overview-kask/argocd-operational-overview
  description: ArgoCD job {{ $labels.job }} in namespace {{ $labels.namespace }} has
    had a gRPC error rate above 5% for 10m. Check argocd-server errors and upstream
    dependencies.
  summary: ArgoCD gRPC error rate is high.
expr: |
  sum(
    rate(
      grpc_server_handled_total{
        job=~"(argocd|argo-cd).*",
        grpc_code!="OK"
      }[2m]
    )
  ) by (cluster, namespace, job)
  /
  sum(
    rate(
      grpc_server_handled_total{
        job=~"(argocd|argo-cd).*"
      }[2m]
    )
  ) by (cluster, namespace, job) * 100
  > 5
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoCdHighKubectlPendingExec

{{< code lang="yaml" >}}
alert: ArgoCdHighKubectlPendingExec
annotations:
  dashboard_url: https://grafana.com/d/argo-cd-operational-overview-kask/argocd-operational-overview
  description: ArgoCD in namespace {{ $labels.namespace }} has had more than 10 pending
    kubectl executions for 15m. This may indicate resource contention, slow Kubernetes
    API calls, or slow manifest generation.
  summary: ArgoCD has many pending kubectl executions.
expr: |
  sum(
    argocd_kubectl_exec_pending{
      job=~"(argocd|argo-cd).*"
    }
  ) by (cluster, namespace) > 10
for: 15m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [argo-cd-application-overview](https://github.com/monitoring-mixins/website/blob/master/assets/argo-cd-2/dashboards/argo-cd-application-overview.json)
- [argo-cd-notifications-overview](https://github.com/monitoring-mixins/website/blob/master/assets/argo-cd-2/dashboards/argo-cd-notifications-overview.json)
- [argo-cd-operational-overview](https://github.com/monitoring-mixins/website/blob/master/assets/argo-cd-2/dashboards/argo-cd-operational-overview.json)
