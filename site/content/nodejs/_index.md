---
title: nodejs
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/nodejs-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/nodejs/alerts.yaml).
{{< /panel >}}

### NodejsAlerts

##### NodejsDown

{{< code lang="yaml" >}}
alert: NodejsDown
annotations:
  description: Node.js {{$labels.job}} on {{$labels.instance}} is not up.
  summary: Node.js not up.
expr: absent(nodejs_version_info) or (sum by (version) (nodejs_version_info) < 1)
for: 0m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [nodejs-overview](https://github.com/monitoring-mixins/website/blob/master/assets/nodejs/dashboards/nodejs-overview.json)
