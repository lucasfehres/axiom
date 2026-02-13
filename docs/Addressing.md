# Addressing

## IPv4

| Block (CIDR)    | Allocation                         | Where           |
| --------------- | ---------------------------------- | --------------- |
| 10.0.0.0/24     | Pod CIDR                           | Chaos           |
| 10.20.0.0/16    | Pod CIDR                           | Chaos (Unused?) |
| 10.21.0.0/16    | Service CIDR                       | Chaos           |
| 10.42.0.0/16    | Pod CIDR                           | FSN01           |
| 10.43.0.0/16    | Service CIDR                       | FSN01           |
| 10.67.1.0/24    | Proxmox FSN01-01                   | FSN01           |
| 10.67.2.0/24    | Axiom WireGuard clients            | FSN01           |
| 10.67.3.0/24    | Axiom K8s Cilium pool              | FSN01           |
| 10.80.0.0/16    | Liqo cross-cluster networking      | FSN01 <> Chaos  |
| 192.168.1.0/24  | Home network: General clients      | UGC             |
| 192.168.2.0/24  | Home network: Legacy               | UGC             |
| 192.168.3.0/24  | Home network: WireGuard            | UGC             |
| 192.168.4.0/24  | Home network: No AirPlay           | UGC             |
| 192.168.5.0/24  | Home network: IPTV                 | UGC             |
| 192.168.6.0/24  | Home network: UniFi Teleport       | UGC             |
| 192.168.7.0/24  | Home network: VoIP                 | UGC             |
| 192.168.8.0/24  | Home network: Testing              | UGC             |
| 192.168.9.0/24  | Home network: ISP WAN              | UGC             |
| 192.168.10.0/24 | Home network: ISP VoIP             | UGC             |
| 192.168.11.0/24 | Home network: Reverse Axiom access | UGC             |

### Risks

Chaos appears to be using a cluster pod CIDR of 10.0.0.0/16. However, it is not strictly controlled.
If Chaos selects an IP range colliding with 10.67.0.0/16 there will be problems.

### Suballocations

| Block (CIDR) | Range                     | Allocation                 |
| ------------ | ------------------------- | -------------------------- |
| 10.67.1.0/24 | 10.67.1.10 - 10.67.1.100  | Temporary DHCP allocations |
| 10.67.1.0/24 | 10.67.1.101 - 10.67.1.200 | Axiom VMs                  |
| 10.67.1.0/24 | 10.67.1.201 - 10.67.1.220 | Playground VMs             |

## Undeclarative Firewall Rules

The external to internal allow is unfortunate as this is not restricted to just the Axiom
WireGuard client interface but it is fine.

| Device | Source Zone | Source Block | Action | Destination Zone |
| ------ | ----------- | ------------ | ------ | ---------------- |
| UGC    | External    | 10.67.0.0/16 | Allow  | Internal         |
