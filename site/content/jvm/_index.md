---
title: jvm
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/jvm-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/jvm/alerts.yaml).
{{< /panel >}}

### jvm

##### JvmMemoryFillingUp

{{< code lang="yaml" >}}
alert: JvmMemoryFillingUp
annotations:
  description: JVM memory usage is at {{ printf "%%.0f" $value }} percent over the
    last 5 minutes on {{$labels.instance}}, which is above the threshold of 80%.
  summary: JVM memory filling up.
expr: |
  jvm_memory_bytes_used / jvm_memory_bytes_max{area="heap"} > 0.8
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [jvm-dashboard](https://github.com/monitoring-mixins/website/blob/master/assets/jvm/dashboards/jvm-dashboard.json)
