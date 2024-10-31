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
        job=~"karpenter"
      }[5m]
    )
  ) by (namespace, job, provider, controller, method) > 0
for: 5m
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
    karpenter_nodepools_usage{job=~"karpenter"}
  ) by (namespace, job, nodepool, resource_type)
  /
  sum (
    karpenter_nodepools_limit{job=~"karpenter"}
  ) by (namespace, job, nodepool, resource_type)
  * 100 > 75
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
    cluster_autoscaler_nodes_count{job=~"cluster-autoscaler"}
  ) by (namespace, job)
  /
  sum (
    cluster_autoscaler_max_nodes_count{job=~"cluster-autoscaler"}
  ) by (namespace, job)
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
    cluster_autoscaler_unschedulable_pods_count{job=~"cluster-autoscaler"}
  ) by (namespace, job)
  > 0
for: 15m
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
- [kubernetes-autoscaling-mixin-pdb](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes-autoscaling/dashboards/kubernetes-autoscaling-mixin-pdb.json)
- [kubernetes-autoscaling-mixin-vpa](https://github.com/monitoring-mixins/website/blob/master/assets/kubernetes-autoscaling/dashboards/kubernetes-autoscaling-mixin-vpa.json)
