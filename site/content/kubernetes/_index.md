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
  message: Pod {{ $labels.namespace }}/{{ $labels.pod }} ({{ $labels.container }}) is restarting {{ printf "%.2f" $value }} times / 5 minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepodcrashlooping
expr: |
  rate(kube_pod_container_status_restarts_total{job="kube-state-metrics"}[5m]) * 60 * 5 > 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubePodNotReady
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepodnotready

{{< code lang="yaml" >}}
alert: KubePodNotReady
annotations:
  message: Pod {{ $labels.namespace }}/{{ $labels.pod }} has been in a non-ready state for longer than 15 minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepodnotready
expr: |
  sum by (namespace, pod) (
    max by(namespace, pod) (
      kube_pod_status_phase{job="kube-state-metrics", phase=~"Pending|Unknown"}
    ) * on(namespace, pod) group_left(owner_kind) topk by(namespace, pod) (
      1, max by(namespace, pod, owner_kind) (kube_pod_owner{owner_kind!="Job"})
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
  message: Deployment generation for {{ $labels.namespace }}/{{ $labels.deployment }} does not match, this indicates that the Deployment has failed but has not been rolled back.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedeploymentgenerationmismatch
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
  message: Deployment {{ $labels.namespace }}/{{ $labels.deployment }} has not matched the expected number of replicas for longer than 15 minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedeploymentreplicasmismatch
expr: |
  (
    kube_deployment_spec_replicas{job="kube-state-metrics"}
      !=
    kube_deployment_status_replicas_available{job="kube-state-metrics"}
  ) and (
    changes(kube_deployment_status_replicas_updated{job="kube-state-metrics"}[5m])
      ==
    0
  )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeStatefulSetReplicasMismatch
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubestatefulsetreplicasmismatch

{{< code lang="yaml" >}}
alert: KubeStatefulSetReplicasMismatch
annotations:
  message: StatefulSet {{ $labels.namespace }}/{{ $labels.statefulset }} has not matched the expected number of replicas for longer than 15 minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubestatefulsetreplicasmismatch
expr: |
  (
    kube_statefulset_status_replicas_ready{job="kube-state-metrics"}
      !=
    kube_statefulset_status_replicas{job="kube-state-metrics"}
  ) and (
    changes(kube_statefulset_status_replicas_updated{job="kube-state-metrics"}[5m])
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
  message: StatefulSet generation for {{ $labels.namespace }}/{{ $labels.statefulset }} does not match, this indicates that the StatefulSet has failed but has not been rolled back.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubestatefulsetgenerationmismatch
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
  message: StatefulSet {{ $labels.namespace }}/{{ $labels.statefulset }} update has not been rolled out.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubestatefulsetupdatenotrolledout
expr: |
  max without (revision) (
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
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeDaemonSetRolloutStuck
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedaemonsetrolloutstuck

{{< code lang="yaml" >}}
alert: KubeDaemonSetRolloutStuck
annotations:
  message: Only {{ $value | humanizePercentage }} of the desired Pods of DaemonSet {{ $labels.namespace }}/{{ $labels.daemonset }} are scheduled and ready.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedaemonsetrolloutstuck
expr: |
  kube_daemonset_status_number_ready{job="kube-state-metrics"}
    /
  kube_daemonset_status_desired_number_scheduled{job="kube-state-metrics"} < 1.00
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeContainerWaiting
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecontainerwaiting

{{< code lang="yaml" >}}
alert: KubeContainerWaiting
annotations:
  message: Pod {{ $labels.namespace }}/{{ $labels.pod }} container {{ $labels.container}} has been in waiting state for longer than 1 hour.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecontainerwaiting
expr: |
  sum by (namespace, pod, container) (kube_pod_container_status_waiting_reason{job="kube-state-metrics"}) > 0
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### KubeDaemonSetNotScheduled
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedaemonsetnotscheduled

{{< code lang="yaml" >}}
alert: KubeDaemonSetNotScheduled
annotations:
  message: '{{ $value }} Pods of DaemonSet {{ $labels.namespace }}/{{ $labels.daemonset }} are not scheduled.'
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedaemonsetnotscheduled
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
  message: '{{ $value }} Pods of DaemonSet {{ $labels.namespace }}/{{ $labels.daemonset }} are running where they are not supposed to run.'
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedaemonsetmisscheduled
expr: |
  kube_daemonset_status_number_misscheduled{job="kube-state-metrics"} > 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeCronJobRunning
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecronjobrunning

{{< code lang="yaml" >}}
alert: KubeCronJobRunning
annotations:
  message: CronJob {{ $labels.namespace }}/{{ $labels.cronjob }} is taking more than 1h to complete.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecronjobrunning
expr: |
  time() - kube_cronjob_next_schedule_time{job="kube-state-metrics"} > 3600
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### KubeJobCompletion
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubejobcompletion

{{< code lang="yaml" >}}
alert: KubeJobCompletion
annotations:
  message: Job {{ $labels.namespace }}/{{ $labels.job_name }} is taking more than one hour to complete.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubejobcompletion
expr: |
  kube_job_spec_completions{job="kube-state-metrics"} - kube_job_status_succeeded{job="kube-state-metrics"}  > 0
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### KubeJobFailed
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubejobfailed

{{< code lang="yaml" >}}
alert: KubeJobFailed
annotations:
  message: Job {{ $labels.namespace }}/{{ $labels.job_name }} failed to complete.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubejobfailed
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
  message: HPA {{ $labels.namespace }}/{{ $labels.hpa }} has not matched the desired number of replicas for longer than 15 minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubehpareplicasmismatch
expr: |
  (kube_hpa_status_desired_replicas{job="kube-state-metrics"}
    !=
  kube_hpa_status_current_replicas{job="kube-state-metrics"})
    and
  changes(kube_hpa_status_current_replicas[15m]) == 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeHpaMaxedOut
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubehpamaxedout

{{< code lang="yaml" >}}
alert: KubeHpaMaxedOut
annotations:
  message: HPA {{ $labels.namespace }}/{{ $labels.hpa }} has been running at max replicas for longer than 15 minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubehpamaxedout
expr: |
  kube_hpa_status_current_replicas{job="kube-state-metrics"}
    ==
  kube_hpa_spec_max_replicas{job="kube-state-metrics"}
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
  message: Cluster has overcommitted CPU resource requests for Pods and cannot tolerate node failure.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecpuovercommit
expr: |
  sum(namespace:kube_pod_container_resource_requests_cpu_cores:sum{})
    /
  sum(kube_node_status_allocatable_cpu_cores)
    >
  (count(kube_node_status_allocatable_cpu_cores)-1) / count(kube_node_status_allocatable_cpu_cores)
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### KubeMemoryOvercommit
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubememoryovercommit

{{< code lang="yaml" >}}
alert: KubeMemoryOvercommit
annotations:
  message: Cluster has overcommitted memory resource requests for Pods and cannot tolerate node failure.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubememoryovercommit
expr: |
  sum(namespace:kube_pod_container_resource_requests_memory_bytes:sum{})
    /
  sum(kube_node_status_allocatable_memory_bytes)
    >
  (count(kube_node_status_allocatable_memory_bytes)-1)
    /
  count(kube_node_status_allocatable_memory_bytes)
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### KubeCPUQuotaOvercommit
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecpuquotaovercommit

{{< code lang="yaml" >}}
alert: KubeCPUQuotaOvercommit
annotations:
  message: Cluster has overcommitted CPU resource requests for Namespaces.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecpuquotaovercommit
expr: |
  sum(kube_resourcequota{job="kube-state-metrics", type="hard", resource="cpu"})
    /
  sum(kube_node_status_allocatable_cpu_cores)
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
  message: Cluster has overcommitted memory resource requests for Namespaces.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubememoryquotaovercommit
expr: |
  sum(kube_resourcequota{job="kube-state-metrics", type="hard", resource="memory"})
    /
  sum(kube_node_status_allocatable_memory_bytes{job="node-exporter"})
    > 1.5
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### KubeQuotaExceeded
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubequotaexceeded

{{< code lang="yaml" >}}
alert: KubeQuotaExceeded
annotations:
  message: Namespace {{ $labels.namespace }} is using {{ $value | humanizePercentage }} of its {{ $labels.resource }} quota.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubequotaexceeded
expr: |
  kube_resourcequota{job="kube-state-metrics", type="used"}
    / ignoring(instance, job, type)
  (kube_resourcequota{job="kube-state-metrics", type="hard"} > 0)
    > 0.90
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### CPUThrottlingHigh
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-cputhrottlinghigh

{{< code lang="yaml" >}}
alert: CPUThrottlingHigh
annotations:
  message: '{{ $value | humanizePercentage }} throttling of CPU in namespace {{ $labels.namespace }} for container {{ $labels.container }} in pod {{ $labels.pod }}.'
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-cputhrottlinghigh
expr: |
  sum(increase(container_cpu_cfs_throttled_periods_total{container!="", }[5m])) by (container, pod, namespace)
    /
  sum(increase(container_cpu_cfs_periods_total{}[5m])) by (container, pod, namespace)
    > ( 25 / 100 )
for: 15m
labels:
  severity: warning
{{< /code >}}
 
### kubernetes-storage

##### KubePersistentVolumeFillingUp
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumefillingup

{{< code lang="yaml" >}}
alert: KubePersistentVolumeFillingUp
annotations:
  message: The PersistentVolume claimed by {{ $labels.persistentvolumeclaim }} in Namespace {{ $labels.namespace }} is only {{ $value | humanizePercentage }} free.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumefillingup
expr: |
  kubelet_volume_stats_available_bytes{job="kubelet"}
    /
  kubelet_volume_stats_capacity_bytes{job="kubelet"}
    < 0.03
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### KubePersistentVolumeFillingUp
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumefillingup

{{< code lang="yaml" >}}
alert: KubePersistentVolumeFillingUp
annotations:
  message: Based on recent sampling, the PersistentVolume claimed by {{ $labels.persistentvolumeclaim }} in Namespace {{ $labels.namespace }} is expected to fill up within four days. Currently {{ $value | humanizePercentage }} is available.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumefillingup
expr: |
  (
    kubelet_volume_stats_available_bytes{job="kubelet"}
      /
    kubelet_volume_stats_capacity_bytes{job="kubelet"}
  ) < 0.15
  and
  predict_linear(kubelet_volume_stats_available_bytes{job="kubelet"}[6h], 4 * 24 * 3600) < 0
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### KubePersistentVolumeErrors
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumeerrors

{{< code lang="yaml" >}}
alert: KubePersistentVolumeErrors
annotations:
  message: The persistent volume {{ $labels.persistentvolume }} has status {{ $labels.phase }}.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepersistentvolumeerrors
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
  message: There are {{ $value }} different semantic versions of Kubernetes components running.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeversionmismatch
expr: |
  count(count by (gitVersion) (label_replace(kubernetes_build_info{job!~"kube-dns|coredns"},"gitVersion","$1","gitVersion","(v[0-9]*.[0-9]*.[0-9]*).*"))) > 1
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeClientErrors
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeclienterrors

{{< code lang="yaml" >}}
alert: KubeClientErrors
annotations:
  message: Kubernetes API server client '{{ $labels.job }}/{{ $labels.instance }}' is experiencing {{ $value | humanizePercentage }} errors.'
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeclienterrors
expr: |
  (sum(rate(rest_client_requests_total{code=~"5.."}[5m])) by (instance, job)
    /
  sum(rate(rest_client_requests_total[5m])) by (instance, job))
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
  message: The API server is burning too much error budget
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapierrorbudgetburn
expr: |
  sum(apiserver_request:burnrate1h) > (14.40 * 0.01000)
  and
  sum(apiserver_request:burnrate5m) > (14.40 * 0.01000)
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
  message: The API server is burning too much error budget
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapierrorbudgetburn
expr: |
  sum(apiserver_request:burnrate6h) > (6.00 * 0.01000)
  and
  sum(apiserver_request:burnrate30m) > (6.00 * 0.01000)
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
  message: The API server is burning too much error budget
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapierrorbudgetburn
expr: |
  sum(apiserver_request:burnrate1d) > (3.00 * 0.01000)
  and
  sum(apiserver_request:burnrate2h) > (3.00 * 0.01000)
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
  message: The API server is burning too much error budget
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapierrorbudgetburn
expr: |
  sum(apiserver_request:burnrate3d) > (1.00 * 0.01000)
  and
  sum(apiserver_request:burnrate6h) > (1.00 * 0.01000)
for: 3h
labels:
  long: 3d
  severity: warning
  short: 6h
{{< /code >}}
 
### kubernetes-system-apiserver

##### KubeAPILatencyHigh
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapilatencyhigh

{{< code lang="yaml" >}}
alert: KubeAPILatencyHigh
annotations:
  message: The API server has an abnormal latency of {{ $value }} seconds for {{ $labels.verb }} {{ $labels.resource }}.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapilatencyhigh
expr: |
  (
    cluster:apiserver_request_duration_seconds:mean5m{job="kube-apiserver"}
    >
    on (verb) group_left()
    (
      avg by (verb) (cluster:apiserver_request_duration_seconds:mean5m{job="kube-apiserver"} >= 0)
      +
      2*stddev by (verb) (cluster:apiserver_request_duration_seconds:mean5m{job="kube-apiserver"} >= 0)
    )
  ) > on (verb) group_left()
  1.2 * avg by (verb) (cluster:apiserver_request_duration_seconds:mean5m{job="kube-apiserver"} >= 0)
  and on (verb,resource)
  cluster_quantile:apiserver_request_duration_seconds:histogram_quantile{job="kube-apiserver",quantile="0.99"}
  >
  1
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### KubeAPIErrorsHigh
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapierrorshigh

{{< code lang="yaml" >}}
alert: KubeAPIErrorsHigh
annotations:
  message: API server is returning errors for {{ $value | humanizePercentage }} of requests for {{ $labels.verb }} {{ $labels.resource }} {{ $labels.subresource }}.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapierrorshigh
expr: |
  sum(rate(apiserver_request_total{job="kube-apiserver",code=~"5.."}[5m])) by (resource,subresource,verb)
    /
  sum(rate(apiserver_request_total{job="kube-apiserver"}[5m])) by (resource,subresource,verb) > 0.05
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### KubeClientCertificateExpiration
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeclientcertificateexpiration

{{< code lang="yaml" >}}
alert: KubeClientCertificateExpiration
annotations:
  message: A client certificate used to authenticate to the apiserver is expiring in less than 7.0 days.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeclientcertificateexpiration
expr: |
  apiserver_client_certificate_expiration_seconds_count{job="kube-apiserver"} > 0 and on(job) histogram_quantile(0.01, sum by (job, le) (rate(apiserver_client_certificate_expiration_seconds_bucket{job="kube-apiserver"}[5m]))) < 604800
labels:
  severity: warning
{{< /code >}}
 
##### KubeClientCertificateExpiration
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeclientcertificateexpiration

{{< code lang="yaml" >}}
alert: KubeClientCertificateExpiration
annotations:
  message: A client certificate used to authenticate to the apiserver is expiring in less than 24.0 hours.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeclientcertificateexpiration
expr: |
  apiserver_client_certificate_expiration_seconds_count{job="kube-apiserver"} > 0 and on(job) histogram_quantile(0.01, sum by (job, le) (rate(apiserver_client_certificate_expiration_seconds_bucket{job="kube-apiserver"}[5m]))) < 86400
labels:
  severity: critical
{{< /code >}}
 
##### AggregatedAPIErrors
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-aggregatedapierrors

{{< code lang="yaml" >}}
alert: AggregatedAPIErrors
annotations:
  message: An aggregated API {{ $labels.name }}/{{ $labels.namespace }} has reported errors. The number of errors have increased for it in the past five minutes. High values indicate that the availability of the service changes too often.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-aggregatedapierrors
expr: |
  sum by(name, namespace)(increase(aggregator_unavailable_apiservice_count[5m])) > 2
labels:
  severity: warning
{{< /code >}}
 
##### AggregatedAPIDown
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-aggregatedapidown

{{< code lang="yaml" >}}
alert: AggregatedAPIDown
annotations:
  message: An aggregated API {{ $labels.name }}/{{ $labels.namespace }} is down. It has not been available at least for the past five minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-aggregatedapidown
expr: |
  sum by(name, namespace)(sum_over_time(aggregator_unavailable_apiservice[5m])) > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### KubeAPIDown
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapidown

{{< code lang="yaml" >}}
alert: KubeAPIDown
annotations:
  message: KubeAPI has disappeared from Prometheus target discovery.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeapidown
expr: |
  absent(up{job="kube-apiserver"} == 1)
for: 15m
labels:
  severity: critical
{{< /code >}}
 
### kubernetes-system-kubelet

##### KubeNodeNotReady
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubenodenotready

{{< code lang="yaml" >}}
alert: KubeNodeNotReady
annotations:
  message: '{{ $labels.node }} has been unready for more than 15 minutes.'
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubenodenotready
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
  message: '{{ $labels.node }} is unreachable and some workloads may be rescheduled.'
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubenodeunreachable
expr: |
  (kube_node_spec_taint{job="kube-state-metrics",key="node.kubernetes.io/unreachable",effect="NoSchedule"} unless ignoring(key,value) kube_node_spec_taint{job="kube-state-metrics",key="ToBeDeletedByClusterAutoscaler"}) == 1
labels:
  severity: warning
{{< /code >}}
 
##### KubeletTooManyPods
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubelettoomanypods

{{< code lang="yaml" >}}
alert: KubeletTooManyPods
annotations:
  message: Kubelet '{{ $labels.node }}' is running at {{ $value | humanizePercentage }} of its Pod capacity.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubelettoomanypods
expr: |
  max(max(kubelet_running_pod_count{job="kubelet"}) by(instance) * on(instance) group_left(node) kubelet_node_name{job="kubelet"}) by(node) / max(kube_node_status_capacity_pods{job="kube-state-metrics"} != 1) by(node) > 0.95
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeNodeReadinessFlapping
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubenodereadinessflapping

{{< code lang="yaml" >}}
alert: KubeNodeReadinessFlapping
annotations:
  message: The readiness status of node {{ $labels.node }} has changed {{ $value }} times in the last 15 minutes.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubenodereadinessflapping
expr: |
  sum(changes(kube_node_status_condition{status="true",condition="Ready"}[15m])) by (node) > 2
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeletPlegDurationHigh
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletplegdurationhigh

{{< code lang="yaml" >}}
alert: KubeletPlegDurationHigh
annotations:
  message: The Kubelet Pod Lifecycle Event Generator has a 99th percentile duration of {{ $value }} seconds on node {{ $labels.node }}.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletplegdurationhigh
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
  message: Kubelet Pod startup 99th percentile latency is {{ $value }} seconds on node {{ $labels.node }}.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletpodstartuplatencyhigh
expr: |
  histogram_quantile(0.99, sum(rate(kubelet_pod_worker_duration_seconds_bucket{job="kubelet"}[5m])) by (instance, le)) * on(instance) group_left(node) kubelet_node_name{job="kubelet"} > 60
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KubeletDown
https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletdown

{{< code lang="yaml" >}}
alert: KubeletDown
annotations:
  message: Kubelet has disappeared from Prometheus target discovery.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeletdown
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
  message: KubeScheduler has disappeared from Prometheus target discovery.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubeschedulerdown
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
  message: KubeControllerManager has disappeared from Prometheus target discovery.
  runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubecontrollermanagerdown
expr: |
  absent(up{job="kube-controller-manager"} == 1)
for: 15m
labels:
  severity: critical
{{< /code >}}
 
## Recording rules

{{< panel style="warning" >}}
Complete list of pregenerated recording rules is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/rules.yaml).
{{< /panel >}}

### kube-apiserver.rules

##### apiserver_request:burnrate1d

{{< code lang="yaml" >}}
expr: |
  (
    (
      # too slow
      sum(rate(apiserver_request_duration_seconds_count{job="kube-apiserver",verb=~"LIST|GET"}[1d]))
      -
      (
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope=~"resource|",le="0.1"}[1d])) +
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="namespace",le="0.5"}[1d])) +
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="cluster",le="5"}[1d]))
      )
    )
    +
    # errors
    sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET",code=~"5.."}[1d]))
  )
  /
  sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[1d]))
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
      sum(rate(apiserver_request_duration_seconds_count{job="kube-apiserver",verb=~"LIST|GET"}[1h]))
      -
      (
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope=~"resource|",le="0.1"}[1h])) +
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="namespace",le="0.5"}[1h])) +
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="cluster",le="5"}[1h]))
      )
    )
    +
    # errors
    sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET",code=~"5.."}[1h]))
  )
  /
  sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[1h]))
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
      sum(rate(apiserver_request_duration_seconds_count{job="kube-apiserver",verb=~"LIST|GET"}[2h]))
      -
      (
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope=~"resource|",le="0.1"}[2h])) +
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="namespace",le="0.5"}[2h])) +
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="cluster",le="5"}[2h]))
      )
    )
    +
    # errors
    sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET",code=~"5.."}[2h]))
  )
  /
  sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[2h]))
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
      sum(rate(apiserver_request_duration_seconds_count{job="kube-apiserver",verb=~"LIST|GET"}[30m]))
      -
      (
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope=~"resource|",le="0.1"}[30m])) +
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="namespace",le="0.5"}[30m])) +
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="cluster",le="5"}[30m]))
      )
    )
    +
    # errors
    sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET",code=~"5.."}[30m]))
  )
  /
  sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[30m]))
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
      sum(rate(apiserver_request_duration_seconds_count{job="kube-apiserver",verb=~"LIST|GET"}[3d]))
      -
      (
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope=~"resource|",le="0.1"}[3d])) +
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="namespace",le="0.5"}[3d])) +
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="cluster",le="5"}[3d]))
      )
    )
    +
    # errors
    sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET",code=~"5.."}[3d]))
  )
  /
  sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[3d]))
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
      sum(rate(apiserver_request_duration_seconds_count{job="kube-apiserver",verb=~"LIST|GET"}[5m]))
      -
      (
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope=~"resource|",le="0.1"}[5m])) +
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="namespace",le="0.5"}[5m])) +
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="cluster",le="5"}[5m]))
      )
    )
    +
    # errors
    sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET",code=~"5.."}[5m]))
  )
  /
  sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[5m]))
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
      sum(rate(apiserver_request_duration_seconds_count{job="kube-apiserver",verb=~"LIST|GET"}[6h]))
      -
      (
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope=~"resource|",le="0.1"}[6h])) +
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="namespace",le="0.5"}[6h])) +
        sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="cluster",le="5"}[6h]))
      )
    )
    +
    # errors
    sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET",code=~"5.."}[6h]))
  )
  /
  sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[6h]))
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
      sum(rate(apiserver_request_duration_seconds_count{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[1d]))
      -
      sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",le="1"}[1d]))
    )
    +
    sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[1d]))
  )
  /
  sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[1d]))
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
      sum(rate(apiserver_request_duration_seconds_count{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[1h]))
      -
      sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",le="1"}[1h]))
    )
    +
    sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[1h]))
  )
  /
  sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[1h]))
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
      sum(rate(apiserver_request_duration_seconds_count{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[2h]))
      -
      sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",le="1"}[2h]))
    )
    +
    sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[2h]))
  )
  /
  sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[2h]))
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
      sum(rate(apiserver_request_duration_seconds_count{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[30m]))
      -
      sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",le="1"}[30m]))
    )
    +
    sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[30m]))
  )
  /
  sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[30m]))
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
      sum(rate(apiserver_request_duration_seconds_count{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[3d]))
      -
      sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",le="1"}[3d]))
    )
    +
    sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[3d]))
  )
  /
  sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[3d]))
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
      sum(rate(apiserver_request_duration_seconds_count{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[5m]))
      -
      sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",le="1"}[5m]))
    )
    +
    sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[5m]))
  )
  /
  sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[5m]))
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
      sum(rate(apiserver_request_duration_seconds_count{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[6h]))
      -
      sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",le="1"}[6h]))
    )
    +
    sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE",code=~"5.."}[6h]))
  )
  /
  sum(rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[6h]))
