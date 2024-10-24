---
title: rabbitmq
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/rabbitmq-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/rabbitmq/alerts.yaml).
{{< /panel >}}

### RabbitMQClusterAlerts

##### RabbitMQMemoryHigh

{{< code lang="yaml" >}}
alert: RabbitMQMemoryHigh
annotations:
  description: A node {{ $labels.instance }} is using more than 90% of allocated RAM.
  summary: RabbitMQ memory usage is high.
expr: rabbitmq_process_resident_memory_bytes / rabbitmq_resident_memory_limit_bytes
  * 100 > 90
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### RabbitMQFileDescriptorsUsage

{{< code lang="yaml" >}}
alert: RabbitMQFileDescriptorsUsage
annotations:
  description: A node {{ $labels.instance }} is using more than 90% of file descriptors.
  summary: RabbitMQ file descriptors usage is high.
expr: rabbitmq_process_open_fds / rabbitmq_process_max_fds * 100 > 90
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### RabbitMQUnroutableMessages

{{< code lang="yaml" >}}
alert: RabbitMQUnroutableMessages
annotations:
  description: A queue has unroutable messages on {{ $labels.instance }}.
  summary: A RabbitMQ queue has unroutable messages.
expr: increase(rabbitmq_channel_messages_unroutable_returned_total[1m]) > 0 or increase(rabbitmq_channel_messages_unroutable_dropped_total[1m])
  > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### RabbitMQNodeNotDistributed

{{< code lang="yaml" >}}
alert: RabbitMQNodeNotDistributed
annotations:
  description: Distribution link state is not 'up' on {{ $labels.instance }}.
  summary: RabbitMQ node not distributed, link state is down.
expr: erlang_vm_dist_node_state < 3
for: 2m
labels:
  severity: critical
{{< /code >}}
 
##### RabbitMQNodeDown

{{< code lang="yaml" >}}
alert: RabbitMQNodeDown
annotations:
  description: |-
    Less than 3 nodes running in RabbitMQ cluster
      VALUE = {{ $value }}
      LABELS = {{ $labels }}
  summary: RabbitMQ node is down.
expr: sum by (rabbitmq_cluster) (rabbitmq_identity_info) < 3
for: 0m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [erlang-memory-allocators](https://github.com/monitoring-mixins/website/blob/master/assets/rabbitmq/dashboards/erlang-memory-allocators.json)
- [rabbitmq-overview](https://github.com/monitoring-mixins/website/blob/master/assets/rabbitmq/dashboards/rabbitmq-overview.json)
