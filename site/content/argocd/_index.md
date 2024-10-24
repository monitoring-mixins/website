---
title: argocd
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/argocd-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/argocd/alerts.yaml).
{{< /panel >}}

### ArgoCD

##### ArgoAppOutOfSync

{{< code lang="yaml" >}}
alert: ArgoAppOutOfSync
annotations:
  description: Application {{ $labels.name }} has sync status as {{ $labels.sync_status
    }}.
  summary: Application is OutOfSync.
expr: argocd_app_info{sync_status="OutOfSync"} == 1
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoAppSyncFailed

{{< code lang="yaml" >}}
alert: ArgoAppSyncFailed
annotations:
  description: Application {{ $labels.name }} has sync phase as {{ $labels.phase }}.
  summary: Application Sync Failed.
expr: argocd_app_sync_total{phase!="Succeeded"} == 1
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### ArgoAppMissing

{{< code lang="yaml" >}}
alert: ArgoAppMissing
annotations:
  description: "ArgoCD has not reported any applications data for the past 15 minutes
    which means that it must be down or not functioning properly.  
"
  summary: No reported applications in ArgoCD.
expr: absent(argocd_app_info)
for: 15m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [argocd-overview](https://github.com/monitoring-mixins/website/blob/master/assets/argocd/dashboards/argocd-overview.json)