labels:
  verb: write
record: apiserver_request:burnrate6h
{{< /code >}}
 
##### code_resource:apiserver_request_total:rate5m

{{< code lang="yaml" >}}
expr: |
  sum by (code,resource) (rate(apiserver_request_total{job="kube-apiserver",verb=~"LIST|GET"}[5m]))
labels:
  verb: read
record: code_resource:apiserver_request_total:rate5m
{{< /code >}}
 
##### code_resource:apiserver_request_total:rate5m

{{< code lang="yaml" >}}
expr: |
  sum by (code,resource) (rate(apiserver_request_total{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[5m]))
labels:
  verb: write
record: code_resource:apiserver_request_total:rate5m
{{< /code >}}
 
##### cluster_quantile:apiserver_request_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99, sum by (le, resource) (rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET"}[5m]))) > 0
labels:
  quantile: "0.99"
  verb: read
record: cluster_quantile:apiserver_request_duration_seconds:histogram_quantile
{{< /code >}}
 
##### cluster_quantile:apiserver_request_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99, sum by (le, resource) (rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"POST|PUT|PATCH|DELETE"}[5m]))) > 0
labels:
  quantile: "0.99"
  verb: write
record: cluster_quantile:apiserver_request_duration_seconds:histogram_quantile
{{< /code >}}
 
##### cluster:apiserver_request_duration_seconds:mean5m

{{< code lang="yaml" >}}
expr: |
  sum(rate(apiserver_request_duration_seconds_sum{subresource!="log",verb!~"LIST|WATCH|WATCHLIST|DELETECOLLECTION|PROXY|CONNECT"}[5m])) without(instance, pod)
  /
  sum(rate(apiserver_request_duration_seconds_count{subresource!="log",verb!~"LIST|WATCH|WATCHLIST|DELETECOLLECTION|PROXY|CONNECT"}[5m])) without(instance, pod)
record: cluster:apiserver_request_duration_seconds:mean5m
{{< /code >}}
 
##### cluster_quantile:apiserver_request_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99, sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",subresource!="log",verb!~"LIST|WATCH|WATCHLIST|DELETECOLLECTION|PROXY|CONNECT"}[5m])) without(instance, pod))
labels:
  quantile: "0.99"
record: cluster_quantile:apiserver_request_duration_seconds:histogram_quantile
{{< /code >}}
 
##### cluster_quantile:apiserver_request_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.9, sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",subresource!="log",verb!~"LIST|WATCH|WATCHLIST|DELETECOLLECTION|PROXY|CONNECT"}[5m])) without(instance, pod))
labels:
  quantile: "0.9"
record: cluster_quantile:apiserver_request_duration_seconds:histogram_quantile
{{< /code >}}
 
##### cluster_quantile:apiserver_request_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.5, sum(rate(apiserver_request_duration_seconds_bucket{job="kube-apiserver",subresource!="log",verb!~"LIST|WATCH|WATCHLIST|DELETECOLLECTION|PROXY|CONNECT"}[5m])) without(instance, pod))
labels:
  quantile: "0.5"
record: cluster_quantile:apiserver_request_duration_seconds:histogram_quantile
{{< /code >}}
 
### kube-apiserver-availability.rules

##### apiserver_request:availability30d

{{< code lang="yaml" >}}
expr: |
  1 - (
    (
      # write too slow
      sum(increase(apiserver_request_duration_seconds_count{verb=~"POST|PUT|PATCH|DELETE"}[30d]))
      -
      sum(increase(apiserver_request_duration_seconds_bucket{verb=~"POST|PUT|PATCH|DELETE",le="1"}[30d]))
    ) +
    (
      # read too slow
      sum(increase(apiserver_request_duration_seconds_count{verb=~"LIST|GET"}[30d]))
      -
      (
        sum(increase(apiserver_request_duration_seconds_bucket{verb=~"LIST|GET",scope=~"resource|",le="0.1"}[30d])) +
        sum(increase(apiserver_request_duration_seconds_bucket{verb=~"LIST|GET",scope="namespace",le="0.5"}[30d])) +
        sum(increase(apiserver_request_duration_seconds_bucket{verb=~"LIST|GET",scope="cluster",le="5"}[30d]))
      )
    ) +
    # errors
    sum(code:apiserver_request_total:increase30d{code=~"5.."} or vector(0))
  )
  /
  sum(code:apiserver_request_total:increase30d)
labels:
  verb: all
record: apiserver_request:availability30d
{{< /code >}}
 
##### apiserver_request:availability30d

{{< code lang="yaml" >}}
expr: |
  1 - (
    sum(increase(apiserver_request_duration_seconds_count{job="kube-apiserver",verb=~"LIST|GET"}[30d]))
    -
    (
      # too slow
      sum(increase(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope=~"resource|",le="0.1"}[30d])) +
      sum(increase(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="namespace",le="0.5"}[30d])) +
      sum(increase(apiserver_request_duration_seconds_bucket{job="kube-apiserver",verb=~"LIST|GET",scope="cluster",le="5"}[30d]))
    )
    +
    # errors
    sum(code:apiserver_request_total:increase30d{verb="read",code=~"5.."} or vector(0))
  )
  /
  sum(code:apiserver_request_total:increase30d{verb="read"})
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
      sum(increase(apiserver_request_duration_seconds_count{verb=~"POST|PUT|PATCH|DELETE"}[30d]))
      -
      sum(increase(apiserver_request_duration_seconds_bucket{verb=~"POST|PUT|PATCH|DELETE",le="1"}[30d]))
    )
    +
    # errors
    sum(code:apiserver_request_total:increase30d{verb="write",code=~"5.."} or vector(0))
  )
  /
  sum(code:apiserver_request_total:increase30d{verb="write"})
