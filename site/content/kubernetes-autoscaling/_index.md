---
title: kubernetes-autoscaling
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/adinhodovic/kubernetes-autoscaling-mixin](https://github.com/adinhodovic/kubernetes-autoscaling-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes-autoscaling/alerts.yaml).
{{< /panel >}}

### karpenter

##### KarpenterCloudProviderErrors

{{< code lang="yaml" >}}
alert: KarpenterCloudProviderErrors
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-kperf-jkwq/kubernetes-autoscaling-karpenter-performance
  description: The Karpenter provider {{ $labels.provider }} with the controller {{
    $labels.controller }} has errors with the method {{ $labels.method }}.
  summary: Karpenter has Cloud Provider Errors.
expr: |
  sum(
    increase(
      karpenter_cloudprovider_errors_total{
        job="karpenter",
        controller!~"nodeclaim.termination|node.termination",
        error!="NodeClaimNotFoundError"
      }[5m]
    )
  ) by (cluster, namespace, job, provider, controller, method) > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### KarpenterNodeClaimsTerminationDurationHigh

{{< code lang="yaml" >}}
alert: KarpenterNodeClaimsTerminationDurationHigh
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-kact-jkwq/kubernetes-autoscaling-karpenter-activity
  description: The average node claim termination duration in Karpenter has exceeded
    20 minutes for more than 15 minutes in nodepool {{ $labels.nodepool }}. This may
    indicate cloud provider issues or improper instance termination handling.
  summary: Karpenter Node Claims Termination Duration is High.
expr: |
  sum(
    rate(
      karpenter_nodeclaims_termination_duration_seconds_sum{
        job="karpenter"
      }[5m]
    )
  ) by (cluster, namespace, job, nodepool)
  /
  sum(
    rate(
      karpenter_nodeclaims_termination_duration_seconds_count{
        job="karpenter"
      }[5m]
    )
  ) by (cluster, namespace, job, nodepool) > 1200
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KarpenterNodepoolNearCapacity

{{< code lang="yaml" >}}
alert: KarpenterNodepoolNearCapacity
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-kover-jkwq/kubernetes-autoscaling-karpenter-overview
  description: The resource {{ $labels.resource_type }} in the Karpenter node pool
    {{ $labels.nodepool }} is nearing its limit. Consider scaling or adding resources.
  summary: Karpenter Nodepool near capacity.
expr: |
  sum (
    karpenter_nodepools_usage{job="karpenter"}
  ) by (cluster, namespace, job, nodepool, resource_type)
  /
  sum (
    karpenter_nodepools_limit{job="karpenter"}
  ) by (cluster, namespace, job, nodepool, resource_type)
  * 100 > 75
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KarpenterClusterStateNotSynced

{{< code lang="yaml" >}}
alert: KarpenterClusterStateNotSynced
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-kperf-jkwq/kubernetes-autoscaling-karpenter-performance
  description: The Karpenter cluster state is not synced. This indicates Karpenter
    cannot properly track cluster resources and may fail to provision or deprovision
    nodes correctly.
  summary: Karpenter Cluster State Not Synced.
expr: |
  sum(
    karpenter_cluster_state_synced{
      job="karpenter"
    }
  ) by (cluster, namespace, job) == 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KarpenterSchedulerQueueDepthHigh

{{< code lang="yaml" >}}
alert: KarpenterSchedulerQueueDepthHigh
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-kperf-jkwq/kubernetes-autoscaling-karpenter-performance
  description: The Karpenter scheduler has {{ $value }} pods waiting to be scheduled.
    This may indicate provisioning issues or insufficient capacity.
  summary: Karpenter Scheduler Queue Depth High.
expr: |
  sum(
    karpenter_scheduler_queue_depth{
      job="karpenter"
    }
  ) by (cluster, namespace, job) > 50
for: 15m
labels:
  severity: warning
{{< /code >}}
 
### cluster-autoscaler

##### ClusterAutoscalerNodeCountNearCapacity

{{< code lang="yaml" >}}
alert: ClusterAutoscalerNodeCountNearCapacity
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-ca-jkwq/kubernetes-autoscaling-cluster-autoscaler
  description: The node count for the cluster autoscaler job {{ $labels.job }} is
    reaching max limit. Consider scaling node groups.
  summary: Cluster Autoscaler Node Count near Capacity.
expr: |
  sum (
    cluster_autoscaler_nodes_count{
      job="cluster-autoscaler"
    }
  ) by (cluster, namespace, job)
  /
  sum (
    cluster_autoscaler_max_nodes_count{
      job="cluster-autoscaler"
    }
  ) by (cluster, namespace, job)
  * 100 > 75
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ClusterAutoscalerUnschedulablePods

{{< code lang="yaml" >}}
alert: ClusterAutoscalerUnschedulablePods
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-ca-jkwq/kubernetes-autoscaling-cluster-autoscaler
  description: The cluster currently has unschedulable pods, indicating resource shortages.
    Consider adding more nodes or increasing node group capacity.
  summary: Pods Pending Scheduling - Cluster Node Group Scaling Required
expr: |
  sum (
    cluster_autoscaler_unschedulable_pods_count{
      job="cluster-autoscaler"
    }
  ) by (cluster, namespace, job)
  > 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ClusterAutoscalerNodeGroupAtCapacity

{{< code lang="yaml" >}}
alert: ClusterAutoscalerNodeGroupAtCapacity
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-ca-jkwq/kubernetes-autoscaling-cluster-autoscaler
  description: Node group {{ $labels.node_group }} is above 95% expected capacity.
  summary: Cluster Autoscaler Node Group At Capacity
expr: |
  (
    avg (
      cluster_autoscaler_node_group_target_count{
        job="cluster-autoscaler"
      }
    ) by (cluster, namespace, job, node_group) /
    max (
      cluster_autoscaler_node_group_max_count{
        job="cluster-autoscaler"
      }
    ) by (cluster, namespace, job, node_group)
    * 100
  ) >= 95
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ClusterAutoscalerAllNodeGroupsAtCapacity

{{< code lang="yaml" >}}
alert: ClusterAutoscalerAllNodeGroupsAtCapacity
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-ca-jkwq/kubernetes-autoscaling-cluster-autoscaler
  description: All node groups are above 95% expected capacity.
  summary: All Cluster Autoscaler Node Groups At Capacity
expr: |
  (
    count (
      (
        avg (
          cluster_autoscaler_node_group_target_count{
            job="cluster-autoscaler"
          }
        ) by (cluster, namespace, job, node_group) /
        max (
          cluster_autoscaler_node_group_max_count{
            job="cluster-autoscaler"
          }
        ) by (cluster, namespace, job, node_group)
        * 100
      ) < 95
    ) by (cluster, namespace, job)
    or
    count (
      cluster_autoscaler_node_group_max_count{
        job="cluster-autoscaler"
      }
    ) by (cluster, namespace, job) * 0
  ) == 0
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### ClusterAutoscalerNodeGroupUnhealthy

{{< code lang="yaml" >}}
alert: ClusterAutoscalerNodeGroupUnhealthy
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-ca-jkwq/kubernetes-autoscaling-cluster-autoscaler
  description: Node group {{ $labels.node_group }} is unhealthy.
  summary: Cluster Autoscaler Node Group Unhealthy
expr: |
  max (
    cluster_autoscaler_node_group_healthiness{
      job="cluster-autoscaler"
    }
  ) by (cluster, namespace, job, node_group) == 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### ClusterAutoscalerNoHealthyNodeGroups

{{< code lang="yaml" >}}
alert: ClusterAutoscalerNoHealthyNodeGroups
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-ca-jkwq/kubernetes-autoscaling-cluster-autoscaler
  description: No node groups are healthy.
  summary: No Healthy Cluster Autoscaler Node Groups
expr: |
  sum (
    cluster_autoscaler_node_group_healthiness{
      job="cluster-autoscaler"
    }
  ) by (cluster, namespace, job) == 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
### keda

##### KedaScaledJobErrors

{{< code lang="yaml" >}}
alert: KedaScaledJobErrors
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-kedasj-jkwq/kubernetes-autoscaling-keda-scaled-job?var-scaled_job={{
    $labels.scaledObject }}&var-resource_namespace={{ $labels.exported_namespace }}
  description: KEDA scaled jobs are experiencing errors. Check the scaled job {{ $labels.scaledObject
    }} in the namespace {{ $labels.exported_namespace }}.
  summary: Errors detected for KEDA scaled jobs.
expr: |
  sum(
    increase(
      keda_scaled_job_errors_total{
        job="keda-operator"
      }[10m]
    )
  ) by (cluster, job, exported_namespace, scaledObject) > 0
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### KedaScaledObjectErrors

{{< code lang="yaml" >}}
alert: KedaScaledObjectErrors
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-kedaso-jkwq/kubernetes-autoscaling-keda-scaled-object?var-scaled_object={{
    $labels.scaledObject }}&var-resource_namespace={{ $labels.exported_namespace }}
  description: KEDA scaled objects are experiencing errors. Check the scaled object
    {{ $labels.scaledObject }} in the namespace {{ $labels.exported_namespace }}.
  summary: Errors detected for KEDA scaled objects.
expr: |
  sum(
    increase(
      keda_scaled_object_errors_total{
        job="keda-operator"
      }[10m]
    )
  ) by (cluster, job, exported_namespace, scaledObject) > 0
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### KedaScalerLatencyHigh

{{< code lang="yaml" >}}
alert: KedaScalerLatencyHigh
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-kedaso-jkwq/kubernetes-autoscaling-keda-scaled-object?var-scaled_object={{
    $labels.scaledObject }}&var-scaler={{ $labels.scaler }}
  description: Metric latency for scaler {{ $labels.scaler }} for the object {{ $labels.scaledObject
    }} has exceeded acceptable limits.
  summary: High latency for KEDA scaler metrics.
expr: |
  avg(
    keda_scaler_metrics_latency_seconds{
      job="keda-operator"
    }
  ) by (cluster, job, exported_namespace, scaledObject, scaler) > 5
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### KedaScaledObjectPaused

{{< code lang="yaml" >}}
alert: KedaScaledObjectPaused
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-kedaso-jkwq/kubernetes-autoscaling-keda-scaled-object?var-scaled_object={{
    $labels.scaledObject }}&var-resource_namespace={{ $labels.exported_namespace }}
  description: The scaled object {{ $labels.scaledObject }} in namespace {{ $labels.exported_namespace
    }} is paused for longer than 25h. This may indicate a configuration issue or manual
    intervention.
  summary: KEDA scaled object is paused.
expr: |
  max(
    keda_scaled_object_paused{
      job="keda-operator"
    }
  ) by (cluster, job, exported_namespace, scaledObject) > 0
for: 25h
labels:
  severity: warning
{{< /code >}}
 
##### KedaScalerDetailErrors

{{< code lang="yaml" >}}
alert: KedaScalerDetailErrors
annotations:
  dashboard_url: https://grafana.com/d/kubernetes-autoscaling-mixin-kedaso-jkwq/kubernetes-autoscaling-keda-scaled-object?var-scaler={{
    $labels.scaler }}&var-scaled_object={{ $labels.scaledObject }}
  description: Errors have occurred in the KEDA scaler {{ $labels.scaler }}. Investigate
    the scaler for the {{ $labels.type }} {{ $labels.scaledObject }} in namespace
    {{ $labels.exported_namespace }}.
  summary: Errors detected in KEDA scaler.
