---
title: kubernetes
---

## Overview

A set of Grafana dashboards and Prometheus alerts for Kubernetes.

{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/kubernetes-monitoring/kubernetes-mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/alerts.yaml).
{{< /panel >}}

### kubernetes-apps

##### KubePodCrashLooping
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepodcrashlooping

{{< code lang="yaml" >}}
alert: KubePodCrashLooping
annotations:
  description: 'Pod {{ $labels.namespace }}/{{ $labels.pod }} ({{ $labels.container
    }}) is in waiting state (reason: "CrashLoopBackOff").'
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepodcrashlooping
  summary: Pod is crash looping.
expr: |
  max_over_time(kube_pod_container_status_waiting_reason{reason="CrashLoopBackOff", job="kube-state-metrics"}[5m]) >= 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubePodNotReady
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepodnotready

{{< code lang="yaml" >}}
alert: KubePodNotReady
annotations:
  description: Pod {{ $labels.namespace }}/{{ $labels.pod }} has been in a non-ready
    state for longer than 15 minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepodnotready
  summary: Pod has been in a non-ready state for more than 15 minutes.
expr: |
  sum by (namespace, pod, cluster) (
    max by(namespace, pod, cluster) (
      kube_pod_status_phase{job="kube-state-metrics", phase=~"Pending|Unknown|Failed"}
    ) * on(namespace, pod, cluster) group_left(owner_kind) topk by(namespace, pod, cluster) (
      1, max by(namespace, pod, owner_kind, cluster) (kube_pod_owner{owner_kind!="Job"})
    )
  ) > 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeDeploymentGenerationMismatch
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedeploymentgenerationmismatch

{{< code lang="yaml" >}}
alert: KubeDeploymentGenerationMismatch
annotations:
  description: Deployment generation for {{ $labels.namespace }}/{{ $labels.deployment
    }} does not match, this indicates that the Deployment has failed but has not been
    rolled back.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedeploymentgenerationmismatch
  summary: Deployment generation mismatch due to possible roll-back
expr: |
  kube_deployment_status_observed_generation{job="kube-state-metrics"}
    !=
  kube_deployment_metadata_generation{job="kube-state-metrics"}
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeDeploymentReplicasMismatch
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedeploymentreplicasmismatch

{{< code lang="yaml" >}}
alert: KubeDeploymentReplicasMismatch
annotations:
  description: Deployment {{ $labels.namespace }}/{{ $labels.deployment }} has not
    matched the expected number of replicas for longer than 15 minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedeploymentreplicasmismatch
  summary: Deployment has not matched the expected number of replicas.
expr: |
  (
    kube_deployment_spec_replicas{job="kube-state-metrics"}
      >
    kube_deployment_status_replicas_available{job="kube-state-metrics"}
  ) and (
    changes(kube_deployment_status_replicas_updated{job="kube-state-metrics"}[10m])
      ==
    0
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeDeploymentRolloutStuck
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedeploymentrolloutstuck

{{< code lang="yaml" >}}
alert: KubeDeploymentRolloutStuck
annotations:
  description: Rollout of deployment {{ $labels.namespace }}/{{ $labels.deployment
    }} is not progressing for longer than 15 minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedeploymentrolloutstuck
  summary: Deployment rollout is not progressing.
expr: |
  kube_deployment_status_condition{condition="Progressing", status="false",job="kube-state-metrics"}
  != 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeStatefulSetReplicasMismatch
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubestatefulsetreplicasmismatch

{{< code lang="yaml" >}}
alert: KubeStatefulSetReplicasMismatch
annotations:
  description: StatefulSet {{ $labels.namespace }}/{{ $labels.statefulset }} has not
    matched the expected number of replicas for longer than 15 minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubestatefulsetreplicasmismatch
  summary: StatefulSet has not matched the expected number of replicas.
expr: |
  (
    kube_statefulset_status_replicas_ready{job="kube-state-metrics"}
      !=
    kube_statefulset_status_replicas{job="kube-state-metrics"}
  ) and (
    changes(kube_statefulset_status_replicas_updated{job="kube-state-metrics"}[10m])
      ==
    0
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeStatefulSetGenerationMismatch
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubestatefulsetgenerationmismatch

{{< code lang="yaml" >}}
alert: KubeStatefulSetGenerationMismatch
annotations:
  description: StatefulSet generation for {{ $labels.namespace }}/{{ $labels.statefulset
    }} does not match, this indicates that the StatefulSet has failed but has not
    been rolled back.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubestatefulsetgenerationmismatch
  summary: StatefulSet generation mismatch due to possible roll-back
expr: |
  kube_statefulset_status_observed_generation{job="kube-state-metrics"}
    !=
  kube_statefulset_metadata_generation{job="kube-state-metrics"}
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeStatefulSetUpdateNotRolledOut
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubestatefulsetupdatenotrolledout

{{< code lang="yaml" >}}
alert: KubeStatefulSetUpdateNotRolledOut
annotations:
  description: StatefulSet {{ $labels.namespace }}/{{ $labels.statefulset }} update
    has not been rolled out.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubestatefulsetupdatenotrolledout
  summary: StatefulSet update has not been rolled out.
expr: |
  (
    max by(namespace, statefulset, job, cluster) (
      kube_statefulset_status_current_revision{job="kube-state-metrics"}
        unless
      kube_statefulset_status_update_revision{job="kube-state-metrics"}
    )
      *
    (
      kube_statefulset_replicas{job="kube-state-metrics"}
        !=
      kube_statefulset_status_replicas_updated{job="kube-state-metrics"}
    )
  )  and (
    changes(kube_statefulset_status_replicas_updated{job="kube-state-metrics"}[5m])
      ==
    0
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeDaemonSetRolloutStuck
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedaemonsetrolloutstuck

{{< code lang="yaml" >}}
alert: KubeDaemonSetRolloutStuck
annotations:
  description: DaemonSet {{ $labels.namespace }}/{{ $labels.daemonset }} has not finished
    or progressed for at least 15m.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedaemonsetrolloutstuck
  summary: DaemonSet rollout is stuck.
expr: |
  (
    (
      kube_daemonset_status_current_number_scheduled{job="kube-state-metrics"}
       !=
      kube_daemonset_status_desired_number_scheduled{job="kube-state-metrics"}
    ) or (
      kube_daemonset_status_number_misscheduled{job="kube-state-metrics"}
       !=
      0
    ) or (
      kube_daemonset_status_updated_number_scheduled{job="kube-state-metrics"}
       !=
      kube_daemonset_status_desired_number_scheduled{job="kube-state-metrics"}
    ) or (
      kube_daemonset_status_number_available{job="kube-state-metrics"}
       !=
      kube_daemonset_status_desired_number_scheduled{job="kube-state-metrics"}
    )
  ) and (
    changes(kube_daemonset_status_updated_number_scheduled{job="kube-state-metrics"}[5m])
      ==
    0
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeContainerWaiting
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecontainerwaiting

{{< code lang="yaml" >}}
alert: KubeContainerWaiting
annotations:
  description: 'pod/{{ $labels.pod }} in namespace {{ $labels.namespace }} on container
    {{ $labels.container}} has been in waiting state for longer than 1 hour. (reason:
    "{{ $labels.reason }}").'
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecontainerwaiting
  summary: Pod container waiting longer than 1 hour
expr: |
  kube_pod_container_status_waiting_reason{reason!="CrashLoopBackOff", job="kube-state-metrics"} > 0
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### KubeDaemonSetNotScheduled
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedaemonsetnotscheduled

{{< code lang="yaml" >}}
alert: KubeDaemonSetNotScheduled
annotations:
  description: '{{ $value }} Pods of DaemonSet {{ $labels.namespace }}/{{ $labels.daemonset
    }} are not scheduled.'
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedaemonsetnotscheduled
  summary: DaemonSet pods are not scheduled.
expr: |
  kube_daemonset_status_desired_number_scheduled{job="kube-state-metrics"}
    -
  kube_daemonset_status_current_number_scheduled{job="kube-state-metrics"} > 0
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### KubeDaemonSetMisScheduled
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedaemonsetmisscheduled

{{< code lang="yaml" >}}
alert: KubeDaemonSetMisScheduled
annotations:
  description: '{{ $value }} Pods of DaemonSet {{ $labels.namespace }}/{{ $labels.daemonset
    }} are running where they are not supposed to run.'
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedaemonsetmisscheduled
  summary: DaemonSet pods are misscheduled.
