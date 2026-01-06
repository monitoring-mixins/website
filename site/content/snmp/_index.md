---
title: snmp
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/snmp-observ-lib)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/snmp/alerts.yaml).
{{< /panel >}}

### snmp-fc-alerts

##### SNMPInterfaceFCerrors

{{< code lang="yaml" >}}
alert: SNMPInterfaceFCerrors
annotations:
  description: |
    Too many packets with errors (fcIfFramesDiscard) on {{ $labels.instance }}, FC interface {{ $labels.ifName }} ({{$labels.ifAlias}}) for extended period of time (15m).
  summary: Too many packets with errors (fcIfFramesDiscard) on the FC network interface.
expr: |
  (irate(fcIfFramesDiscard{}[5m])) > 0
for: 15m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### SNMPInterfaceFCerrors

{{< code lang="yaml" >}}
alert: SNMPInterfaceFCerrors
annotations:
  description: |
    Too many packets with errors (fcIfInvalidCrcs) on {{ $labels.instance }}, FC interface {{ $labels.ifName }} ({{$labels.ifAlias}}) for extended period of time (15m).
  summary: Too many packets with errors (fcIfInvalidCrcs) on the FC network interface.
expr: |
  (irate(fcIfInvalidCrcs{}[5m])) > 0
for: 15m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### SNMPInterfaceFCerrors

{{< code lang="yaml" >}}
alert: SNMPInterfaceFCerrors
annotations:
  description: |
    Too many packets with errors (fcIfInvalidTxWords) on {{ $labels.instance }}, FC interface {{ $labels.ifName }} ({{$labels.ifAlias}}) for extended period of time (15m).
  summary: Too many packets with errors (fcIfInvalidTxWords) on the FC network interface.
expr: |
  (irate(fcIfInvalidTxWords{}[5m])) > 0
for: 15m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
### snmp-alerts

##### SNMPNodeHasRebooted

{{< code lang="yaml" >}}
alert: SNMPNodeHasRebooted
annotations:
  description: SNMP node {{ $labels.instance }} has rebooted {{ $value | humanize
    }} seconds ago.
  summary: SNMP node has rebooted.
expr: |
  ((
    sysUpTime{}
  )/100) < 600 and ((
    (sysUpTime{} offset 10m)
  )/100) > 600
labels:
  severity: info
{{< /code >}}
 
##### SNMPFRUComponentProblem

{{< code lang="yaml" >}}
alert: SNMPFRUComponentProblem
annotations:
  description: SNMP field replaceable unit is in {{ $labels.cefcFRUPowerOperStatus
    }} status on {{ $labels.instance }}.
  summary: SNMP FRU component is not on.
expr: |
  ((
    cefcFRUPowerOperStatus{cefcFRUPowerOperStatus!="on"}
  )!=0) == 1
labels:
  severity: warning
{{< /code >}}
 
##### SNMPNodeCPUHighUsage

{{< code lang="yaml" >}}
alert: SNMPNodeCPUHighUsage
annotations:
  description: |
    CPU usage on SNMP node {{ $labels.instance }} is above 90%. The current value is {{ $value | printf "%.2f" }}%.
  summary: High CPU usage on SNMP node.
expr: |
  avg by (job,instance) (cpmCPUTotal1minRev{}
  or
  hrProcessorLoad{hrDeviceType="1.3.6.1.2.1.25.3.1.3",}
  or
  jnxOperatingCPU{jnxOperatingContentsIndex="9", }) > 90
for: 15m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### SNMPNodeMemoryUtilization

{{< code lang="yaml" >}}
alert: SNMPNodeMemoryUtilization
annotations:
  description: |
    Memory usage on SNMP node {{ $labels.instance }} is above 90%. The current value is {{ $value | printf "%.2f" }}%.
  summary: High memory usage on SNMP node.
expr: "avg by (job,instance) (# NX-OS:
(
  cpmCPUMemoryUsed{}
  /
  (cpmCPUMemoryUsed{}
  + cpmCPUMemoryFree{}) * 100
)
or
# cisco CISCO-ENHANCED-MEMPOOL-MIB
# cempMemPoolType=\"10\"
  - virtual memory, i.e in ASA(v).
(
  (
    cempMemPoolUsed{}
    /
    (cempMemPoolUsed{}
  + cempMemPoolFree{}) * 100
  ) * on (instance, cempMemPoolIndex, entPhysicalIndex)
  group_left () 
        (cempMemPoolType{} == 10)/10
)
or
# cisco firmwares that
  supports only CISCO-MEMORY-POOL-MIB
# ciscoMemoryPoolType=\"1\" - Processor
(ciscoMemoryPoolUsed{ciscoMemoryPoolType=\"1\",
  }
/
(ciscoMemoryPoolUsed{ciscoMemoryPoolType=\"1\", } + ciscoMemoryPoolFree{ciscoMemoryPoolType=\"1\",
  }) * 100)

