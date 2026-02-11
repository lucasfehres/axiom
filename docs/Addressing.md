# Addressing

## IPv4

| Block (CIDR)    | Allocation                         |
| --------------- | ---------------------------------- |
| 10.67.1.0/24    | Proxmox FSN01-01                   |
| 10.67.2.0/24    | Axiom WireGuard clients            |
| 10.67.3.0/24    | Axiom K8s Cilium pool              |
| 10.42.0.0/16    | Cilium podCIDR's                   |
| 10.80.0.0/16    | Liqo cross-cluster networking      |
| 192.168.1.0/24  | Home network: General clients      |
| 192.168.2.0/24  | Home network: Legacy               |
| 192.168.3.0/24  | Home network: WireGuard            |
| 192.168.4.0/24  | Home network: No AirPlay           |
| 192.168.5.0/24  | Home network: IPTV                 |
| 192.168.6.0/24  | Home network: UniFi Teleport       |
| 192.168.7.0/24  | Home network: VoIP                 |
| 192.168.8.0/24  | Home network: Testing              |
| 192.168.9.0/24  | Home network: ISP WAN              |
| 192.168.10.0/24 | Home network: ISP VoIP             |
| 192.168.11.0/24 | Home network: Reverse Axiom access |

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