expr: |
  kube_daemonset_status_number_misscheduled{job="kube-state-metrics"} > 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeJobNotCompleted
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubejobnotcompleted

{{< code lang="yaml" >}}
alert: KubeJobNotCompleted
annotations:
  description: Job {{ $labels.namespace }}/{{ $labels.job_name }} is taking more than
    {{ "43200" | humanizeDuration }} to complete.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubejobnotcompleted
  summary: Job did not complete in time
expr: |
  time() - max by(namespace, job_name, cluster) (kube_job_status_start_time{job="kube-state-metrics"}
    and
  kube_job_status_active{job="kube-state-metrics"} > 0) > 43200
labels:
  severity: warning
{{< /code >}}
 
##### KubeJobFailed

https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubejobfailed

{{< code lang="yaml" >}}
alert: KubeJobFailed
annotations:
  description: Job {{ $labels.namespace }}/{{ $labels.job_name }} failed to complete.
    Removing failed job after investigation should clear this alert.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubejobfailed
  summary: Job failed to complete.
expr: |
  kube_job_failed{job="kube-state-metrics"}  > 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeHpaReplicasMismatch
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubehpareplicasmismatch

{{< code lang="yaml" >}}
alert: KubeHpaReplicasMismatch
annotations:
  description: HPA {{ $labels.namespace }}/{{ $labels.horizontalpodautoscaler  }}
    has not matched the desired number of replicas for longer than 15 minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubehpareplicasmismatch
  summary: HPA has not matched desired number of replicas.
expr: |
  (kube_horizontalpodautoscaler_status_desired_replicas{job="kube-state-metrics"}
    !=
  kube_horizontalpodautoscaler_status_current_replicas{job="kube-state-metrics"})
    and
  (kube_horizontalpodautoscaler_status_current_replicas{job="kube-state-metrics"}
    >
  kube_horizontalpodautoscaler_spec_min_replicas{job="kube-state-metrics"})
    and
  (kube_horizontalpodautoscaler_status_current_replicas{job="kube-state-metrics"}
    <
  kube_horizontalpodautoscaler_spec_max_replicas{job="kube-state-metrics"})
    and
  changes(kube_horizontalpodautoscaler_status_current_replicas{job="kube-state-metrics"}[15m]) == 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeHpaMaxedOut
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubehpamaxedout

{{< code lang="yaml" >}}
alert: KubeHpaMaxedOut
annotations:
  description: HPA {{ $labels.namespace }}/{{ $labels.horizontalpodautoscaler  }}
    has been running at max replicas for longer than 15 minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubehpamaxedout
  summary: HPA is running at max replicas
expr: |
  kube_horizontalpodautoscaler_status_current_replicas{job="kube-state-metrics"}
    ==
  kube_horizontalpodautoscaler_spec_max_replicas{job="kube-state-metrics"}
for: 15m
labels:
  severity: warning
{{< /code >}}
 
### kubernetes-resources

##### KubeCPUOvercommit
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecpuovercommit

{{< code lang="yaml" >}}
alert: KubeCPUOvercommit
annotations:
  description: Cluster has overcommitted CPU resource requests for Pods by {{ $value
    }} CPU shares and cannot tolerate node failure.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecpuovercommit
  summary: Cluster has overcommitted CPU resource requests.
expr: |
  sum(namespace_cpu:kube_pod_container_resource_requests:sum{}) - (sum(kube_node_status_allocatable{resource="cpu", job="kube-state-metrics"}) - max(kube_node_status_allocatable{resource="cpu", job="kube-state-metrics"})) > 0
  and
  (sum(kube_node_status_allocatable{resource="cpu", job="kube-state-metrics"}) - max(kube_node_status_allocatable{resource="cpu", job="kube-state-metrics"})) > 0
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### KubeMemoryOvercommit
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubememoryovercommit

{{< code lang="yaml" >}}
alert: KubeMemoryOvercommit
annotations:
  description: Cluster has overcommitted memory resource requests for Pods by {{ $value
    | humanize }} bytes and cannot tolerate node failure.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubememoryovercommit
  summary: Cluster has overcommitted memory resource requests.
expr: |
  sum(namespace_memory:kube_pod_container_resource_requests:sum{}) - (sum(kube_node_status_allocatable{resource="memory", job="kube-state-metrics"}) - max(kube_node_status_allocatable{resource="memory", job="kube-state-metrics"})) > 0
  and
  (sum(kube_node_status_allocatable{resource="memory", job="kube-state-metrics"}) - max(kube_node_status_allocatable{resource="memory", job="kube-state-metrics"})) > 0
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### KubeCPUQuotaOvercommit
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecpuquotaovercommit

{{< code lang="yaml" >}}
alert: KubeCPUQuotaOvercommit
annotations:
  description: Cluster has overcommitted CPU resource requests for Namespaces.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecpuquotaovercommit
  summary: Cluster has overcommitted CPU resource requests.
expr: |
  sum(min without(resource) (kube_resourcequota{job="kube-state-metrics", type="hard", resource=~"(cpu|requests.cpu)"}))
    /
  sum(kube_node_status_allocatable{resource="cpu", job="kube-state-metrics"})
    > 1.5
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### KubeMemoryQuotaOvercommit
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubememoryquotaovercommit

{{< code lang="yaml" >}}
alert: KubeMemoryQuotaOvercommit
annotations:
  description: Cluster has overcommitted memory resource requests for Namespaces.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubememoryquotaovercommit
  summary: Cluster has overcommitted memory resource requests.
expr: |
  sum(min without(resource) (kube_resourcequota{job="kube-state-metrics", type="hard", resource=~"(memory|requests.memory)"}))
    /
  sum(kube_node_status_allocatable{resource="memory", job="kube-state-metrics"})
    > 1.5
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### KubeQuotaAlmostFull
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubequotaalmostfull

{{< code lang="yaml" >}}
alert: KubeQuotaAlmostFull
annotations:
  description: Namespace {{ $labels.namespace }} is using {{ $value | humanizePercentage
    }} of its {{ $labels.resource }} quota.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubequotaalmostfull
  summary: Namespace quota is going to be full.
expr: |
  kube_resourcequota{job="kube-state-metrics", type="used"}
    / ignoring(instance, job, type)
  (kube_resourcequota{job="kube-state-metrics", type="hard"} > 0)
    > 0.9 < 1
for: 15m
labels:
  severity: info
{{< /code >}}
 
##### KubeQuotaFullyUsed
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubequotafullyused

{{< code lang="yaml" >}}
alert: KubeQuotaFullyUsed
annotations:
  description: Namespace {{ $labels.namespace }} is using {{ $value | humanizePercentage
    }} of its {{ $labels.resource }} quota.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubequotafullyused
  summary: Namespace quota is fully used.
expr: |
  kube_resourcequota{job="kube-state-metrics", type="used"}
    / ignoring(instance, job, type)
  (kube_resourcequota{job="kube-state-metrics", type="hard"} > 0)
    == 1
for: 15m
labels:
  severity: info
{{< /code >}}
 
##### KubeQuotaExceeded
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubequotaexceeded

{{< code lang="yaml" >}}
alert: KubeQuotaExceeded
annotations:
  description: Namespace {{ $labels.namespace }} is using {{ $value | humanizePercentage
    }} of its {{ $labels.resource }} quota.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubequotaexceeded
  summary: Namespace quota has exceeded the limits.
expr: |
  kube_resourcequota{job="kube-state-metrics", type="used"}
    / ignoring(instance, job, type)
  (kube_resourcequota{job="kube-state-metrics", type="hard"} > 0)
    > 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### CPUThrottlingHigh
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-cputhrottlinghigh

{{< code lang="yaml" >}}
alert: CPUThrottlingHigh
annotations:
  description: '{{ $value | humanizePercentage }} throttling of CPU in namespace {{
    $labels.namespace }} for container {{ $labels.container }} in pod {{ $labels.pod
    }}.'
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-cputhrottlinghigh
  summary: Processes experience elevated CPU throttling.
expr: |
  sum(increase(container_cpu_cfs_throttled_periods_total{container!="", job="cadvisor", }[5m])) without (id, metrics_path, name, image, endpoint, job, node)
    /
  sum(increase(container_cpu_cfs_periods_total{job="cadvisor", }[5m])) without (id, metrics_path, name, image, endpoint, job, node)
    > ( 25 / 100 )