or
hrStorageUsed{hrStorageDescr!~\".*(?i:(cache|buffer)).*\", hrStorageType=\"1.3.6.1.2.1.25.2.1.2\",
  }/hrStorageSize{hrStorageDescr!~\".*(?i:(cache|buffer)).*\", hrStorageType=\"1.3.6.1.2.1.25.2.1.2\",
  }*100

or
hrStorageUsed{hrStorageDescr=\"main memory\",hrStorageIndex=\"65536\",
  }/hrStorageSize{hrStorageDescr=\"main memory\",hrStorageIndex=\"65536\", }*100

or
jnxOperatingBuffer{jnxOperatingContentsIndex=\"9\",
  }) > 90
"
labels:
  severity: info
{{< /code >}}
 
##### SNMPInterfaceDown

{{< code lang="yaml" >}}
alert: SNMPInterfaceDown
annotations:
  description: "A critical network interface {{$labels.ifName}} ({{$labels.ifAlias}})
    on {{$labels.instance}} is down. 
Note that only interfaces with ifAdminStatus
    = `up` and matching `ifAlias=~\".*(?i:(critical)).*\"` are being checked and considered
    critical.
"
  summary: Critical network interface is down on SNMP device.
expr: |
  (ifOperStatus{ifAlias=~".*(?i:(critical)).*"}) == 2
  # only alert if interface is adminatratively up:
  and (ifAdminStatus{}) != 2
for: 5m
keep_firing_for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### SNMPInterfaceDown

{{< code lang="yaml" >}}
alert: SNMPInterfaceDown
annotations:
  description: "Network interface {{$labels.ifName}} ({{$labels.ifAlias}}) on {{$labels.instance}}
    is down. 
Only interfaces with ifAdminStatus = `up` and matching `ifAlias=~\".*(?i:(uplink|internet|WAN|ISP)).*\"`
    are being checked.
"
  summary: Network interface is down on SNMP device.
expr: |
  (ifOperStatus{ifAlias=~".*(?i:(uplink|internet|WAN|ISP)).*"}) == 2
  # only alert if interface is adminatratively up:
  and (ifAdminStatus{}) != 2
for: 5m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### SNMPInterfaceDrops

{{< code lang="yaml" >}}
alert: SNMPInterfaceDrops
annotations:
  description: |
    Too many packets discarded on {{ $labels.instance }}, interface {{ $labels.ifName }} ({{$labels.ifAlias}}) for extended period of time (30m).
  summary: Too many packets discarded on the network interface.
expr: |
  ((
    irate(ifInDiscards{}[5m])
  )>0) > 0
  or
  ((
    irate(ifOutDiscards{}[5m])
  )>0) > 0
for: 30m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### SNMPInterfaceErrors

{{< code lang="yaml" >}}
alert: SNMPInterfaceErrors
annotations:
  description: |
    Too many packets with errors on {{ $labels.instance }}, interface {{ $labels.ifName }} ({{$labels.ifAlias}}) for extended period of time (15m).
  summary: Too many packets with errors on the network interface.
expr: |
  ((
    irate(ifInErrors{}[5m])
  )>0) > 0
  or
  ((
    irate(ifOutErrors{}[5m])
  )>0) > 0
for: 15m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### SNMPInterfaceIsFlapping

{{< code lang="yaml" >}}
alert: SNMPInterfaceIsFlapping
annotations:
  description: |
    Network interface {{ $labels.ifName }} ({{$labels.ifAlias}}) is flapping on {{ $labels.instance }}. It has changed its status more than 5 times in the last 5 minutes.
  summary: Network interface is flapping.
expr: |
  changes(ifOperStatus{}[5m]) > 5
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
### snmp-exporter-alerts

##### SNMPExporterEmptyResponse

{{< code lang="yaml" >}}
alert: SNMPExporterEmptyResponse
annotations:
  description: |
    SNMP exporter returns an empty response for node {{ $labels.instance }} and module {{ $labels.module}}. Please check that target support {{ $labels.module }} module as well as authentication and other SNMP settings.
  summary: SNMP exporter returns an empty response.
expr: snmp_scrape_pdus_returned{} <= 1
for: 10m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### SNMPExporterSlowScrape

{{< code lang="yaml" >}}
alert: SNMPExporterSlowScrape
annotations:
  description: |
    SNMP exporter scrape of {{ $labels.instance }} is taking more than 50 seconds. Please check SNMP modules polled and that snmp_exporter is located on the same network as the SNMP target.
  summary: SNMP exporter scrape is slow.
expr: min_over_time(snmp_scrape_duration_seconds{}[5m]) > 50
for: 10m
keep_firing_for: 5m
labels:
  severity: info
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [snmp-fleet](https://github.com/monitoring-mixins/website/blob/master/assets/snmp/dashboards/snmp-fleet.json)
- [snmp-logs](https://github.com/monitoring-mixins/website/blob/master/assets/snmp/dashboards/snmp-logs.json)
- [snmp-overview](https://github.com/monitoring-mixins/website/blob/master/assets/snmp/dashboards/snmp-overview.json)
