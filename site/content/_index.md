---
title: Prometheus Monitoring Mixins
---

A mixin is a set of Grafana dashboards and Prometheus rules and alerts, packaged together in a reuseable and extensible bundle.
Mixins are written in [jsonnet](https://jsonnet.org/), and are typically installed and updated with [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler).

For more information about mixins, see:
* [Prometheus Monitoring Mixins Design Doc](https://docs.google.com/document/d/1A9xvzwqnFVSOZ5fD3blKODXfsat5fg6ZhnKu9LK3lB4/view). A [cached pdf](design.pdf) is included in monitoring mixins [documentation repository](https://github.com/monitoring-mixins/docs).
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

Make sure you have the ksonnet v0.8.0:

```bash
$ brew install https://raw.githubusercontent.com/ksonnet/homebrew-tap/82ef24cb7b454d1857db40e38671426c18cd8820/ks.rb
$ brew pin ks
$ ks version
ksonnet version: v0.8.0
jsonnet version: v0.9.5
client-go version: v1.6.8-beta.0+$Format:%h$
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
$ jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusAlerts)' > alerts.yml
$ jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusRules)' >files/rules.yml
$ jsonnet -J vendor -m files/dashboards -e '(import "mixin.libsonnet").grafanaDashboards'
```