for: 15m
labels:
  severity: info
{{< /code >}}
 
### kubernetes-storage

##### KubePersistentVolumeFillingUp
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumefillingup

{{< code lang="yaml" >}}
alert: KubePersistentVolumeFillingUp
annotations:
  description: The PersistentVolume claimed by {{ $labels.persistentvolumeclaim }}
    in Namespace {{ $labels.namespace }} {{ with $labels.cluster -}} on Cluster {{
    . }} {{- end }} is only {{ $value | humanizePercentage }} free.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumefillingup
  summary: PersistentVolume is filling up.
expr: |
  (
    kubelet_volume_stats_available_bytes{job="kubelet"}
      /
    kubelet_volume_stats_capacity_bytes{job="kubelet"}
  ) < 0.03
  and
  kubelet_volume_stats_used_bytes{job="kubelet"} > 0
  unless on(cluster, namespace, persistentvolumeclaim)
  kube_persistentvolumeclaim_access_mode{ access_mode="ReadOnlyMany"} == 1
  unless on(cluster, namespace, persistentvolumeclaim)
  kube_persistentvolumeclaim_labels{label_excluded_from_alerts="true"} == 1
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### KubePersistentVolumeFillingUp
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumefillingup

{{< code lang="yaml" >}}
alert: KubePersistentVolumeFillingUp
annotations:
  description: Based on recent sampling, the PersistentVolume claimed by {{ $labels.persistentvolumeclaim
    }} in Namespace {{ $labels.namespace }} {{ with $labels.cluster -}} on Cluster
    {{ . }} {{- end }} is expected to fill up within four days. Currently {{ $value
    | humanizePercentage }} is available.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumefillingup
  summary: PersistentVolume is filling up.
expr: |
  (
    kubelet_volume_stats_available_bytes{job="kubelet"}
      /
    kubelet_volume_stats_capacity_bytes{job="kubelet"}
  ) < 0.15
  and
  kubelet_volume_stats_used_bytes{job="kubelet"} > 0
  and
  predict_linear(kubelet_volume_stats_available_bytes{job="kubelet"}[6h], 4 * 24 * 3600) < 0
  unless on(cluster, namespace, persistentvolumeclaim)
  kube_persistentvolumeclaim_access_mode{ access_mode="ReadOnlyMany"} == 1
  unless on(cluster, namespace, persistentvolumeclaim)
  kube_persistentvolumeclaim_labels{label_excluded_from_alerts="true"} == 1
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### KubePersistentVolumeInodesFillingUp
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumeinodesfillingup

{{< code lang="yaml" >}}
alert: KubePersistentVolumeInodesFillingUp
annotations:
  description: The PersistentVolume claimed by {{ $labels.persistentvolumeclaim }}
    in Namespace {{ $labels.namespace }} {{ with $labels.cluster -}} on Cluster {{
    . }} {{- end }} only has {{ $value | humanizePercentage }} free inodes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumeinodesfillingup
  summary: PersistentVolumeInodes are filling up.
expr: |
  (
    kubelet_volume_stats_inodes_free{job="kubelet"}
      /
    kubelet_volume_stats_inodes{job="kubelet"}
  ) < 0.03
  and
  kubelet_volume_stats_inodes_used{job="kubelet"} > 0
  unless on(cluster, namespace, persistentvolumeclaim)
  kube_persistentvolumeclaim_access_mode{ access_mode="ReadOnlyMany"} == 1
  unless on(cluster, namespace, persistentvolumeclaim)
  kube_persistentvolumeclaim_labels{label_excluded_from_alerts="true"} == 1
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### KubePersistentVolumeInodesFillingUp
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumeinodesfillingup

{{< code lang="yaml" >}}
alert: KubePersistentVolumeInodesFillingUp
annotations:
  description: Based on recent sampling, the PersistentVolume claimed by {{ $labels.persistentvolumeclaim
    }} in Namespace {{ $labels.namespace }} {{ with $labels.cluster -}} on Cluster
    {{ . }} {{- end }} is expected to run out of inodes within four days. Currently
    {{ $value | humanizePercentage }} of its inodes are free.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumeinodesfillingup
  summary: PersistentVolumeInodes are filling up.
expr: |
  (
    kubelet_volume_stats_inodes_free{job="kubelet"}
      /
    kubelet_volume_stats_inodes{job="kubelet"}
  ) < 0.15
  and
  kubelet_volume_stats_inodes_used{job="kubelet"} > 0
  and
  predict_linear(kubelet_volume_stats_inodes_free{job="kubelet"}[6h], 4 * 24 * 3600) < 0
  unless on(cluster, namespace, persistentvolumeclaim)
  kube_persistentvolumeclaim_access_mode{ access_mode="ReadOnlyMany"} == 1
  unless on(cluster, namespace, persistentvolumeclaim)
  kube_persistentvolumeclaim_labels{label_excluded_from_alerts="true"} == 1
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### KubePersistentVolumeErrors
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumeerrors

{{< code lang="yaml" >}}
alert: KubePersistentVolumeErrors
annotations:
  description: The persistent volume {{ $labels.persistentvolume }} {{ with $labels.cluster
    -}} on Cluster {{ . }} {{- end }} has status {{ $labels.phase }}.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumeerrors
  summary: PersistentVolume is having issues with provisioning.
expr: |
  kube_persistentvolume_status_phase{phase=~"Failed|Pending",job="kube-state-metrics"} > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
### kubernetes-system

##### KubeVersionMismatch
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeversionmismatch

{{< code lang="yaml" >}}
alert: KubeVersionMismatch
annotations:
  description: There are {{ $value }} different semantic versions of Kubernetes components
    running.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeversionmismatch
  summary: Different semantic versions of Kubernetes components running.
expr: |
  count by (cluster) (count by (git_version, cluster) (label_replace(kubernetes_build_info{job!~"kube-dns|coredns"},"git_version","$1","git_version","(v[0-9]*.[0-9]*).*"))) > 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeClientErrors
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeclienterrors

{{< code lang="yaml" >}}
alert: KubeClientErrors
annotations:
  description: Kubernetes API server client '{{ $labels.job }}/{{ $labels.instance
    }}' is experiencing {{ $value | humanizePercentage }} errors.'
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeclienterrors
  summary: Kubernetes API server client is experiencing errors.
expr: |
  (sum(rate(rest_client_requests_total{job="kube-apiserver",code=~"5.."}[5m])) by (cluster, instance, job, namespace)
    /
  sum(rate(rest_client_requests_total{job="kube-apiserver"}[5m])) by (cluster, instance, job, namespace))
  > 0.01
for: 15m
labels:
  severity: warning
{{< /code >}}
 
### kube-apiserver-slos

##### KubeAPIErrorBudgetBurn
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapierrorbudgetburn

{{< code lang="yaml" >}}
alert: KubeAPIErrorBudgetBurn
annotations:
  description: The API server is burning too much error budget.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapierrorbudgetburn
  summary: The API server is burning too much error budget.
expr: |
  sum by(cluster) (apiserver_request:burnrate1h) > (14.40 * 0.01000)
  and on(cluster)
  sum by(cluster) (apiserver_request:burnrate5m) > (14.40 * 0.01000)
for: 2m
labels:
  long: 1h
  severity: critical
  short: 5m
{{< /code >}}
 
##### KubeAPIErrorBudgetBurn
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapierrorbudgetburn

{{< code lang="yaml" >}}
alert: KubeAPIErrorBudgetBurn
annotations:
  description: The API server is burning too much error budget.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapierrorbudgetburn
  summary: The API server is burning too much error budget.
expr: |
  sum by(cluster) (apiserver_request:burnrate6h) > (6.00 * 0.01000)
  and on(cluster)
  sum by(cluster) (apiserver_request:burnrate30m) > (6.00 * 0.01000)
for: 15m
labels:
  long: 6h
  severity: critical
  short: 30m
{{< /code >}}
 
##### KubeAPIErrorBudgetBurn
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapierrorbudgetburn

{{< code lang="yaml" >}}
alert: KubeAPIErrorBudgetBurn
annotations:
  description: The API server is burning too much error budget.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapierrorbudgetburn
  summary: The API server is burning too much error budget.
expr: |
  sum by(cluster) (apiserver_request:burnrate1d) > (3.00 * 0.01000)
  and on(cluster)
  sum by(cluster) (apiserver_request:burnrate2h) > (3.00 * 0.01000)
