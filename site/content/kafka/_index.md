---
title: kafka
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/kafka-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/kafka/alerts.yaml).
{{< /panel >}}

### kafka-kafka-alerts

##### KafkaLagKeepsIncreasing

{{< code lang="yaml" >}}
alert: KafkaLagKeepsIncreasing
annotations:
  description: 'Kafka lag keeps increasing over the last 15 minutes for consumer group:
    {{$labels.consumergroup}}, topic: {{$labels.topic}}.'
  summary: Kafka lag keeps increasing.
expr: sum by (job,kafka_cluster, topic, consumergroup) (delta(kafka_consumergroup_uncommitted_offsets{topic!="__consumer_offsets",consumergroup!="",job="integrations/kafka"}[5m]))
  > 0
for: 15m
keep_firing_for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### KafkaLagIsTooHigh

{{< code lang="yaml" >}}
alert: KafkaLagIsTooHigh
annotations:
  description: 'Total kafka lag across all partitions is too high ({{ printf "%.0f"
    $value }}) for consumer group: {{$labels.consumergroup}}, topic: {{$labels.topic}}.'
  summary: Kafka lag is too high.
expr: sum by (job,kafka_cluster, topic, consumergroup) (kafka_consumergroup_uncommitted_offsets{topic!="__consumer_offsets",consumergroup!="",job="integrations/kafka"})
  > 100
for: 15m
keep_firing_for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### KafkaISRExpandRate

{{< code lang="yaml" >}}
alert: KafkaISRExpandRate
annotations:
  description: Kafka broker {{ $labels.instance }} in cluster {{ $labels.kafka_cluster
    }} In-Sync Replica (ISR) is expanding by {{ $value }} per second. If a broker
    goes down, ISR for some of the partitions shrink. When that broker is up again,
    ISRs are expanded once the replicas are fully caught up. Other than that, the
    expected value for ISR expansion rate is 0. If ISR is expanding and shrinking
    frequently, adjust Allowed replica lag.
  summary: Kafka ISR expansion rate is expanding.
expr: |
  sum by (job,kafka_cluster,instance) (sum by (job,kafka_cluster,instance) (kafka_server_replicamanager_isrexpandspersec{job="integrations/kafka"})) != 0
for: 5m
keep_firing_for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KafkaISRShrinkRate

{{< code lang="yaml" >}}
alert: KafkaISRShrinkRate
annotations:
  description: Kafka broker {{ $labels.instance }} in cluster {{ $labels.kafka_cluster
    }} In-Sync Replica (ISR) is shrinking by {{ $value }} per second. If a broker
    goes down, ISR for some of the partitions shrink. When that broker is up again,
    ISRs are expanded once the replicas are fully caught up. Other than that, the
    expected value for ISR shrink rate is 0. If ISR is expanding and shrinking frequently,
    adjust Allowed replica lag.
  summary: Kafka ISR expansion rate is shrinking.
expr: |
  sum by (job,kafka_cluster,instance) (sum by (job,kafka_cluster,instance) (kafka_server_replicamanager_isrshrinkspersec{job="integrations/kafka"})) != 0
for: 5m
keep_firing_for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### KafkaOfflinePartitonCount

{{< code lang="yaml" >}}
alert: KafkaOfflinePartitonCount
annotations:
  description: Kafka cluster {{ $labels.kafka_cluster }} has {{ $value }} offline
    partitions. After successful leader election, if the leader for partition dies,
    then the partition moves to the OfflinePartition state. Offline partitions are
    not available for reading and writing. Restart the brokers, if needed, and check
    the logs for errors.
  summary: Kafka has offline partitons.
expr: |
  sum by (job,kafka_cluster) (kafka_controller_kafkacontroller_offlinepartitionscount{job="integrations/kafka"}) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### KafkaUnderReplicatedPartitionCount

{{< code lang="yaml" >}}
alert: KafkaUnderReplicatedPartitionCount
annotations:
  description: Kafka broker {{ $labels.instance }} in cluster {{ $labels.kafka_cluster
    }} has {{ $value }} under replicated partitons
  summary: Kafka has under replicated partitons.
expr: |
  sum by (job,kafka_cluster,instance) (kafka_cluster_partition_underreplicated{job="integrations/kafka"}) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### KafkaNoActiveController

{{< code lang="yaml" >}}
alert: KafkaNoActiveController
annotations:
  description: Kafka cluster {{ $labels.kafka_cluster }} has {{ $value }} broker(s)
    reporting as the active controller in the last 5 minute interval. During steady
    state there should be only one active controller per cluster.
  summary: Kafka has no active controller.
