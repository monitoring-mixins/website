---
title: jaeger
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/jaeger-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/jaeger/alerts.yaml).
{{< /panel >}}

### jaeger_alerts

##### JaegerAgentUDPPacketsBeingDropped

{{< code lang="yaml" >}}
alert: JaegerAgentUDPPacketsBeingDropped
annotations:
  message: |
    {{ $labels.job }} {{ $labels.instance }} is dropping {{ printf "%.2f" $value }} UDP packets per second.
expr: rate(jaeger_agent_thrift_udp_server_packets_dropped_total[1m]) > 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### JaegerAgentHTTPServerErrs

{{< code lang="yaml" >}}
alert: JaegerAgentHTTPServerErrs
annotations:
  message: |
    {{ $labels.job }} {{ $labels.instance }} is experiencing {{ printf "%.2f" $value }}% HTTP errors.
expr: 100 * sum(rate(jaeger_agent_http_server_errors_total[1m])) by (instance, job, namespace) / sum(rate(jaeger_agent_http_server_total[1m])) by (instance, job, namespace)> 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### JaegerClientSpansDropped

{{< code lang="yaml" >}}
alert: JaegerClientSpansDropped
annotations:
  message: |
    service {{ $labels.job }} {{ $labels.instance }} is dropping {{ printf "%.2f" $value }}% spans.
expr: 100 * sum(rate(jaeger_reporter_spans{result=~"dropped|err"}[1m])) by (instance, job, namespace) / sum(rate(jaeger_reporter_spans[1m])) by (instance, job, namespace)> 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### JaegerAgentSpansDropped

{{< code lang="yaml" >}}
alert: JaegerAgentSpansDropped
annotations:
  message: |
    agent {{ $labels.job }} {{ $labels.instance }} is dropping {{ printf "%.2f" $value }}% spans.
expr: 100 * sum(rate(jaeger_agent_reporter_batches_failures_total[1m])) by (instance, job, namespace) / sum(rate(jaeger_agent_reporter_batches_submitted_total[1m])) by (instance, job, namespace)> 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### JaegerCollectorQueueNotDraining

{{< code lang="yaml" >}}
alert: JaegerCollectorQueueNotDraining
annotations:
  message: |
    collector {{ $labels.job }} {{ $labels.instance }} is not able to drain the queue.
expr: avg_over_time(jaeger_collector_queue_length[10m]) > 1000
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### JaegerCollectorDroppingSpans

{{< code lang="yaml" >}}
alert: JaegerCollectorDroppingSpans
annotations:
  message: |
    collector {{ $labels.job }} {{ $labels.instance }} is dropping {{ printf "%.2f" $value }}% spans.
expr: 100 * sum(rate(jaeger_collector_spans_dropped_total[1m])) by (instance, job, namespace) / sum(rate(jaeger_collector_spans_received_total[1m])) by (instance, job, namespace)> 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### JaegerSamplingUpdateFailing

{{< code lang="yaml" >}}
alert: JaegerSamplingUpdateFailing
annotations:
  message: |
    {{ $labels.job }} {{ $labels.instance }} is failing {{ printf "%.2f" $value }}% in updating sampling policies.
expr: 100 * sum(rate(jaeger_sampler_queries{result="err"}[1m])) by (instance, job, namespace) / sum(rate(jaeger_sampler_queries[1m])) by (instance, job, namespace)> 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### JaegerCollectorPersistenceSlow

{{< code lang="yaml" >}}
alert: JaegerCollectorPersistenceSlow
annotations:
  message: |
    {{ $labels.job }} {{ $labels.instance }} is slow at persisting spans.
expr: histogram_quantile(0.99, sum by (le) (rate(jaeger_collector_save_latency_bucket[1m]))) > 0.5
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### JaegerThrottlingUpdateFailing

{{< code lang="yaml" >}}
alert: JaegerThrottlingUpdateFailing
annotations:
  message: |
    {{ $labels.job }} {{ $labels.instance }} is failing {{ printf "%.2f" $value }}% in updating throttling policies.
expr: 100 * sum(rate(jaeger_throttler_updates{result="err"}[1m])) by (instance, job, namespace) / sum(rate(jaeger_throttler_updates[1m])) by (instance, job, namespace)> 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### JaegerQueryReqsFailing

{{< code lang="yaml" >}}
alert: JaegerQueryReqsFailing
annotations:
  message: |
    {{ $labels.job }} {{ $labels.instance }} is seeing {{ printf "%.2f" $value }}% query errors on {{ $labels.operation }}.
expr: 100 * sum(rate(jaeger_query_requests_total{result="err"}[1m])) by (instance, job, namespace) / sum(rate(jaeger_query_requests_total[1m])) by (instance, job, namespace)> 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### JaegerCassandraWritesFailing

{{< code lang="yaml" >}}
alert: JaegerCassandraWritesFailing
annotations:
  message: |
    {{ $labels.job }} {{ $labels.instance }} is seeing {{ printf "%.2f" $value }}% query errors on {{ $labels.operation }}.
expr: 100 * sum(rate(jaeger_cassandra_errors_total[1m])) by (instance, job, namespace) / sum(rate(jaeger_cassandra_attempts_total[1m])) by (instance, job, namespace)> 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### JaegerCassandraReadsFailing

{{< code lang="yaml" >}}
alert: JaegerCassandraReadsFailing
annotations:
  message: |
    {{ $labels.job }} {{ $labels.instance }} is seeing {{ printf "%.2f" $value }}% query errors on {{ $labels.operation }}.
expr: 100 * sum(rate(jaeger_cassandra_read_errors_total[1m])) by (instance, job, namespace) / sum(rate(jaeger_cassandra_read_attempts_total[1m])) by (instance, job, namespace)> 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