for: 1h
labels:
  long: 1d
  severity: warning
  short: 2h
{{< /code >}}
 
##### KubeAPIErrorBudgetBurn
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapierrorbudgetburn

{{< code lang="yaml" >}}
alert: KubeAPIErrorBudgetBurn
annotations:
  description: The API server is burning too much error budget.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapierrorbudgetburn
  summary: The API server is burning too much error budget.
expr: |
  sum by(cluster) (apiserver_request:burnrate3d) > (1.00 * 0.01000)
  and on(cluster)
  sum by(cluster) (apiserver_request:burnrate6h) > (1.00 * 0.01000)
for: 3h
labels:
  long: 3d
  severity: warning
  short: 6h
{{< /code >}}
 
### kubernetes-system-apiserver

##### KubeClientCertificateExpiration
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeclientcertificateexpiration

{{< code lang="yaml" >}}
alert: KubeClientCertificateExpiration
annotations:
  description: A client certificate used to authenticate to kubernetes apiserver is
    expiring in less than 7.0 days.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeclientcertificateexpiration
  summary: Client certificate is about to expire.
expr: |
  histogram_quantile(0.01, sum without (namespace, service, endpoint) (rate(apiserver_client_certificate_expiration_seconds_bucket{job="kube-apiserver"}[5m]))) < 604800
  and
  on(job, cluster, instance) apiserver_client_certificate_expiration_seconds_count{job="kube-apiserver"} > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### KubeClientCertificateExpiration
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeclientcertificateexpiration

{{< code lang="yaml" >}}
alert: KubeClientCertificateExpiration
annotations:
  description: A client certificate used to authenticate to kubernetes apiserver is
    expiring in less than 24.0 hours.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeclientcertificateexpiration
  summary: Client certificate is about to expire.
expr: |
  histogram_quantile(0.01, sum without (namespace, service, endpoint) (rate(apiserver_client_certificate_expiration_seconds_bucket{job="kube-apiserver"}[5m]))) < 86400
  and
  on(job, cluster, instance) apiserver_client_certificate_expiration_seconds_count{job="kube-apiserver"} > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### KubeAggregatedAPIErrors
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeaggregatedapierrors

{{< code lang="yaml" >}}
alert: KubeAggregatedAPIErrors
annotations:
  description: Kubernetes aggregated API {{ $labels.instance }}/{{ $labels.name }}
    has reported {{ $labels.reason }} errors.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeaggregatedapierrors
  summary: Kubernetes aggregated API has reported errors.
expr: |
  sum by(cluster, instance, name, reason)(increase(aggregator_unavailable_apiservice_total{job="kube-apiserver"}[1m])) > 0
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### KubeAggregatedAPIDown
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeaggregatedapidown

{{< code lang="yaml" >}}
alert: KubeAggregatedAPIDown
annotations:
  description: Kubernetes aggregated API {{ $labels.name }}/{{ $labels.namespace }}
    has been only {{ $value | humanize }}% available over the last 10m.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeaggregatedapidown
  summary: Kubernetes aggregated API is down.
expr: |
  (1 - max by(name, namespace, cluster)(avg_over_time(aggregator_unavailable_apiservice{job="kube-apiserver"}[10m]))) * 100 < 85
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### KubeAPIDown
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapidown

{{< code lang="yaml" >}}
alert: KubeAPIDown
annotations:
  description: KubeAPI has disappeared from Prometheus target discovery.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapidown
  summary: Target disappeared from Prometheus target discovery.
expr: |
  absent(up{job="kube-apiserver"} == 1)
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### KubeAPITerminatedRequests
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapiterminatedrequests

{{< code lang="yaml" >}}
alert: KubeAPITerminatedRequests
annotations:
  description: The kubernetes apiserver has terminated {{ $value | humanizePercentage
    }} of its incoming requests.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapiterminatedrequests
  summary: The kubernetes apiserver has terminated {{ $value | humanizePercentage
    }} of its incoming requests.
expr: |
  sum by(cluster) (rate(apiserver_request_terminations_total{job="kube-apiserver"}[10m])) / ( sum by(cluster) (rate(apiserver_request_total{job="kube-apiserver"}[10m])) + sum by(cluster) (rate(apiserver_request_terminations_total{job="kube-apiserver"}[10m])) ) > 0.20
for: 5m
labels:
  severity: warning
{{< /code >}}
 
### kubernetes-system-kubelet

##### KubeNodeNotReady
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubenodenotready

{{< code lang="yaml" >}}
alert: KubeNodeNotReady
annotations:
  description: '{{ $labels.node }} has been unready for more than 15 minutes.'
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubenodenotready
  summary: Node is not ready.
expr: |
  kube_node_status_condition{job="kube-state-metrics",condition="Ready",status="true"} == 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeNodeUnreachable
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubenodeunreachable

{{< code lang="yaml" >}}
alert: KubeNodeUnreachable
annotations:
  description: '{{ $labels.node }} is unreachable and some workloads may be rescheduled.'
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubenodeunreachable
  summary: Node is unreachable.
expr: |
  (kube_node_spec_taint{job="kube-state-metrics",key="node.kubernetes.io/unreachable",effect="NoSchedule"} unless ignoring(key,value) kube_node_spec_taint{job="kube-state-metrics",key=~"ToBeDeletedByClusterAutoscaler|cloud.google.com/impending-node-termination|aws-node-termination-handler/spot-itn"}) == 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeletTooManyPods
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubelettoomanypods

{{< code lang="yaml" >}}
alert: KubeletTooManyPods
annotations:
  description: Kubelet '{{ $labels.node }}' is running at {{ $value | humanizePercentage
    }} of its Pod capacity.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubelettoomanypods
  summary: Kubelet is running at capacity.
expr: |
  count by(cluster, node) (
    (kube_pod_status_phase{job="kube-state-metrics",phase="Running"} == 1) * on(instance,pod,namespace,cluster) group_left(node) topk by(instance,pod,namespace,cluster) (1, kube_pod_info{job="kube-state-metrics"})
  )
  /
  max by(cluster, node) (
    kube_node_status_capacity{job="kube-state-metrics",resource="pods"} != 1
  ) > 0.95
for: 15m
labels:
  severity: info
{{< /code >}}
 
##### KubeNodeReadinessFlapping
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubenodereadinessflapping

{{< code lang="yaml" >}}
alert: KubeNodeReadinessFlapping
annotations:
  description: The readiness status of node {{ $labels.node }} has changed {{ $value
    }} times in the last 15 minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubenodereadinessflapping
  summary: Node readiness status is flapping.
expr: |
  sum(changes(kube_node_status_condition{job="kube-state-metrics",status="true",condition="Ready"}[15m])) by (cluster, node) > 2
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeletPlegDurationHigh
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletplegdurationhigh

{{< code lang="yaml" >}}
alert: KubeletPlegDurationHigh
annotations:
  description: The Kubelet Pod Lifecycle Event Generator has a 99th percentile duration
    of {{ $value }} seconds on node {{ $labels.node }}.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletplegdurationhigh
  summary: Kubelet Pod Lifecycle Event Generator is taking too long to relist.
expr: |
  node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile{quantile="0.99"} >= 10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### KubeletPodStartUpLatencyHigh
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletpodstartuplatencyhigh

{{< code lang="yaml" >}}
alert: KubeletPodStartUpLatencyHigh
annotations:
  description: Kubelet Pod startup 99th percentile latency is {{ $value }} seconds
    on node {{ $labels.node }}.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletpodstartuplatencyhigh
  summary: Kubelet Pod startup latency is too high.
expr: |
  histogram_quantile(0.99, sum(rate(kubelet_pod_worker_duration_seconds_bucket{job="kubelet"}[5m])) by (cluster, instance, le)) * on(cluster, instance) group_left(node) kubelet_node_name{job="kubelet"} > 60
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeletClientCertificateExpiration
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletclientcertificateexpiration

{{< code lang="yaml" >}}
alert: KubeletClientCertificateExpiration
annotations:
  description: Client certificate for Kubelet on node {{ $labels.node }} expires in
    {{ $value | humanizeDuration }}.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletclientcertificateexpiration
  summary: Kubelet client certificate is about to expire.
expr: |
  kubelet_certificate_manager_client_ttl_seconds < 604800
labels:
  severity: warning
{{< /code >}}
 