labels:
  verb: write
record: apiserver_request:availability30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="LIST",code=~"2.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="GET",code=~"2.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="POST",code=~"2.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="PUT",code=~"2.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="PATCH",code=~"2.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="DELETE",code=~"2.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="LIST",code=~"3.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="GET",code=~"3.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="POST",code=~"3.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="PUT",code=~"3.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="PATCH",code=~"3.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="DELETE",code=~"3.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="LIST",code=~"4.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="GET",code=~"4.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="POST",code=~"4.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="PUT",code=~"4.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="PATCH",code=~"4.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="DELETE",code=~"4.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="LIST",code=~"5.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="GET",code=~"5.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="POST",code=~"5.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="PUT",code=~"5.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="PATCH",code=~"5.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code_verb:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code, verb) (increase(apiserver_request_total{job="kube-apiserver",verb="DELETE",code=~"5.."}[30d]))
record: code_verb:apiserver_request_total:increase30d
{{< /code >}}
 
##### code:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code) (code_verb:apiserver_request_total:increase30d{verb=~"LIST|GET"})
labels:
  verb: read
record: code:apiserver_request_total:increase30d
{{< /code >}}
 
##### code:apiserver_request_total:increase30d

{{< code lang="yaml" >}}
expr: |
  sum by (code) (code_verb:apiserver_request_total:increase30d{verb=~"POST|PUT|PATCH|DELETE"})
