---
title: coredns
---

## Overview

CoreDNS mixin provides Grafana dashboard and Prometheus Alerts to monitor CoreDNS. The mixin was introduced in [Kubernetes Node Local DNS Cache blogpost](https://povilasv.me/kubernetes-node-local-dns-cache/) to better help users monitor CoreDNS in Kubernetes. Mixin can also be used to monitor standalone CoreDNS instance without any orchestrators.

{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/povilasv/coredns-mixin](https://github.com/povilasv/coredns-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/coredns/alerts.yaml).
{{< /panel >}}

### coredns

##### CoreDNSDown
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsdown

{{< code lang="yaml" >}}
alert: CoreDNSDown
annotations:
  message: CoreDNS has disappeared from Prometheus target discovery.
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsdown
expr: |
  absent(up{job="kube-dns"} == 1)
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### CoreDNSLatencyHigh
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednslatencyhigh

{{< code lang="yaml" >}}
alert: CoreDNSLatencyHigh
annotations:
  message: CoreDNS has 99th percentile latency of {{ $value }} seconds for server
    {{ $labels.server }} zone {{ $labels.zone }} .
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednslatencyhigh
expr: |
  histogram_quantile(0.99, sum(rate(coredns_dns_request_duration_seconds_bucket{job="kube-dns"}[5m])) by(server, zone, le)) > 4
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### CoreDNSErrorsHigh
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednserrorshigh

{{< code lang="yaml" >}}
alert: CoreDNSErrorsHigh
annotations:
  message: CoreDNS is returning SERVFAIL for {{ $value | humanizePercentage }} of
    requests.
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednserrorshigh
expr: |
  sum(rate(coredns_dns_response_rcode_count_total{job="kube-dns",rcode="SERVFAIL"}[5m]))
    /
  sum(rate(coredns_dns_response_rcode_count_total{job="kube-dns"}[5m])) > 0.03
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### CoreDNSErrorsHigh
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednserrorshigh

{{< code lang="yaml" >}}
alert: CoreDNSErrorsHigh
annotations:
  message: CoreDNS is returning SERVFAIL for {{ $value | humanizePercentage }} of
    requests.
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednserrorshigh
expr: |
  sum(rate(coredns_dns_response_rcode_count_total{job="kube-dns",rcode="SERVFAIL"}[5m]))
    /
  sum(rate(coredns_dns_response_rcode_count_total{job="kube-dns"}[5m])) > 0.01
for: 10m
labels:
  severity: warning
{{< /code >}}
 
### coredns_forward

##### CoreDNSForwardLatencyHigh
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwardlatencyhigh

{{< code lang="yaml" >}}
alert: CoreDNSForwardLatencyHigh
annotations:
  message: CoreDNS has 99th percentile latency of {{ $value }} seconds forwarding
    requests to {{ $labels.to }}.
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwardlatencyhigh
expr: |
  histogram_quantile(0.99, sum(rate(coredns_forward_request_duration_seconds_bucket{job="kube-dns"}[5m])) by(to, le)) > 4
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### CoreDNSForwardErrorsHigh
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwarderrorshigh

{{< code lang="yaml" >}}
alert: CoreDNSForwardErrorsHigh
annotations:
  message: CoreDNS is returning SERVFAIL for {{ $value | humanizePercentage }} of
    forward requests to {{ $labels.to }}.
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwarderrorshigh
expr: |
  sum(rate(coredns_forward_response_rcode_count_total{job="kube-dns",rcode="SERVFAIL"}[5m]))
    /
  sum(rate(coredns_forward_response_rcode_count_total{job="kube-dns"}[5m])) > 0.03
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### CoreDNSForwardErrorsHigh
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwarderrorshigh

{{< code lang="yaml" >}}
alert: CoreDNSForwardErrorsHigh
annotations:
  message: CoreDNS is returning SERVFAIL for {{ $value | humanizePercentage }} of
    forward requests to {{ $labels.to }}.
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwarderrorshigh
expr: |
  sum(rate(coredns_dns_response_rcode_count_total{job="kube-dns",rcode="SERVFAIL"}[5m]))
    /
  sum(rate(coredns_dns_response_rcode_count_total{job="kube-dns"}[5m])) > 0.01
for: 10m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [coredns](https://github.com/monitoring-mixins/website/blob/master/assets/coredns/dashboards/coredns.json)
