---
title: Prometheus Monitoring Mixins
---

A mixin is a set of Grafana dashboards and Prometheus rules and alerts, packaged together in a reuseable and extensible bundle.
Mixins are written in [jsonnet](https://jsonnet.org/), and are typically installed and updated with [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler).

For more information about mixins, see:
* [Prometheus Monitoring Mixins design doc (cached pdf)](https://github.com/monitoring-mixins/docs/blob/master/design.pdf) is included in monitoring mixins [documentation repository](https://github.com/monitoring-mixins/docs).
* For more motivation, see
"[The RED Method: How to instrument your services](https://kccncna17.sched.com/event/CU8K/the-red-method-how-to-instrument-your-services-b-tom-wilkie-kausal?iframe=no&w=100%&sidebar=yes&bg=no)" talk from CloudNativeCon Austin 2018.  The KLUMPs system demo'd became the basis for the kubernetes-mixin.
* "[Prometheus Monitoring Mixins: Using Jsonnet to Package Together Dashboards, Alerts and Exporters](https://www.youtube.com/watch?v=b7-DtFfsL6E)" talk from CloudNativeCon Copenhagen 2018.
* "[Prometheus Monitoring Mixins: Using Jsonnet to Package Together Dashboards, Alerts and Exporters](https://promcon.io/2018-munich/talks/prometheus-monitoring-mixins/)" talk from PromCon 2018 (slightly updated).

## How to use mixins.

Mixins are designed to be vendored into the repo with your infrastructure config.
To do this, use [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler):

You then have three options for deploying your dashboards
1. Generate the config files and deploy them yourself.
1. Use ksonnet to deploy this mixin along with Prometheus and Grafana.
1. Use kube-prometheus to deploy this mixin.

## Generate config files

You can manually generate the alerts, dashboards and rules files, but first you
must install some tools:

```bash
$ go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb

# macOS
$ brew install jsonnet

# Archlinux AUR
$ yay -S jsonnet
```

Then, grab the mixin and its dependencies:

```bash
$ git clone https://github.com/<mixin org>/<mixin repo>
$ cd <mixin repo>
$ jb install
```

Finally, build the mixin:

```bash
$ make prometheus_alerts.yaml
$ make prometheus_rules.yaml
$ make dashboards_out
```

The `prometheus_alerts.yaml` and `prometheus_rules.yaml` file then need to passed
to your Prometheus server, and the files in `dashboards_out` need to be imported
into you Grafana server.  The exact details will depending on how you deploy your
monitoring stack to Kubernetes.

## Using with prometheus-ksonnet

Alternatively you can also use the mixin with
[prometheus-ksonnet](https://github.com/grafana/jsonnet-libs/tree/master/prometheus-ksonnet),
a [ksonnet](https://github.com/ksonnet/ksonnet) module to deploy a fully-fledged
Prometheus-based monitoring system for Kubernetes:

Make sure you have at least ksonnet v0.8.0:

```bash
$ brew install ksonnet/tap/ks
$ ks version
ksonnet version: 0.13.1
jsonnet version: v0.11.2
client-go version: kubernetes-1.10.4
```

In your config repo, if you don't have a ksonnet application, make a new one (will copy credentials from current context):

```bash
$ ks init <application name>
$ cd <application name>
$ ks env add default
```

Grab the kubernetes-jsonnet module using and its dependencies, which include
the kubernetes-mixin:

```bash
$ go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb
$ jb init
$ jb install github.com/kausalco/public/prometheus-ksonnet

```

Assuming you want to run in the default namespace ('environment' in ksonnet parlance), add the follow to the file `environments/default/main.jsonnet`:

{{< code lang="as3" >}}
local prometheus = import "prometheus-ksonnet/prometheus-ksonnet.libsonnet";

prometheus {
  _config+:: {
    namespace: "default",
  },
}
{{< /code >}}

Apply your config:

```bash
$ ks apply default
```

## Using kube-prometheus

See the kube-prometheus docs for [instructions on how to use mixins with kube-prometheus](https://github.com/coreos/kube-prometheus#kube-prometheus).

## Customising the mixin

Mixins typically allows you to override the selectors used for various jobs,
to match those used in your Prometheus set.

This example uses the [kubernetes-mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin).
 In a new directory, add a file `mixin.libsonnet`:

{{< code lang="as3" >}}
local kubernetes = import "kubernetes-mixin/mixin.libsonnet";

kubernetes {
  _config+:: {
    kubeStateMetricsSelector: 'job="kube-state-metrics"',
    cadvisorSelector: 'job="kubernetes-cadvisor"',
    nodeExporterSelector: 'job="kubernetes-node-exporter"',
    kubeletSelector: 'job="kubernetes-kubelet"',
  },
}
{{< /code >}}

Then, install the kubernetes-mixin:

```bash
$ jb init
$ jb install github.com/kubernetes-monitoring/kubernetes-mixin
```

Generate the alerts, rules and dashboards:

```bash
$ mkdir files
$ jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusAlerts)' > files/alerts.yml
$ jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusRules)' > files/rules.yml
$ mkdir files/dashboards
$ jsonnet -J vendor -m files/dashboards -e '(import "mixin.libsonnet").grafanaDashboards'
```

## Guidelines for alert names, labels, and annotations

Prometheus alerts deliberately allow users to define their own schema for
names, labels, and annotations. The following is a style guide recommended for
alerts in monitoring mixins. Following this guide helps creating useful
notification templates for all mixins and customizing mixin alerts in a unified
fashion.

The alert **name** is a terse description of the alerting condition, using
camel case, without whitespace, starting with a capital letter. The first
component of the name should be shared between all alerts of a mixin (or
between a group of related alerts within a larger mixin). Examples:
`NodeFilesystemAlmostOutOfFiles` (from the [node-exporter
mixin](https://github.com/prometheus/node_exporter/tree/master/docs/node-mixin),
`PrometheusNotificationQueueRunningFull` (from the [Prometheus
mixin](https://github.com/prometheus/prometheus/blob/master/documentation/prometheus-mixin)).

To mark the severity of an alert, use a **label** called `severity` with one of
the following label values:
- `critical` for alerts that require immediate action. For a production system,
  those alerts will usually hit a pager.
- `warning` for alerts that require action eventually but not urgently enough
  to wake someone up or require them to immediately interrupt what they are
  working on. A typical routing target for those alerts is some kind of ticket
  queueing or bug tracking system.
- `info` for alerts that do not require any action by itself but mark something
  as “out of the ordinary”. Those alerts aren't usually routed anywhere, but
  can be inspected during troubleshooting.

An alert can have the following **annotations**:
- `summary` (mandatory): Essentially a more comprehensive and readable version
  of the alert name. Use a human-readable sentence, starting with a capital
  letter and ending with a period. Use a static string or, if dynamic expansion
  is needed, aim for expanding into the same string for alerts that are
  typically grouped together into one notification. In that way, it can be used
  as a common “headline” for all alerts in the notification template. Examples:
  `Filesystem has less than 3% inodes left.` (for the
  `NodeFilesystemAlmostOutOfFiles` alert mentioned above), `Prometheus alert
  notification queue predicted to run full in less than 30m.` (for the
  `PrometheusNotificationQueueRunningFull` alert mentioned above).
- `description` (mandatory): A detailed description of a single alert, with
  most of the important information templated in. The description usually
  expands into a different string for every individual alert within a
  notification. A notification template can iterate through all the
  descriptions and format them into a list. Examples (again corresponding to
  the examples above): `Filesystem on {{ $labels.device }} at {{
  $labels.instance }} has only {{ printf "%.2f" $value }}% available inodes
  left.`, `Alert notification queue of Prometheus %(prometheusName)s is running
  full.`.

Note that we plan to add recommended optional annotations for a runbook link
(presumably called `runbook_url`) and a dashboard link
(`dashboard_url`). However, we still need to work out how to configure patterns
for those URLs across mixins in a useful way.
