# Chaos

The Chaos section of Axiom is ran on Rackspace's Spot managed Kubernetes offering. It is dirt cheap,
but nodes may become unavailable at any moment. For this reason it is only used for explicitly offloaded,
selected workloads.

## Liqo peering

Peering the 2 clusters is done through
[declarative peering](https://docs.liqo.io/en/stable/advanced/peering/peering-via-cr.html). In case of
disaster recovery the WireGuard secrets may have to be reconfigured.

## Liqo orchestration