expr: |
  sum(
    increase(
      keda_scaler_detail_errors_total{
        job="keda-operator"
      }[10m]
    )
  ) by (cluster, job, exported_namespace, scaledObject, type, scaler) > 0
for: 1m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [kubernetes-autoscaling-mixin-ca](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes-autoscaling/dashboards/kubernetes-autoscaling-mixin-ca.json)
- [kubernetes-autoscaling-mixin-hpa](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes-autoscaling/dashboards/kubernetes-autoscaling-mixin-hpa.json)
- [kubernetes-autoscaling-mixin-karpenter-act](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes-autoscaling/dashboards/kubernetes-autoscaling-mixin-karpenter-act.json)
- [kubernetes-autoscaling-mixin-karpenter-over](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes-autoscaling/dashboards/kubernetes-autoscaling-mixin-karpenter-over.json)
- [kubernetes-autoscaling-mixin-karpenter-perf](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes-autoscaling/dashboards/kubernetes-autoscaling-mixin-karpenter-perf.json)
- [kubernetes-autoscaling-mixin-keda-sj](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes-autoscaling/dashboards/kubernetes-autoscaling-mixin-keda-sj.json)
- [kubernetes-autoscaling-mixin-keda-so](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes-autoscaling/dashboards/kubernetes-autoscaling-mixin-keda-so.json)
- [kubernetes-autoscaling-mixin-pdb](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes-autoscaling/dashboards/kubernetes-autoscaling-mixin-pdb.json)
- [kubernetes-autoscaling-mixin-vpa](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes-autoscaling/dashboards/kubernetes-autoscaling-mixin-vpa.json)
