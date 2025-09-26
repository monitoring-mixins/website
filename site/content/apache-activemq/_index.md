---
title: apache-activemq
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/apache-activemq-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/apache-activemq/alerts.yaml).
{{< /panel >}}

### apache-activemq-alerts

##### ApacheActiveMQHighTopicMemoryUsage

{{< code lang="yaml" >}}
alert: ApacheActiveMQHighTopicMemoryUsage
annotations:
  description: '{{ printf "%.0f" $value }} percent of memory used by topics on {{$labels.instance}}
    in cluster {{$labels.activemq_cluster}}, which is above the threshold of 70 percent.'
  summary: Topic destination memory usage is high, which may result in a reduction
    of the rate at which producers send messages.
expr: |
  sum without (destination) (activemq_topic_memory_percent_usage) > 70
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ApacheActiveMQHighQueueMemoryUsage

{{< code lang="yaml" >}}
alert: ApacheActiveMQHighQueueMemoryUsage
annotations:
  description: '{{ printf "%.0f" $value }} percent of memory used by queues on {{$labels.instance}}
    in cluster {{$labels.activemq_cluster}}, which is above the threshold of 70 percent.'
  summary: Queue destination memory usage is high, which may result in a reduction
    of the rate at which producers send messages.
expr: |
  sum without (destination) (activemq_queue_memory_percent_usage) > 70
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ApacheActiveMQHighStoreMemoryUsage

{{< code lang="yaml" >}}
alert: ApacheActiveMQHighStoreMemoryUsage
annotations:
  description: '{{ printf "%.0f" $value }} percent of store memory used on {{$labels.instance}}
    in cluster {{$labels.activemq_cluster}}, which is above the threshold of 70 percent.'
  summary: Store memory usage is high, which may result in producers unable to send
    messages.
expr: |
  activemq_store_usage_ratio > 70
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ApacheActiveMQHighTemporaryMemoryUsage

{{< code lang="yaml" >}}
alert: ApacheActiveMQHighTemporaryMemoryUsage
annotations:
  description: '{{ printf "%.0f" $value }} percent of temporary memory used on {{$labels.instance}}
    in cluster {{$labels.activemq_cluster}}, which is above the threshold of 70 percent.'
  summary: Temporary memory usage is high, which may result in saturation of messaging
    throughput.
expr: |
  activemq_temp_usage_ratio > 70
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [apache-activemq-cluster-overview](https://github.com/monitoring-mixins/website/blob/master/assets/apache-activemq/dashboards/apache-activemq-cluster-overview.json)
- [apache-activemq-instance-overview](https://github.com/monitoring-mixins/website/blob/master/assets/apache-activemq/dashboards/apache-activemq-instance-overview.json)
- [apache-activemq-logs](https://github.com/monitoring-mixins/website/blob/master/assets/apache-activemq/dashboards/apache-activemq-logs.json)
- [apache-activemq-queue-overview](https://github.com/monitoring-mixins/website/blob/master/assets/apache-activemq/dashboards/apache-activemq-queue-overview.json)
- [apache-activemq-topic-overview](https://github.com/monitoring-mixins/website/blob/master/assets/apache-activemq/dashboards/apache-activemq-topic-overview.json)
