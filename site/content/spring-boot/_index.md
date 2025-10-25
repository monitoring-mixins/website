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
expr: ((sum without (id) (jvm_memory_used{area="heap", job!=""}))/(sum without (id)
  (jvm_memory_max{area="heap", job!=""} != -1))) * 100 > 80
for: 5m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### JvmThreadsDeadlocked

{{< code lang="yaml" >}}
alert: JvmThreadsDeadlocked
annotations:
  description: 'JVM deadlock detected: Threads in the JVM application {{$labels.instance}}
    are in a cyclic dependency with each other. The restart is required to resolve
    the deadlock.'
  summary: JVM deadlock detected.
expr: (jvm_threads_deadlocked{job!=""}) > 0
for: 2m
keep_firing_for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [jvm-dashboard](https://github.com/monitoring-mixins/website/blob/master/assets/spring-boot/dashboards/jvm-dashboard.json)
