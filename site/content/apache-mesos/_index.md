---
title: apache-mesos
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/apache-mesos-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/apache-mesos/alerts.yaml).
{{< /panel >}}

### apache-mesos

##### ApacheMesosHighMemoryUsage

{{< code lang="yaml" >}}
alert: ApacheMesosHighMemoryUsage
annotations:
  description: '{{ printf "%.0f" $value }} percent memory usage on {{$labels.mesos_cluster}},
    which is above the threshold of 90.'
  summary: There is a high memory usage for the cluster.
expr: |
  min without(instance, job, type) (mesos_master_mem{type="percent"}) > 90
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ApacheMesosHighDiskUsage

{{< code lang="yaml" >}}
alert: ApacheMesosHighDiskUsage
annotations:
  description: '{{ printf "%.0f" $value }} percent disk usage on {{$labels.mesos_cluster}},
    which is above the threshold of 90.'
  summary: There is a high disk usage for the cluster.
expr: |
  min without(instance, job, type) (mesos_master_disk{type="percent"}) > 90
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ApacheMesosUnreachableTasks

{{< code lang="yaml" >}}
alert: ApacheMesosUnreachableTasks
annotations:
  description: '{{ printf "%.0f" $value }} unreachable tasks on {{$labels.mesos_cluster}},
    which is above the threshold of 3.'
  summary: There are an unusually high number of unreachable tasks.
expr: |
  max without(instance, job, state) (mesos_master_task_states_current{state="unreachable"}) > 3
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ApacheMesosNoLeaderElected

{{< code lang="yaml" >}}
alert: ApacheMesosNoLeaderElected
annotations:
  description: There is no cluster coordinator on {{$labels.mesos_cluster}}.
  summary: There is currently no cluster coordinator.
expr: |
  max without(instance, job) (mesos_master_elected) == 0
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### ApacheMesosInactiveAgents

{{< code lang="yaml" >}}
alert: ApacheMesosInactiveAgents
annotations:
  description: '{{ printf "%.0f" $value }} inactive agent clients over the last 5m
    which is above the threshold of 1.'
  summary: There are currently inactive agent clients.
expr: |
  max without(instance, job, state) (mesos_master_slaves_state{state=~"connected_inactive|disconnected_inactive"}) > 1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [apache-mesos-overview](https://github.com/monitoring-mixins/website/blob/master/assets/apache-mesos/dashboards/apache-mesos-overview.json)
