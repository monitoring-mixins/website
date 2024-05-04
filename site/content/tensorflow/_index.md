---
title: tensorflow
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/tensorflow-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/tensorflow/alerts.yaml).
{{< /panel >}}

### TensorFlowServingAlerts

##### TensorFlowModelRequestHighErrorRate

{{< code lang="yaml" >}}
alert: TensorFlowModelRequestHighErrorRate
annotations:
  description: '{{ printf "%.2f" $value }}% of all model requests are not successful,
    which is above the threshold 30%, indicating a potentially larger issue for {{$labels.instance}}'
  summary: More than 30% of all model requests are not successful.
expr: |
  100 * sum(rate(:tensorflow:serving:request_count{status!="OK"}[5m])) by (instance) / sum(rate(:tensorflow:serving:request_count[5m])) by (instance) > 30
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### TensorFlowServingHighBatchQueuingLatency

{{< code lang="yaml" >}}
alert: TensorFlowServingHighBatchQueuingLatency
annotations:
  description: Batch queuing latency greater than {{ printf "%.2f" $value }}µs, which
    is above the threshold 5000000µs, indicating a potentially larger issue for {{$labels.instance}}
  summary: Batch queuing latency more than 5000000µs.
expr: |
  increase(:tensorflow:serving:batching_session:queuing_latency_sum[2m]) / increase(:tensorflow:serving:batching_session:queuing_latency_count[2m]) > 5000000
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [tensorflow-overview](https://github.com/monitoring-mixins/website/blob/master/assets/tensorflow/dashboards/tensorflow-overview.json)