labels:
  verb: write
record: code:apiserver_request_total:increase30d
{{< /code >}}
 
### k8s.rules

##### namespace:container_cpu_usage_seconds_total:sum_rate

{{< code lang="yaml" >}}
expr: |
  sum(rate(container_cpu_usage_seconds_total{job="cadvisor", image!="", container!="POD"}[5m])) by (namespace)
record: namespace:container_cpu_usage_seconds_total:sum_rate
{{< /code >}}
 
##### node_namespace_pod_container:container_cpu_usage_seconds_total:sum_rate

{{< code lang="yaml" >}}
expr: |
  sum by (cluster, namespace, pod, container) (
    rate(container_cpu_usage_seconds_total{job="cadvisor", image!="", container!="POD"}[5m])
  ) * on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (
    1, max by(cluster, namespace, pod, node) (kube_pod_info{node!=""})
  )
record: node_namespace_pod_container:container_cpu_usage_seconds_total:sum_rate
{{< /code >}}
 
##### node_namespace_pod_container:container_memory_working_set_bytes

{{< code lang="yaml" >}}
expr: |
  container_memory_working_set_bytes{job="cadvisor", image!=""}
  * on (namespace, pod) group_left(node) topk by(namespace, pod) (1,
    max by(namespace, pod, node) (kube_pod_info{node!=""})
  )
