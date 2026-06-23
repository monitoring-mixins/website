---
title: tailscale
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/adinhodovic/tailscale-exporter](https://github.com/adinhodovic/tailscale-exporter/tree/master/tailscale-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/tailscale/alerts.yaml).
{{< /panel >}}

### tailscale-tailnet-alerts

##### TailscaleDeviceUnauthorized

{{< code lang="yaml" >}}
alert: TailscaleDeviceUnauthorized
annotations:
  dashboard_url: https://grafana.com/d/tailscale-mixin-over-k12e/tailscale-overview
  description: 'Tailscale Device {{ $labels.name }} (ID: {{ $labels.id }}) in Tailnet
    {{ $labels.tailnet }} is unauthorized. Please authorize it in the Tailscale admin
    console.'
  summary: Tailscale Device is Unauthorized
expr: |
  sum(
    tailscale_devices_authorized
  ) by (tailnet, name, id)
  == 0
for: 15m
labels:
  mixin: tailscale
  severity: warning
{{< /code >}}
 
##### TailscaleUserUnapproved

{{< code lang="yaml" >}}
alert: TailscaleUserUnapproved
annotations:
  dashboard_url: https://grafana.com/d/tailscale-mixin-over-k12e/tailscale-overview
  description: 'Tailscale User {{ $labels.login_name }} (ID: {{ $labels.id }}) in
    Tailnet {{ $labels.tailnet }} is unapproved. Please approve it in the Tailscale
    admin console.'
  summary: Tailscale User is Unapproved
expr: |
  sum(
    tailscale_users_info{
      status="needs-approval"
    }
  ) by (tailnet, login_name, id)
  == 1
for: 15m
labels:
  mixin: tailscale
  severity: warning
{{< /code >}}
 
##### TailscaleUserRecentlyCreated

{{< code lang="yaml" >}}
alert: TailscaleUserRecentlyCreated
annotations:
  dashboard_url: https://grafana.com/d/tailscale-mixin-over-k12e/tailscale-overview
  description: 'Tailscale User {{ $labels.login_name }} (ID: {{ $labels.id }}) in
    Tailnet {{ $labels.tailnet }} was created within the last 300 seconds.'
  summary: Tailscale User Recently Created
expr: |
  time() -
  (
    max(
      tailscale_users_created_timestamp{}
    ) by (tailnet, id, login_name)
  )
  < 300
labels:
  mixin: tailscale
  severity: info
{{< /code >}}
 
##### TailscaleDeviceUnapprovedRoutes

{{< code lang="yaml" >}}
alert: TailscaleDeviceUnapprovedRoutes
annotations:
  dashboard_url: https://grafana.com/d/tailscale-mixin-over-k12e/tailscale-overview
  description: 'Tailscale Device {{ $labels.name }} (ID: {{ $labels.id }}) in Tailnet
    {{ $labels.tailnet }} has more than 10% unapproved routes for longer than 15m.'
  summary: Tailscale Device has Unapproved Routes
expr: |
  100 -
  (
    (
      sum(
        tailscale_devices_routes_enabled
      ) by (tailnet, name, id)
      /
      sum(
        tailscale_devices_routes_advertised
      ) by (tailnet, name, id)
    )
    * 100
  )
  > 10
for: 15m
labels:
  mixin: tailscale
  severity: warning
{{< /code >}}
 
### tailscaled-machine-alerts

##### TailscaledMachineHighOutboundDroppedPackets

{{< code lang="yaml" >}}
alert: TailscaledMachineHighOutboundDroppedPackets
annotations:
  dashboard_url: https://grafana.com/d/tailscaled-mixin-over-k12e/tailscale-machine?var-tailscale_machine={{
    $labels.tailscale_machine }}
  description: Tailscaled Machine {{ $labels.tailscale_machine }} has a high rate
    of outbound dropped packets (>{{ 50 }}%) for longer than 15m.
  summary: Tailscaled Machine has High Outbound Dropped Packets
expr: |
  sum(
    increase(
      tailscaled_outbound_dropped_packets_total{}
      [5m]
    )
  ) by (tailscale_machine)
  /
  sum (
    increase(
      tailscaled_outbound_packets_total{}
      [5m]
    )
  ) by (tailscale_machine)
  * 100
  > 50
for: 15m
labels:
  mixin: tailscale
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [tailscale-machine](https://github.com/monitoring-mixins/website/blob/master/assets/tailscale/dashboards/tailscale-machine.json)
- [tailscale-overview](https://github.com/monitoring-mixins/website/blob/master/assets/tailscale/dashboards/tailscale-overview.json)
