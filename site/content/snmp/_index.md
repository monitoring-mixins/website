---
title: snmp
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/snmp-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/snmp/alerts.yaml).
{{< /panel >}}

### snmp

##### SNMPTargetDown

{{< code lang="yaml" >}}
alert: SNMPTargetDown
annotations:
  description: SNMP target {{$labels.snmp_target}} on instance {{$labels.instance}}
    from job {{$labels.job}} is down.
  summary: SNMP Target is down.
expr: up{job_snmp=~"integrations/snmp.*"} == 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### SNMPTargetInterfaceDown

{{< code lang="yaml" >}}
alert: SNMPTargetInterfaceDown
annotations:
  description: SNMP interface {{$labels.ifDescr}} on target {{$labels.snmp_target}}
    on instance {{$labels.instance}} from job {{$labels.job}} is down.
  summary: Network interface on SNMP target is down.
expr: ifOperStatus{job_snmp=~"integrations/snmp.*"} == 2
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [snmp-overview](https://github.com/monitoring-mixins/website/blob/master/assets/snmp/dashboards/snmp-overview.json)