record: node_namespace_pod_container:container_memory_working_set_bytes
{{< /code >}}
 
##### node_namespace_pod_container:container_memory_rss

{{< code lang="yaml" >}}
expr: |
  container_memory_rss{job="cadvisor", image!=""}
  * on (namespace, pod) group_left(node) topk by(namespace, pod) (1,
    max by(namespace, pod, node) (kube_pod_info{node!=""})
  )
record: node_namespace_pod_container:container_memory_rss
{{< /code >}}
 
##### node_namespace_pod_container:container_memory_cache

{{< code lang="yaml" >}}
expr: |
  container_memory_cache{job="cadvisor", image!=""}
  * on (namespace, pod) group_left(node) topk by(namespace, pod) (1,
    max by(namespace, pod, node) (kube_pod_info{node!=""})
  )
record: node_namespace_pod_container:container_memory_cache
{{< /code >}}
 
##### node_namespace_pod_container:container_memory_swap

{{< code lang="yaml" >}}
expr: |
  container_memory_swap{job="cadvisor", image!=""}
  * on (namespace, pod) group_left(node) topk by(namespace, pod) (1,
    max by(namespace, pod, node) (kube_pod_info{node!=""})
  )
record: node_namespace_pod_container:container_memory_swap
{{< /code >}}
 
