---
title: nsq
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/nsq-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/nsq/alerts.yaml).
{{< /panel >}}

### nsq

##### NsqTopicDepthIncreasing

{{< code lang="yaml" >}}
alert: NsqTopicDepthIncreasing
annotations:
  description: |
    Topic {{ $labels.topic }} depth is higher than 100. The current queue is {{ $value }}.
  summary: Topic depth is increasing.
expr: |
  sum by (topic) (nsq_topic_depth) > 100
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### NsqChannelDepthIncreasing

{{< code lang="yaml" >}}
alert: NsqChannelDepthIncreasing
annotations:
  description: |
    Channel {{ $labels.channel }} depth in topic {{ $labels.topic }} is higher than 100. The current queue is {{ $value }}.
  summary: Topic channel depth is increasing.
expr: |
  sum by (topic) (nsq_topic_channel_backend_depth) > 100
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [nsq-instances](https://github.com/monitoring-mixins/website/blob/master/assets/nsq/dashboards/nsq-instances.json)
- [nsq-topics](https://github.com/monitoring-mixins/website/blob/master/assets/nsq/dashboards/nsq-topics.json)
