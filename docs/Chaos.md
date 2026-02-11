# Chaos

The Chaos section of Axiom is ran on Rackspace's Spot managed Kubernetes offering. It is dirt cheap,
but nodes may become unavailable at any moment. For this reason it is only used for explicitly offloaded,
selected workloads.

## Kilo networking

Networking is provided by Kilo to ensure that spot nodes in Chaos can access the networking in DS01-FSN1.

| Node Type      | Annotation             | Value     | Applied where            |
| -------------- | ---------------------- | --------- | ------------------------ |
| Axiom Primary  | kilo.squat.ai/leader   | true      | kubectl                  |
| Axiom          | kilo.squat.ai/location | fsn1      | kubectl                  |
| Chaos (London) | kilo.squat.ai/location | chaos-ldn | Rackspace Spot interface |

## Liqo orchestration