##### KubeletClientCertificateExpiration
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletclientcertificateexpiration

{{< code lang="yaml" >}}
alert: KubeletClientCertificateExpiration
annotations:
  description: Client certificate for Kubelet on node {{ $labels.node }} expires in
    {{ $value | humanizeDuration }}.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletclientcertificateexpiration
  summary: Kubelet client certificate is about to expire.
expr: |
  kubelet_certificate_manager_client_ttl_seconds < 86400
labels:
  severity: critical
{{< /code >}}
 
##### KubeletServerCertificateExpiration
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletservercertificateexpiration

{{< code lang="yaml" >}}
alert: KubeletServerCertificateExpiration
annotations:
  description: Server certificate for Kubelet on node {{ $labels.node }} expires in
    {{ $value | humanizeDuration }}.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletservercertificateexpiration
  summary: Kubelet server certificate is about to expire.
expr: |
  kubelet_certificate_manager_server_ttl_seconds < 604800
labels:
  severity: warning
{{< /code >}}
 
##### KubeletServerCertificateExpiration
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletservercertificateexpiration

{{< code lang="yaml" >}}
alert: KubeletServerCertificateExpiration
annotations:
  description: Server certificate for Kubelet on node {{ $labels.node }} expires in
    {{ $value | humanizeDuration }}.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletservercertificateexpiration
  summary: Kubelet server certificate is about to expire.
expr: |
  kubelet_certificate_manager_server_ttl_seconds < 86400
labels:
  severity: critical
{{< /code >}}
 
##### KubeletClientCertificateRenewalErrors
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletclientcertificaterenewalerrors

{{< code lang="yaml" >}}
alert: KubeletClientCertificateRenewalErrors
annotations:
  description: Kubelet on node {{ $labels.node }} has failed to renew its client certificate
    ({{ $value | humanize }} errors in the last 5 minutes).
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletclientcertificaterenewalerrors
  summary: Kubelet has failed to renew its client certificate.
expr: |
  increase(kubelet_certificate_manager_client_expiration_renew_errors[5m]) > 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeletServerCertificateRenewalErrors
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletservercertificaterenewalerrors

{{< code lang="yaml" >}}
alert: KubeletServerCertificateRenewalErrors
annotations:
  description: Kubelet on node {{ $labels.node }} has failed to renew its server certificate
    ({{ $value | humanize }} errors in the last 5 minutes).
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletservercertificaterenewalerrors
  summary: Kubelet has failed to renew its server certificate.
expr: |
  increase(kubelet_server_expiration_renew_errors[5m]) > 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeletDown
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletdown

{{< code lang="yaml" >}}
alert: KubeletDown
annotations:
  description: Kubelet has disappeared from Prometheus target discovery.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletdown
  summary: Target disappeared from Prometheus target discovery.
expr: |
  absent(up{job="kubelet"} == 1)
for: 15m
labels:
  severity: critical
{{< /code >}}
 
### kubernetes-system-scheduler

##### KubeSchedulerDown
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeschedulerdown

{{< code lang="yaml" >}}
alert: KubeSchedulerDown
annotations:
  description: KubeScheduler has disappeared from Prometheus target discovery.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeschedulerdown
  summary: Target disappeared from Prometheus target discovery.
expr: |
  absent(up{job="kube-scheduler"} == 1)
for: 15m
labels:
  severity: critical
{{< /code >}}
 
### kubernetes-system-controller-manager

##### KubeControllerManagerDown
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecontrollermanagerdown

{{< code lang="yaml" >}}
alert: KubeControllerManagerDown
annotations:
  description: KubeControllerManager has disappeared from Prometheus target discovery.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecontrollermanagerdown
  summary: Target disappeared from Prometheus target discovery.
expr: |
  absent(up{job="kube-controller-manager"} == 1)
for: 15m
labels:
  severity: critical
{{< /code >}}
 
### kubernetes-system-kube-proxy

##### KubeProxyDown
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeproxydown

{{< code lang="yaml" >}}
alert: KubeProxyDown
annotations:
  description: KubeProxy has disappeared from Prometheus target discovery.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeproxydown
  summary: Target disappeared from Prometheus target discovery.
expr: |
  absent(up{job="kube-proxy"} == 1)
for: 15m
labels:
  severity: critical
{{< /code >}}
 
## Recording rules

{{< panel style="warning" >}}
Complete list of pregenerated recording rules is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/rules.yaml).
{{< /panel >}}

### kube-apiserver-availability.rules

##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  avg_over_time(code_verb:apiserver_request_total:increase1h[30d]) * 24 * 30
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, code) (code_verb:apiserver_request_total:increase30d{verb=~"LIST|GET"})
labels:
  verb: read
record: code:apiserver_request_total:increase30d
{{< /code >}}
 
##### code:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, code) (code_verb:apiserver_request_total:increase30d{verb=~"POST|PUT|PATCH|DELETE"})
labels:
  verb: write
record: code:apiserver_request_total:increase30d
{{< /code >}}
 
##### cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase1h

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, verb, scope, le) (increase(apiserver_request_sli_duration_seconds_bucket[1h]))
record: cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase1h
{{< /code >}}
 
##### cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, verb, scope, le) (avg_over_time(cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase1h[30d]) * 24 * 30)
record: cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d
{{< /code >}}
 
##### cluster_verb_scope:apiserver_request_sli_duration_seconds_count:increase1h

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, verb, scope) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase1h{le="+Inf"})
record: cluster_verb_scope:apiserver_request_sli_duration_seconds_count:increase1h
{{< /code >}}
 
##### cluster_verb_scope:apiserver_request_sli_duration_seconds_count:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, verb, scope) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{le="+Inf"})
record: cluster_verb_scope:apiserver_request_sli_duration_seconds_count:increase30d
{{< /code >}}
 
##### apiserver_request:availability30d

{{< code lang="yaml" >}}
expr: |
  1 - (
    (
      # write too slow
      sum by (cluster) (cluster_verb_scope:apiserver_request_sli_duration_seconds_count:increase30d{verb=~"POST|PUT|PATCH|DELETE"})
      -
      sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~"POST|PUT|PATCH|DELETE",le=~"1(\.0)?"})
    ) +
    (
      # read too slow
      sum by (cluster) (cluster_verb_scope:apiserver_request_sli_duration_seconds_count:increase30d{verb=~"LIST|GET"})
      -
      (
        (
          sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~"LIST|GET",scope=~"resource|",le=~"1(\.0)?"})
          or
          vector(0)
        )
        +
        sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~"LIST|GET",scope="namespace",le=~"5(\.0)?"})
        +
        sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~"LIST|GET",scope="cluster",le=~"30(\.0)?"})
      )
    ) +
    # errors
    sum by (cluster) (code:apiserver_request_total:increase30d{code=~"5.."} or vector(0))
  )
  /
  sum by (cluster) (code:apiserver_request_total:increase30d)
labels:
  verb: all
record: apiserver_request:availability30d
{{< /code >}}
 
##### apiserver_request:availability30d

{{< code lang="yaml" >}}
expr: |
  1 - (
    sum by (cluster) (cluster_verb_scope:apiserver_request_sli_duration_seconds_count:increase30d{verb=~"LIST|GET"})
    -
    (
      # too slow
      (
        sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~"LIST|GET",scope=~"resource|",le=~"1(\.0)?"})
        or
        vector(0)
      )
      +
      sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~"LIST|GET",scope="namespace",le=~"5(\.0)?"})
      +
      sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~"LIST|GET",scope="cluster",le=~"30(\.0)?"})
    )
    +
    # errors
    sum by (cluster) (code:apiserver_request_total:increase30d{verb="read",code=~"5.."} or vector(0))
  )
  /
  sum by (cluster) (code:apiserver_request_total:increase30d{verb="read"})
labels:
  verb: read
record: apiserver_request:availability30d
{{< /code >}}
 
##### apiserver_request:availability30d

{{< code lang="yaml" >}}
expr: |
  1 - (
    (
      # too slow
      sum by (cluster) (cluster_verb_scope:apiserver_request_sli_duration_seconds_count:increase30d{verb=~"POST|PUT|PATCH|DELETE"})
      -
      sum by (cluster) (cluster_verb_scope_le:apiserver_request_sli_duration_seconds_bucket:increase30d{verb=~"POST|PUT|PATCH|DELETE",le=~"1(\.0)?"})
    )
    +
    # errors
    sum by (cluster) (code:apiserver_request_total:increase30d{verb="write",code=~"5.."} or vector(0))
  )
  /
  sum by (cluster) (code:apiserver_request_total:increase30d{verb="write"})