expr: sum by(job,kafka_cluster) (kafka_controller_kafkacontroller_activecontrollercount{job="integrations/kafka"})
  != 1
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### KafkaUncleanLeaderElection

{{< code lang="yaml" >}}
alert: KafkaUncleanLeaderElection
annotations:
  description: Kafka cluster {{ $labels.kafka_cluster }} has {{ $value }} unclean
    partition leader elections reported in the last 5 minute interval. When unclean
    leader election is held among out-of-sync replicas, there is a possibility of
    data loss if any messages were not synced prior to the loss of the former leader.
    So if the number of unclean elections is greater than 0, investigate broker logs
    to determine why leaders were re-elected, and look for WARN or ERROR messages.
    Consider setting the broker configuration parameter unclean.leader.election.enable
    to false so that a replica outside of the set of in-sync replicas is never elected
    leader.
  summary: Kafka has unclean leader elections.
expr: (sum by (job,kafka_cluster,instance) (kafka_controller_controllerstats_uncleanleaderelectionspersec{job="integrations/kafka"}))
  != 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### KafkaBrokerCount

{{< code lang="yaml" >}}
alert: KafkaBrokerCount
annotations:
  description: Kafka cluster {{ $labels.kafka_cluster }} broker count is 0.
  summary: Kafka has no brokers online.
expr: count by(job,kafka_cluster) (kafka_server_kafkaserver_brokerstate{job="integrations/kafka"})
  == 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### KafkaZookeeperSyncConnect

{{< code lang="yaml" >}}
alert: KafkaZookeeperSyncConnect
annotations:
  description: Kafka broker {{ $labels.instance }} in cluster {{ $labels.kafka_cluster
    }} has disconected from Zookeeper.
  summary: Kafka Zookeeper sync disconected.
expr: avg by(job,kafka_cluster,instance) (rate(kafka_server_sessionexpirelistener_zookeepersyncconnectspersec{quantile="0.95",job="integrations/kafka"}[5m]))
  < 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
### kafka-jvm-alerts

##### JvmMemoryFillingUp

{{< code lang="yaml" >}}
alert: JvmMemoryFillingUp
annotations:
  description: JVM heap memory usage is at {{ printf "%.0f" $value }}% over the last
    5 minutes on {{$labels.instance}}, which is above the threshold of 80%.
  summary: JVM heap memory filling up.
expr: ((sum without (id) (jvm_memory_bytes_used{area="heap", job="integrations/kafka"}))/(sum
  without (id) (jvm_memory_bytes_max{area="heap", job="integrations/kafka"} != -1)))
  * 100 > 80
for: 5m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### JvmThreadsDeadlocked

{{< code lang="yaml" >}}
alert: JvmThreadsDeadlocked
annotations:
  description: 'JVM deadlock detected: Threads in the JVM application {{$labels.instance}}
    are in a cyclic dependency with each other. The restart is required to resolve
    the deadlock.'
  summary: JVM deadlock detected.
expr: (jvm_threads_deadlocked{job="integrations/kafka"}) > 0
for: 2m
keep_firing_for: 5m
labels:
  severity: critical
{{< /code >}}
 
### kafka-zookeeper-jvm-alerts

##### JvmMemoryFillingUp

{{< code lang="yaml" >}}
alert: JvmMemoryFillingUp
annotations:
  description: JVM heap memory usage is at {{ printf "%.0f" $value }}% over the last
    5 minutes on {{$labels.instance}}, which is above the threshold of 80%.
  summary: JVM heap memory filling up.
expr: ((sum without (id) (jvm_memory_bytes_used{area="heap", job=~"integrations/kafka-zookeeper|integrations/kafka"}))/(sum
  without (id) (jvm_memory_bytes_max{area="heap", job=~"integrations/kafka-zookeeper|integrations/kafka"}
  != -1))) * 100 > 80
for: 5m
keep_firing_for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### JvmThreadsDeadlocked

{{< code lang="yaml" >}}
alert: JvmThreadsDeadlocked
annotations:
  description: 'JVM deadlock detected: Threads in the JVM application {{$labels.instance}}
    are in a cyclic dependency with each other. The restart is required to resolve
    the deadlock.'
  summary: JVM deadlock detected.
expr: (jvm_threads_deadlocked{job=~"integrations/kafka-zookeeper|integrations/kafka"})
  > 0
for: 2m
keep_firing_for: 5m
labels:
  severity: critical
{{< /code >}}
 