##### namespace:container_memory_usage_bytes:sum

{{< code lang="yaml" >}}
expr: |
  sum(container_memory_usage_bytes{job="cadvisor", image!="", container!="POD"}) by (namespace)
record: namespace:container_memory_usage_bytes:sum
{{< /code >}}
 
##### namespace:kube_pod_container_resource_requests_memory_bytes:sum

{{< code lang="yaml" >}}
expr: |
  sum by (namespace) (
      sum by (namespace, pod) (
          max by (namespace, pod, container) (
              kube_pod_container_resource_requests_memory_bytes{job="kube-state-metrics"}
          ) * on(namespace, pod) group_left() max by (namespace, pod) (
              kube_pod_status_phase{phase=~"Pending|Running"} == 1
          )
      )
  )
record: namespace:kube_pod_container_resource_requests_memory_bytes:sum
{{< /code >}}
 
##### namespace:kube_pod_container_resource_requests_cpu_cores:sum

{{< code lang="yaml" >}}
expr: |
  sum by (namespace) (
      sum by (namespace, pod) (
          max by (namespace, pod, container) (
              kube_pod_container_resource_requests_cpu_cores{job="kube-state-metrics"}
          ) * on(namespace, pod) group_left() max by (namespace, pod) (
            kube_pod_status_phase{phase=~"Pending|Running"} == 1
          )
      )
  )