labels:
  verb: write
record: apiserver_request:availability30d
{{< /code >}}
 
##### code_resource:apiserver_request_total:rate5m

{{< code lang="yaml" >}}
expr: |
  sum by (cluster,code,resource) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[5m]))
labels:
  verb: read
record: code_resource:apiserver_request_total:rate5m
{{< /code >}}
 
##### code_resource:apiserver_request_total:rate5m

{{< code lang="yaml" >}}
expr: |
  sum by (cluster,code,resource) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[5m]))
labels:
  verb: write
record: code_resource:apiserver_request_total:rate5m
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase1h

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET|POST|PUT|PATCH|DELETE",code=~"2.."}[1h]))
record: code_verb:apiserver_request_total:increase1h
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase1h

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET|POST|PUT|PATCH|DELETE",code=~"3.."}[1h]))
record: code_verb:apiserver_request_total:increase1h
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase1h

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET|POST|PUT|PATCH|DELETE",code=~"4.."}[1h]))
record: code_verb:apiserver_request_total:increase1h
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase1h

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET|POST|PUT|PATCH|DELETE",code=~"5.."}[1h]))
record: code_verb:apiserver_request_total:increase1h
{{< /code >}}
 
### kube-apiserver-burnrate.rules

##### apiserver_request:burnrate1d

{{< code lang="yaml" >}}
expr: |
  (
    (
      # too slow
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[1d]))
      -
      (
        (
          sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope=~"resource|",le=~"1(\.0)?"}[1d]))
          or
          vector(0)
        )
        +
        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="namespace",le=~"5(\.0)?"}[1d]))
        +
        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="cluster",le=~"30(\.0)?"}[1d]))
      )
    )
    +
    # errors
    sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET",code=~"5.."}[1d]))
  )
  /
  sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[1d]))
labels:
  verb: read
record: apiserver_request:burnrate1d
{{< /code >}}
 
##### apiserver_request:burnrate1h

{{< code lang="yaml" >}}
expr: |
  (
    (
      # too slow
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[1h]))
      -
      (
        (
          sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope=~"resource|",le=~"1(\.0)?"}[1h]))
          or
          vector(0)
        )
        +
        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="namespace",le=~"5(\.0)?"}[1h]))
        +
        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="cluster",le=~"30(\.0)?"}[1h]))
      )
    )
    +
    # errors
    sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET",code=~"5.."}[1h]))
  )
  /
  sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[1h]))
labels:
  verb: read
record: apiserver_request:burnrate1h
{{< /code >}}
 
##### apiserver_request:burnrate2h

{{< code lang="yaml" >}}
expr: |
  (
    (
      # too slow
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[2h]))
      -
      (
        (
          sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope=~"resource|",le=~"1(\.0)?"}[2h]))
          or
          vector(0)
        )
        +
        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="namespace",le=~"5(\.0)?"}[2h]))
        +
        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="cluster",le=~"30(\.0)?"}[2h]))
      )
    )
    +
    # errors
    sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET",code=~"5.."}[2h]))
  )
  /
  sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[2h]))
labels:
  verb: read
record: apiserver_request:burnrate2h
{{< /code >}}
 
##### apiserver_request:burnrate30m

{{< code lang="yaml" >}}
expr: |
  (
    (
      # too slow
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[30m]))
      -
      (
        (
          sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope=~"resource|",le=~"1(\.0)?"}[30m]))
          or
          vector(0)
        )
        +
        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="namespace",le=~"5(\.0)?"}[30m]))
        +
        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="cluster",le=~"30(\.0)?"}[30m]))
      )
    )
    +
    # errors
    sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET",code=~"5.."}[30m]))
  )
  /
  sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[30m]))
labels:
  verb: read
record: apiserver_request:burnrate30m
{{< /code >}}
 
##### apiserver_request:burnrate3d

{{< code lang="yaml" >}}
expr: |
  (
    (
      # too slow
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[3d]))
      -
      (
        (
          sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope=~"resource|",le=~"1(\.0)?"}[3d]))
          or
          vector(0)
        )
        +
        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="namespace",le=~"5(\.0)?"}[3d]))
        +
        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="cluster",le=~"30(\.0)?"}[3d]))
      )
    )
    +
    # errors
    sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET",code=~"5.."}[3d]))
  )
  /
  sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[3d]))
labels:
  verb: read
record: apiserver_request:burnrate3d
{{< /code >}}
 
##### apiserver_request:burnrate5m

{{< code lang="yaml" >}}
expr: |
  (
    (
      # too slow
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[5m]))
      -
      (
        (
          sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope=~"resource|",le=~"1(\.0)?"}[5m]))
          or
          vector(0)
        )
        +
        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="namespace",le=~"5(\.0)?"}[5m]))
        +
        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="cluster",le=~"30(\.0)?"}[5m]))
      )
    )
    +
    # errors
    sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET",code=~"5.."}[5m]))
  )
  /
  sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[5m]))
labels:
  verb: read
record: apiserver_request:burnrate5m
{{< /code >}}
 
##### apiserver_request:burnrate6h

{{< code lang="yaml" >}}
expr: |
  (
    (
      # too slow
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[6h]))
      -
      (
        (
          sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope=~"resource|",le=~"1(\.0)?"}[6h]))
          or
          vector(0)
        )
        +
        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="namespace",le=~"5(\.0)?"}[6h]))
        +
        sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward",scope="cluster",le=~"30(\.0)?"}[6h]))
      )
    )
    +
    # errors
    sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET",code=~"5.."}[6h]))
  )
  /
  sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[6h]))
labels:
  verb: read
record: apiserver_request:burnrate6h
{{< /code >}}
 
##### apiserver_request:burnrate1d

{{< code lang="yaml" >}}
expr: |
  (
    (
      # too slow
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[1d]))
      -
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward",le=~"1(\.0)?"}[1d]))
    )
    +
    sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[1d]))
  )
  /
  sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[1d]))
labels:
  verb: write
record: apiserver_request:burnrate1d
{{< /code >}}
 
##### apiserver_request:burnrate1h

{{< code lang="yaml" >}}
expr: |
  (
    (
      # too slow
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[1h]))
      -
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward",le=~"1(\.0)?"}[1h]))
    )
    +
    sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[1h]))
  )
  /
  sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[1h]))
labels:
  verb: write
record: apiserver_request:burnrate1h
{{< /code >}}
 
##### apiserver_request:burnrate2h

{{< code lang="yaml" >}}
expr: |
  (
    (
      # too slow
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[2h]))
      -
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward",le=~"1(\.0)?"}[2h]))
    )
    +
    sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[2h]))
  )
  /
  sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[2h]))
labels:
  verb: write
record: apiserver_request:burnrate2h
{{< /code >}}
 
##### apiserver_request:burnrate30m

{{< code lang="yaml" >}}
expr: |
  (
    (
      # too slow
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[30m]))
      -
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward",le=~"1(\.0)?"}[30m]))
    )
    +
    sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[30m]))
  )
  /
  sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[30m]))
labels:
  verb: write
record: apiserver_request:burnrate30m
{{< /code >}}
 
##### apiserver_request:burnrate3d

{{< code lang="yaml" >}}
expr: |
  (
    (
      # too slow
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[3d]))
      -
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward",le=~"1(\.0)?"}[3d]))
    )
    +
    sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[3d]))
  )
  /
  sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[3d]))
labels:
  verb: write
record: apiserver_request:burnrate3d
{{< /code >}}
 
##### apiserver_request:burnrate5m

{{< code lang="yaml" >}}
expr: |
  (
    (
      # too slow
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[5m]))
      -
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward",le=~"1(\.0)?"}[5m]))
    )
    +
    sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[5m]))
  )
  /
  sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[5m]))
labels:
  verb: write
record: apiserver_request:burnrate5m
{{< /code >}}
 
##### apiserver_request:burnrate6h

{{< code lang="yaml" >}}
expr: |
  (
    (
      # too slow
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_count{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[6h]))
      -
      sum by (cluster) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward",le=~"1(\.0)?"}[6h]))
    )
    +
    sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[6h]))
  )
  /
  sum by (cluster) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[6h]))
