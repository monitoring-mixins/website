---
title: syncthing
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/adinhodovic/syncthing-mixin](https://github.com/adinhodovic/syncthing-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/syncthing/alerts.yaml).
{{< /panel >}}

### syncthing

##### SyncthingEventsDropped

{{< code lang="yaml" >}}
alert: SyncthingEventsDropped
annotations:
  dashboard_url: https://grafana.com/d/syncthing-overview-jkwq/syncthing-overview?var-job={{
    $labels.job }}
  description: The job {{ $labels.job }} has dropped events of type {{ $labels.event
    }} in the last minute.
  summary: Syncthing events dropped.
expr: |
  sum(
    increase(
      syncthing_events_total{
        state="dropped"
      }[5m]
    )
  ) by (cluster, job, event)
  > 0
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### SyncthingFolderOutOfSync

{{< code lang="yaml" >}}
alert: SyncthingFolderOutOfSync
annotations:
  dashboard_url: https://grafana.com/d/syncthing-overview-jkwq/syncthing-overview?var-job={{
    $labels.job }}&var-folder={{ $labels.folder }}
  description: The folder {{ $labels.folder }} in job {{ $labels.job }} is out of
    sync for more than 1h.
  summary: Syncthing folder out of sync.
expr: |
  sum(
    syncthing_model_folder_summary{
      scope="need",
      type="bytes"
    }
  ) by (cluster, job, folder)
  > 0
for: 1h
labels:
  severity: info
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [syncthing-overview](https://github.com/monitoring-mixins/website/blob/master/assets/syncthing/dashboards/syncthing-overview.json)
