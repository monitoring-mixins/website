---
title: spinnaker
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [gitlab.com/uneeq-oss/spinnaker-mixin.git](https://gitlab.com/uneeq-oss/spinnaker-mixin.git)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/alerts.yaml).
{{< /panel >}}

### igor

##### PollingMonitorItemsOverThreshold

{{< code lang="yaml" >}}
alert: PollingMonitorItemsOverThreshold
annotations:
  description: '{{ $labels.monitor }} polling monitor for {{ $labels.partition }}
    threshold exceeded, preventing pipeline triggers.'
  runbook_url: https://kb.armory.io/s/article/Hitting-Igor-s-caching-thresholds
  summary: Polling monitor item threshold exceeded.
expr: sum by (monitor, partition) (pollingMonitor_itemsOverThreshold) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [clouddriver](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/dashboards/clouddriver.json)
- [deck](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/dashboards/deck.json)
- [echo](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/dashboards/echo.json)
- [fiat](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/dashboards/fiat.json)
- [front50](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/dashboards/front50.json)
- [gate](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/dashboards/gate.json)
- [igor](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/dashboards/igor.json)
- [orca](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/dashboards/orca.json)
- [rosco](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/dashboards/rosco.json)
- [spinnaker-application-details](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/dashboards/spinnaker-application-details.json)
- [spinnaker-aws-platform](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/dashboards/spinnaker-aws-platform.json)
- [spinnaker-google-platform](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/dashboards/spinnaker-google-platform.json)
- [spinnaker-key-metrics](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/dashboards/spinnaker-key-metrics.json)
- [spinnaker-kubernetes-platform](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/dashboards/spinnaker-kubernetes-platform.json)
- [spinnaker-minimalist](https://github.com/monitoring-mixins/website/blob/master/assets/spinnaker/dashboards/spinnaker-minimalist.json)