labels:
  verb: write
record: apiserver_request:burnrate6h
{{< /code >}}
 
### kube-apiserver-histogram.rules

##### cluster_quantile:apiserver_request_sli_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99, sum by (cluster, le, resource) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",subresource!~"proxy|attach|log|exec|portforward"}[5m]))) > 0
labels:
  quantile: "0.99"
  verb: read
record: cluster_quantile:apiserver_request_sli_duration_seconds:histogram_quantile
{{< /code >}}
 
##### cluster_quantile:apiserver_request_sli_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99, sum by (cluster, le, resource) (rate(apiserver_request_sli_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",subresource!~"proxy|attach|log|exec|portforward"}[5m]))) > 0
labels:
  quantile: "0.99"
  verb: write
record: cluster_quantile:apiserver_request_sli_duration_seconds:histogram_quantile
{{< /code >}}
 
### k8s.rules.container_cpu_usage_seconds_total

##### node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, namespace, pod, container) (
    irate(container_cpu_usage_seconds_total{job="cadvisor", image!=""}[5m])
  ) * on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (
    1, max by(cluster, namespace, pod, node) (kube_pod_info{node!=""})
  )
record: node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate
{{< /code >}}
 
### k8s.rules.container_memory_working_set_bytes

##### node_namespace_pod_container:container_memory_working_set_bytes

{{< code lang="yaml" >}}
expr: |
  container_memory_working_set_bytes{job="cadvisor", image!=""}
  * on (cluster, namespace, pod) group_left(node) topk by(cluster, namespace, pod) (1,
    max by(cluster, namespace, pod, node) (kube_pod_info{node!=""})
  )
record: node_namespace_pod_container:container_memory_working_set_bytes
{{< /code >}}
 
### k8s.rules.container_memory_rss

##### node_namespace_pod_container:container_memory_rss

{{< code lang="yaml" >}}
expr: |
  container_memory_rss{job="cadvisor", image!=""}
  * on (cluster, namespace, pod) group_left(node) topk by(cluster, namespace, pod) (1,
    max by(cluster, namespace, pod, node) (kube_pod_info{node!=""})
  )
record: node_namespace_pod_container:container_memory_rss
{{< /code >}}
 
### k8s.rules.container_memory_cache

##### node_namespace_pod_container:container_memory_cache

{{< code lang="yaml" >}}
expr: |
  container_memory_cache{job="cadvisor", image!=""}
  * on (cluster, namespace, pod) group_left(node) topk by(cluster, namespace, pod) (1,
    max by(cluster, namespace, pod, node) (kube_pod_info{node!=""})
  )
record: node_namespace_pod_container:container_memory_cache
{{< /code >}}
 
### k8s.rules.container_memory_swap

##### node_namespace_pod_container:container_memory_swap

{{< code lang="yaml" >}}
expr: |
  container_memory_swap{job="cadvisor", image!=""}
  * on (cluster, namespace, pod) group_left(node) topk by(cluster, namespace, pod) (1,
    max by(cluster, namespace, pod, node) (kube_pod_info{node!=""})
  )
record: node_namespace_pod_container:container_memory_swap
{{< /code >}}
 
### k8s.rules.container_memory_requests

##### cluster:namespace:pod_memory:active:kube_pod_container_resource_requests

{{< code lang="yaml" >}}
expr: |
  kube_pod_container_resource_requests{resource="memory",job="kube-state-metrics"}  * on (namespace, pod, cluster)
  group_left() max by (namespace, pod, cluster) (
    (kube_pod_status_phase{phase=~"Pending|Running"} == 1)
  )
record: cluster:namespace:pod_memory:active:kube_pod_container_resource_requests
{{< /code >}}
 
##### namespace_memory:kube_pod_container_resource_requests:sum