record: namespace:kube_pod_container_resource_requests_cpu_cores:sum
{{< /code >}}
 
##### mixin_pod_workload

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
record: mixin_pod_workload
{{< /code >}}
 
##### mixin_pod_workload

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
record: mixin_pod_workload
{{< /code >}}
 
##### mixin_pod_workload

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
record: mixin_pod_workload
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

##### ':kube_pod_info_node_count:'

{{< code lang="yaml" >}}
expr: |
  sum(min(kube_pod_info{node!=""}) by (cluster, node))
record: ':kube_pod_info_node_count:'
{{< /code >}}
 
##### 'node_namespace_pod:kube_pod_info:'

{{< code lang="yaml" >}}
expr: |
  topk by(namespace, pod) (1,
    max by (node, namespace, pod) (
      label_replace(kube_pod_info{job="kube-state-metrics",node!=""}, "pod", "$1", "pod", "(.*)")
  ))
record: 'node_namespace_pod:kube_pod_info:'
{{< /code >}}
 
##### node:node_num_cpu:sum

{{< code lang="yaml" >}}
expr: |
  count by (cluster, node) (sum by (node, cpu) (
    node_cpu_seconds_total{job="node-exporter"}
  * on (namespace, pod) group_left(node)
    node_namespace_pod:kube_pod_info:
  ))
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
 
### kubelet.rules

##### node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.99, sum(rate(kubelet_pleg_relist_duration_seconds_bucket[5m])) by (instance, le) * on(instance) group_left(node) kubelet_node_name{job="kubelet"})
labels:
  quantile: "0.99"
record: node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile
{{< /code >}}
 
##### node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.9, sum(rate(kubelet_pleg_relist_duration_seconds_bucket[5m])) by (instance, le) * on(instance) group_left(node) kubelet_node_name{job="kubelet"})
labels:
  quantile: "0.9"
record: node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile
{{< /code >}}
 
##### node_quantile:kubelet_pleg_relist_duration_seconds:histogram_quantile

{{< code lang="yaml" >}}
expr: |
  histogram_quantile(0.5, sum(rate(kubelet_pleg_relist_duration_seconds_bucket[5m])) by (instance, le) * on(instance) group_left(node) kubelet_node_name{job="kubelet"})
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
- [statefulset](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/statefulset.json)
- [workload-total](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes/dashboards/workload-total.json)
