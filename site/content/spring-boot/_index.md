---
title: spring-boot
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/spring-boot-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/spring-boot/alerts.yaml).
{{< /panel >}}

### jvm-micrometer-jvm-alerts

##### JvmMemoryFillingUp

{{< code lang="yaml" >}}
alert: JvmMemoryFillingUp
annotations:
  description: JVM heap memory usage is at {{ printf "%.0f" $value }}% over the last
    5 minutes on {{$labels.instance}}, which is above the threshold of 80%.
  summary: JVM heap memory filling up.
expr: ((sum without (id) (jvm_memory_used_bytes{area="heap", job!=""}))/(sum without
  (id) (jvm_memory_max_bytes{area="heap", job!=""} != -1))) * 100 > 80
for: 5m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [jvm-dashboard](https://github.com/monitoring-mixins/website/blob/master/assets/spring-boot/dashboards/jvm-dashboard.json)
