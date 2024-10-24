---
title: openstack
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/openstack-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/openstack/alerts.yaml).
{{< /panel >}}

### openstack-alerts-openstack

##### OpenStackPlacementHighMemoryUsageWarning

{{< code lang="yaml" >}}
alert: OpenStackPlacementHighMemoryUsageWarning
annotations:
  description: The cloud on instance {{$labels.instance}} is using {{ printf "%.0f"
    $value }} percent of its allocated memory, which is above the threshold of 80
    percent.
  summary: The cloud is using a significant percentage of its allocated memory.
expr: |
  100 * openstack_placement_resource_usage{job=~"integrations/openstack", resourcetype="MEMORY_MB"} / clamp_min(openstack_placement_resource_total{job=~"integrations/openstack", resourcetype="MEMORY_MB"}, 1) > 80
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### OpenStackPlacementHighMemoryUsageCritical

{{< code lang="yaml" >}}
alert: OpenStackPlacementHighMemoryUsageCritical
annotations:
  description: The cloud on instance {{$labels.instance}} is using {{ printf "%.0f"
    $value }} percent of its allocated memory, which is above the threshold of 90
    percent.
  summary: The cloud is using a large percentage of its allocated memory, consider
    allocating more resources.
expr: "100 * openstack_placement_resource_usage{job=~\"integrations/openstack\", resourcetype=\"MEMORY_MB\"}
  / clamp_min(openstack_placement_resource_total{job=~\"integrations/openstack\",
  resourcetype=\"MEMORY_MB\"}, 1) > 90 
"
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### OpenStackNovaHighVMMemoryUsage

{{< code lang="yaml" >}}
alert: OpenStackNovaHighVMMemoryUsage
annotations:
  description: Virtual machines on the cloud on {{$labels.instance}} are using {{
    printf "%.0f" $value }} percent of their allocated memory, which is above the
    threshold of 80 percent.
  summary: VMs are using a high percentage of their allocated memory.
expr: |
  100 * openstack_nova_limits_memory_used{job=~"integrations/openstack"} / clamp_min(openstack_nova_limits_memory_max{job=~"integrations/openstack"}, 1) > 80
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### OpenStackNovaHighVMVCPUUsage

{{< code lang="yaml" >}}
alert: OpenStackNovaHighVMVCPUUsage
annotations:
  description: Virtual machines on the cloud on {{$labels.instance}} are using {{
    printf "%.0f" $value }} percent of their allocated virtual CPUs, which is above
    the threshold of 80 percent.
  summary: VMs are using a high percentage of their allocated virtual CPUs.
expr: |
  100 * openstack_nova_limits_vcpus_used{job=~"integrations/openstack"} / clamp_min(openstack_nova_limits_vcpus_max{job=~"integrations/openstack"}, 1) > 80
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### OpenStackNeutronHighDisconnectedPortRate

{{< code lang="yaml" >}}
alert: OpenStackNeutronHighDisconnectedPortRate
annotations:
  description: '{{ printf "%.0f" $value }} percent of ports managed by the Neutron
    service on instance {{$labels.instance}} have no IP addresses assigned to them,
    which is above the threshold of 25'
  summary: A high rate of ports have no IP addresses assigned to them.
expr: |
  100 * openstack_neutron_ports_no_ips{job=~"integrations/openstack"} / clamp_min(openstack_neutron_ports{job=~"integrations/openstack"}, 1) > 25
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### OpenStackNeutronHighInactiveRouterRate

{{< code lang="yaml" >}}
alert: OpenStackNeutronHighInactiveRouterRate
annotations:
  description: '{{ printf "%.0f" $value }} percent of routers managed by the Neutron
    service on instance {{$labels.instance}} are currently inactive, which is above
    the threshold of 15'
  summary: A high rate of routers are currently inactive.
expr: |
  100 * openstack_neutron_routers_not_active{job=~"integrations/openstack"} / clamp_min(openstack_neutron_routers{job=~"integrations/openstack"}, 1) > 15
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### OpenStackCinderHighBackupMemoryUsage

{{< code lang="yaml" >}}
alert: OpenStackCinderHighBackupMemoryUsage
annotations:
  description: Backups managed by the Cinder service on instance {{$labels.instance}}
    are using {{ printf "%.0f" $value }} percent of their allocated memory, which
    is above the threshold of 80 percent.
  summary: Cinder backups are using a large amount of their maximum memory.
expr: |
  100 * openstack_cinder_limits_backup_used_gb{job=~"integrations/openstack"} / clamp_min(openstack_cinder_limits_backup_max_gb{job=~"integrations/openstack"}, 1) > 80
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### OpenStackCinderHighVolumeMemoryUsage

{{< code lang="yaml" >}}
alert: OpenStackCinderHighVolumeMemoryUsage
annotations:
  description: Volumes managed by the Cinder service on instance {{$labels.instance}}
    are using {{ printf "%.0f" $value }} percent of their allocated memory, which
    is above the threshold of 80 percent.
  summary: Cinder volumes are using a large amount of their maximum memory.
expr: |
  100 * openstack_cinder_limits_volume_used_gb{job=~"integrations/openstack"} / clamp_min(openstack_cinder_limits_volume_max_gb{job=~"integrations/openstack"}, 1) > 80
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### OpenStackCinderHighPoolCapacityUsage

{{< code lang="yaml" >}}
alert: OpenStackCinderHighPoolCapacityUsage
annotations:
  description: Pools managed by the Cinder service on instance {{$labels.instance}}
    are using {{ printf "%.0f" $value }} percent of their allocated capacity, which
    is above the threshold of 80 percent.
  summary: Cinder pools are using a large amount of their maximum capacity.
expr: |
  100 * (openstack_cinder_pool_capacity_total_gb{job=~"integrations/openstack"} - openstack_cinder_pool_capacity_free_gb{job=~"integrations/openstack"}) / clamp_min(openstack_cinder_pool_capacity_total_gb{job=~"integrations/openstack"}, 1) > 80
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [*](https://github.com/monitoring-mixins/website/blob/master/assets/openstack/dashboards/*.json)
