---
title: apache-hadoop
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/apache-hadoop-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/apache-hadoop/alerts.yaml).
{{< /panel >}}

### apache-hadoop

##### ApacheHadoopLowHDFSCapacity

{{< code lang="yaml" >}}
alert: ApacheHadoopLowHDFSCapacity
annotations:
  description: '{{ printf "%.0f" $value }} percent remaining HDFS usage on {{$labels.hadoop_cluster}}
    - {{$labels.instance}}, which is below the threshold of 20.'
  summary: Remaining HDFS cluster capacity is low which may result in DataNode failures
    or prevent DataNodes from writing data.
expr: |
  min without(job, name) (100 * hadoop_namenode_capacityremaining / clamp_min(hadoop_namenode_capacitytotal, 1)) < 20
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### ApacheHadoopHDFSMissingBlocks

{{< code lang="yaml" >}}
alert: ApacheHadoopHDFSMissingBlocks
annotations:
  description: '{{ printf "%.0f" $value }} HDFS missing blocks on {{$labels.hadoop_cluster}}
    - {{$labels.instance}}, which is above the threshold of 0.'
  summary: There are missing blocks in the HDFS cluster which may indicate potential
    data loss.
expr: |
  max without(job, name) (hadoop_namenode_missingblocks) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ApacheHadoopHDFSHighVolumeFailures

{{< code lang="yaml" >}}
alert: ApacheHadoopHDFSHighVolumeFailures
annotations:
  description: '{{ printf "%.0f" $value }} HDFS volume failures on {{$labels.hadoop_cluster}}
    - {{$labels.instance}}, which is above the threshold of 0.'
  summary: A volume failure in HDFS cluster may indicate hardware failures.
expr: |
  max without(job, name) (hadoop_namenode_volumefailurestotal) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ApacheHadoopHighDeadDataNodes

{{< code lang="yaml" >}}
alert: ApacheHadoopHighDeadDataNodes
annotations:
  description: '{{ printf "%.0f" $value }} dead HDFS volume failures on {{$labels.hadoop_cluster}}
    - {{$labels.instance}}, which is above the threshold of 0.'
  summary: Number of dead DataNodes has increased, which could result in data loss
    and increased network activity.
expr: |
  max without(job, name) (hadoop_namenode_numdeaddatanodes) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ApacheHadoopHighNodeManagerCPUUsage

{{< code lang="yaml" >}}
alert: ApacheHadoopHighNodeManagerCPUUsage
annotations:
  description: '{{ printf "%.0f" $value }} CPU usage on {{$labels.hadoop_cluster}}
    - {{$labels.instance}}, which is above the threshold of 80.'
  summary: A NodeManager has a CPU usage higher than the configured threshold.
expr: |
  max without(job, name) (100 * hadoop_nodemanager_nodecpuutilization) > 80
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ApacheHadoopHighNodeManagerMemoryUsage

{{< code lang="yaml" >}}
alert: ApacheHadoopHighNodeManagerMemoryUsage
annotations:
  description: '{{ printf "%.0f" $value}} percent NodeManager memory usage on {{$labels.hadoop_cluster}}
    - {{$labels.instance}}, which is above the threshold of 80.'
  summary: A NodeManager has a higher memory utilization than the configured threshold.
expr: |
  max without(job, name) (100 * hadoop_nodemanager_allocatedgb / clamp_min(hadoop_nodemanager_availablegb + hadoop_nodemanager_allocatedgb,1)) > 80
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ApacheHadoopHighResourceManagerVirtualCoreCPUUsage

{{< code lang="yaml" >}}
alert: ApacheHadoopHighResourceManagerVirtualCoreCPUUsage
annotations:
  description: '{{ printf "%.0f" $value }} virtual core CPU usage on {{$labels.hadoop_cluster}}
    - {{$labels.instance}}, which is above the threshold of 80.'
  summary: A ResourceManager has a virtual core CPU usage higher than the configured
    threshold.
expr: |
  max without(job, name) (100 * hadoop_resourcemanager_allocatedvcores / clamp_min(hadoop_resourcemanager_availablevcores + hadoop_resourcemanager_allocatedvcores,1)) > 80
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ApacheHadoopHighResourceManagerMemoryUsage

{{< code lang="yaml" >}}
alert: ApacheHadoopHighResourceManagerMemoryUsage
annotations:
  description: '{{ printf "%.0f" $value}} percent ResourceManager memory usage on
    {{$labels.hadoop_cluster}} - {{$labels.instance}}, which is above the threshold
    of 80.'
  summary: A ResourceManager has a higher memory utilization than the configured threshold.
expr: |
  max without(job, name) (100 * hadoop_resourcemanager_allocatedmb / clamp_min(hadoop_resourcemanager_availablemb + hadoop_resourcemanager_allocatedmb,1)) > 80
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [apache-hadoop-datanode-overview](https://github.com/monitoring-mixins/website/blob/master/assets/apache-hadoop/dashboards/apache-hadoop-datanode-overview.json)
- [apache-hadoop-namenode-overview](https://github.com/monitoring-mixins/website/blob/master/assets/apache-hadoop/dashboards/apache-hadoop-namenode-overview.json)
- [apache-hadoop-nodemanager-overview](https://github.com/monitoring-mixins/website/blob/master/assets/apache-hadoop/dashboards/apache-hadoop-nodemanager-overview.json)
- [apache-hadoop-resourcemanager-overview](https://github.com/monitoring-mixins/website/blob/master/assets/apache-hadoop/dashboards/apache-hadoop-resourcemanager-overview.json)