{{< code lang="yaml" >}}
expr: |
  sum by (namespace, cluster) (
      sum by (namespace, pod, cluster) (
          max by (namespace, pod, container, cluster) (
            kube_pod_container_resource_requests{resource="memory",job="kube-state-metrics"}
          ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (
            kube_pod_status_phase{phase=~"Pending|Running"} == 1
          )
      )
  )
record: namespace_memory:kube_pod_container_resource_requests:sum
{{< /code >}}
 
### k8s.rules.container_cpu_requests

##### cluster:namespace:pod_cpu:active:kube_pod_container_resource_requests

{{< code lang="yaml" >}}
expr: |
  kube_pod_container_resource_requests{resource="cpu",job="kube-state-metrics"}  * on (namespace, pod, cluster)
  group_left() max by (namespace, pod, cluster) (
    (kube_pod_status_phase{phase=~"Pending|Running"} == 1)
  )
record: cluster:namespace:pod_cpu:active:kube_pod_container_resource_requests
{{< /code >}}
 
##### namespace_cpu:kube_pod_container_resource_requests:sum

{{< code lang="yaml" >}}
expr: |
  sum by (namespace, cluster) (
      sum by (namespace, pod, cluster) (
          max by (namespace, pod, container, cluster) (
            kube_pod_container_resource_requests{resource="cpu",job="kube-state-metrics"}
          ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (
            kube_pod_status_phase{phase=~"Pending|Running"} == 1
          )
      )
  )
record: namespace_cpu:kube_pod_container_resource_requests:sum
{{< /code >}}
 
### k8s.rules.container_memory_limits

##### cluster:namespace:pod_memory:active:kube_pod_container_resource_limits

{{< code lang="yaml" >}}
expr: |
  kube_pod_container_resource_limits{resource="memory",job="kube-state-metrics"}  * on (namespace, pod, cluster)
  group_left() max by (namespace, pod, cluster) (
    (kube_pod_status_phase{phase=~"Pending|Running"} == 1)
  )
record: cluster:namespace:pod_memory:active:kube_pod_container_resource_limits
{{< /code >}}
 
##### namespace_memory:kube_pod_container_resource_limits:sum

{{< code lang="yaml" >}}
expr: |
  sum by (namespace, cluster) (
      sum by (namespace, pod, cluster) (
          max by (namespace, pod, container, cluster) (
            kube_pod_container_resource_limits{resource="memory",job="kube-state-metrics"}
          ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (
            kube_pod_status_phase{phase=~"Pending|Running"} == 1
          )
      )
  )
record: namespace_memory:kube_pod_container_resource_limits:sum
{{< /code >}}
 
### k8s.rules.container_cpu_limits

##### cluster:namespace:pod_cpu:active:kube_pod_container_resource_limits

{{< code lang="yaml" >}}
expr: |
  kube_pod_container_resource_limits{resource="cpu",job="kube-state-metrics"}  * on (namespace, pod, cluster)
  group_left() max by (namespace, pod, cluster) (
   (kube_pod_status_phase{phase=~"Pending|Running"} == 1)
   )
record: cluster:namespace:pod_cpu:active:kube_pod_container_resource_limits
{{< /code >}}
 
##### namespace_cpu:kube_pod_container_resource_limits:sum

{{< code lang="yaml" >}}
expr: |
  sum by (namespace, cluster) (
      sum by (namespace, pod, cluster) (
          max by (namespace, pod, container, cluster) (
            kube_pod_container_resource_limits{resource="cpu",job="kube-state-metrics"}
          ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (
            kube_pod_status_phase{phase=~"Pending|Running"} == 1
          )
      )
  )
record: namespace_cpu:kube_pod_container_resource_limits:sum
{{< /code >}}
 
### k8s.rules.pod_owner

##### namespace_workload_pod:kube_pod_owner:relabel

{{< code lang="yaml" >}}
expr: |
  max by (cluster, namespace, workload, pod) (
    label_replace(
      label_replace(
        kube_pod_owner{job="kube-state-metrics", owner_kind="ReplicaSet"},
        "replicaset", "$1", "owner_name", "(.*)"
      ) * on(replicaset, namespace) group_left(owner_name) topk by(replicaset, namespace) (
        1, max by (replicaset, namespace, owner_name) (
          kube_replicaset_owner{job="kube-state-metrics"}
        )
      ),
      "workload", "$1", "owner_name", "(.*)"
    )
  )
labels:
  workload_type: deployment
record: namespace_workload_pod:kube_pod_owner:relabel
{{< /code >}}
 
##### namespace_workload_pod:kube_pod_owner:relabel

{{< code lang="yaml" >}}
expr: |
  max by (cluster, namespace, workload, pod) (
    label_replace(
      kube_pod_owner{job="kube-state-metrics", owner_kind="DaemonSet"},
      "workload", "$1", "owner_name", "(.*)"
    )
  )
labels:
  workload_type: daemonset
record: namespace_workload_pod:kube_pod_owner:relabel
{{< /code >}}
 
##### namespace_workload_pod:kube_pod_owner:relabel

{{< code lang="yaml" >}}
expr: |
  max by (cluster, namespace, workload, pod) (
    label_replace(
      kube_pod_owner{job="kube-state-metrics", owner_kind="StatefulSet"},
      "workload", "$1", "owner_name", "(.*)"
    )
  )
labels:
  workload_type: statefulset
record: namespace_workload_pod:kube_pod_owner:relabel
{{< /code >}}
 
##### namespace_workload_pod:kube_pod_owner:relabel

{{< code lang="yaml" >}}
expr: |
  max by (cluster, namespace, workload, pod) (
    label_replace(
      kube_pod_owner{job="kube-state-metrics", owner_kind="Job"},
      "workload", "$1", "owner_name", "(.*)"
    )
  )
labels:
  workload_type: job
record: namespace_workload_pod:kube_pod_owner:relabel
{{< /code >}}
 
### kube-scheduler.rules

##### cluster_quantile:scheduler_e2e_scheduling_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99, sum(rate(scheduler_e2e_scheduling_duration_seconds_bucket{job="kube-scheduler"}[5m])) without(instance, pod))
labels:
  quantile: "0.99"
record: cluster_quantile:scheduler_e2e_scheduling_duration_seconds:histogram_quantile
{{< /code >}}
 
##### cluster_quantile:scheduler_scheduling_algorithm_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99, sum(rate(scheduler_scheduling_algorithm_duration_seconds_bucket{job="kube-scheduler"}[5m])) without(instance, pod))
labels:
  quantile: "0.99"
record: cluster_quantile:scheduler_scheduling_algorithm_duration_seconds:histogram_quantile
{{< /code >}}
 
##### cluster_quantile:scheduler_binding_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99, sum(rate(scheduler_binding_duration_seconds_bucket{job="kube-scheduler"}[5m])) without(instance, pod))
labels:
  quantile: "0.99"
record: cluster_quantile:scheduler_binding_duration_seconds:histogram_quantile
{{< /code >}}
 
##### cluster_quantile:scheduler_e2e_scheduling_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.9, sum(rate(scheduler_e2e_scheduling_duration_seconds_bucket{job="kube-scheduler"}[5m])) without(instance, pod))
labels:
  quantile: "0.9"
record: cluster_quantile:scheduler_e2e_scheduling_duration_seconds:histogram_quantile
{{< /code >}}
 
##### cluster_quantile:scheduler_scheduling_algorithm_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.9, sum(rate(scheduler_scheduling_algorithm_duration_seconds_bucket{job="kube-scheduler"}[5m])) without(instance, pod))
labels:
  quantile: "0.9"
record: cluster_quantile:scheduler_scheduling_algorithm_duration_seconds:histogram_quantile
{{< /code >}}
 
##### cluster_quantile:scheduler_binding_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.9, sum(rate(scheduler_binding_duration_seconds_bucket{job="kube-scheduler"}[5m])) without(instance, pod))
labels:
  quantile: "0.9"
record: cluster_quantile:scheduler_binding_duration_seconds:histogram_quantile
{{< /code >}}
 
##### cluster_quantile:scheduler_e2e_scheduling_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.5, sum(rate(scheduler_e2e_scheduling_duration_seconds_bucket{job="kube-scheduler"}[5m])) without(instance, pod))
labels:
  quantile: "0.5"
record: cluster_quantile:scheduler_e2e_scheduling_duration_seconds:histogram_quantile
{{< /code >}}
 
##### cluster_quantile:scheduler_scheduling_algorithm_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.5, sum(rate(scheduler_scheduling_algorithm_duration_seconds_bucket{job="kube-scheduler"}[5m])) without(instance, pod))
labels:
  quantile: "0.5"
record: cluster_quantile:scheduler_scheduling_algorithm_duration_seconds:histogram_quantile
{{< /code >}}
 
##### cluster_quantile:scheduler_binding_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.5, sum(rate(scheduler_binding_duration_seconds_bucket{job="kube-scheduler"}[5m])) without(instance, pod))
labels:
  quantile: "0.5"
record: cluster_quantile:scheduler_binding_duration_seconds:histogram_quantile
{{< /code >}}
 
### node.rules

##### 'node_namespace_pod:kube_pod_info:'

{{< code lang="yaml" >}}
expr: |
  topk by(cluster, namespace, pod) (1,
    max by (cluster, node, namespace, pod) (
      label_replace(kube_pod_info{job="kube-state-metrics",node!=""}, "pod", "$1", "pod", "(.*)")
  ))
record: 'node_namespace_pod:kube_pod_info:'
{{< /code >}}
 
##### node:node_num_cpu:sum

{{< code lang="yaml" >}}
expr: |
  count by (cluster, node) (
    node_cpu_seconds_total{mode="idle",job="node-exporter"}
    * on (cluster, namespace, pod) group_left(node)
    topk by(cluster, namespace, pod) (1, node_namespace_pod:kube_pod_info:)
  )
record: node:node_num_cpu:sum
{{< /code >}}
 
##### :node_memory_MemAvailable_bytes:sum

{{< code lang="yaml" >}}
expr: |
  sum(
    node_memory_MemAvailable_bytes{job="node-exporter"} or
    (
      node_memory_Buffers_bytes{job="node-exporter"} +
      node_memory_Cached_bytes{job="node-exporter"} +
      node_memory_MemFree_bytes{job="node-exporter"} +
      node_memory_Slab_bytes{job="node-exporter"}
    )
  ) by (cluster)
record: :node_memory_MemAvailable_bytes:sum
{{< /code >}}
 
##### node:node_cpu_utilization:ratio_rate5m

{{< code lang="yaml" >}}
expr: |
  avg by (cluster, node) (
    sum without (mode) (
      rate(node_cpu_seconds_total{mode!="idle",mode!="iowait",mode!="steal",job="node-exporter"}[5m])
    )
  )
record: node:node_cpu_utilization:ratio_rate5m
{{< /code >}}
 
##### cluster:node_cpu:ratio_rate5m

{{< code lang="yaml" >}}
expr: |
  avg by (cluster) (
    node:node_cpu_utilization:ratio_rate5m
  )
record: cluster:node_cpu:ratio_rate5m
{{< /code >}}
 
### kubelet.rules

##### node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99, sum(rate(kubelet_pleg_relist_duration_seconds_bucket{job="kubelet"}[5m])) by (cluster, instance, le) * on(cluster, instance) group_left(node) kubelet_node_name{job="kubelet"})
labels:
  quantile: "0.99"
record: node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile
{{< /code >}}
 
##### node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.9, sum(rate(kubelet_pleg_relist_duration_seconds_bucket{job="kubelet"}[5m])) by (cluster, instance, le) * on(cluster, instance) group_left(node) kubelet_node_name{job="kubelet"})
labels:
  quantile: "0.9"
record: node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile
{{< /code >}}
 
##### node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.5, sum(rate(kubelet_pleg_relist_duration_seconds_bucket{job="kubelet"}[5m])) by (cluster, instance, le) * on(cluster, instance) group_left(node) kubelet_node_name{job="kubelet"})
labels:
  quantile: "0.5"
record: node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [apiserver](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/apiserver.json)
- [cluster-total](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/cluster-total.json)
- [controller-manager](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/controller-manager.json)
- [k8s-resources-cluster](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/k8s-resources-cluster.json)
- [k8s-resources-namespace](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/k8s-resources-namespace.json)
- [k8s-resources-node](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/k8s-resources-node.json)
- [k8s-resources-pod](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/k8s-resources-pod.json)
- [k8s-resources-workload](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/k8s-resources-workload.json)
- [k8s-resources-workloads-namespace](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/k8s-resources-workloads-namespace.json)
- [kubelet](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/kubelet.json)
- [namespace-by-pod](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/namespace-by-pod.json)
- [namespace-by-workload](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/namespace-by-workload.json)
- [persistentvolumesusage](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/persistentvolumesusage.json)
- [pod-total](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/pod-total.json)
- [proxy](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/proxy.json)
- [scheduler](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/scheduler.json)
- [workload-total](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/workload-total.json)
