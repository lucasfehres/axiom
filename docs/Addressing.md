# Addressing

## IPv4

| Block (CIDR)    | Allocation                         |
| --------------- | ---------------------------------- |
| 10.67.1.0/24    | Proxmox FSN01-01                   |
| 10.67.2.0/24    | Axiom WireGuard clients            |
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

| Block (CIDR) | Range                    | Allocation                 |
| ------------ | ------------------------ | -------------------------- |
| 10.67.1.0/24 | 10.67.1.10 - 10.67.1.100 | Temporary DHCP allocations |

## Routing configurations

| Device | Type             | Block (CIDR) | Interface |
| ------ | ---------------- | ------------ | --------- |
| UGC    | WireGuard Client | 10.67.0.0/16 |           |
