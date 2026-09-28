# Linux Network Interface Names

## 1. What are Network Interface Names?

A network interface is the Linux representation of a physical or virtual network adapter.

Common examples:

```text
eth0
enp4s0
enp3s0
ens33
eno1
wlp0s20f3
```

The exact name depends on the system hardware, firmware, virtualization platform, and Linux naming scheme.

---

## 2. Common Interface Names

| Name | Meaning / Naming Style | Typical Use |
|---|---|---|
| `eth0` | Traditional Ethernet naming | Older Linux systems |
| `enp4s0` | Ethernet + PCI bus 4 + slot 0 | Modern physical Ethernet |
| `enp3s0` | Ethernet + PCI bus 3 + slot 0 | Modern physical Ethernet |
| `ens33` | Ethernet + firmware/slot-based identifier | Common in VMware VMs |
| `eno1` | Ethernet + onboard NIC #1 | Physical servers |
| `wlp0s20f3` | Wireless LAN + PCI bus/slot/function identifiers | Wi-Fi interfaces |

---

## 3. Understanding `enp4s0`

The name can be understood as:

```text
enp4s0
││ ││
││ │└── Slot 0
││ └─── PCI bus 4
│└───── Ethernet
```

Therefore:

```text
enp4s0 = Ethernet interface associated with PCI bus 4, slot 0
```

You normally **do not need to memorize the complete naming formula** for RHCSA. The important point is that modern Linux uses predictable interface names instead of simply `eth0`, `eth1`, etc.

---

## 4. Why Modern Linux Uses Names Like `enp4s0`

Older Linux systems commonly used:

```text
eth0
eth1
eth2
```

The numbering could change when hardware was added, removed, or detected in a different order.

Modern Linux systems commonly use **predictable network interface names**, such as:

```text
enp4s0
eno1
ens33
```

These names are based on information such as the hardware's physical location, firmware information, or onboard position.

This makes interface identification more predictable.

---

## 5. How to Find the Interface Name

Never assume that the interface is `enp4s0`.

On a newly installed Ubuntu system, check the actual interface names.

### Method 1: `ip link`

```bash
ip link
```

Example:

```text
1: lo:
2: enp4s0:
3: wlp0s20f3:
```

Here:

```text
enp4s0      = Ethernet
wlp0s20f3   = Wi-Fi
lo          = Loopback
```

### Method 2: `nmcli`

```bash
nmcli device status
```

Example:

```text
DEVICE      TYPE      STATE         CONNECTION
enp4s0      ethernet  connected     Wired connection 1
wlp0s20f3   wifi      disconnected  --
lo          loopback  connected      lo
```

This is particularly useful when working with **NetworkManager**.

### Method 3: `ip addr`

```bash
ip addr
```

Example:

```text
2: enp4s0:
    inet 192.168.36.28/24
```

This shows that `enp4s0` has the IP address:

```text
192.168.36.28/24
```

---

## 6. Important Interface Types

### Ethernet

Examples:

```text
enp4s0
enp3s0
ens33
eno1
eth0
```

Used for wired network connections.

### Wi-Fi

Example:

```text
wlp0s20f3
```

Used for wireless network connections.

### Loopback

```text
lo
```

The loopback interface is used by the system to communicate with itself.

Typical address:

```text
127.0.0.1
```

### Docker Bridge

Example:

```text
docker0
```

Created by Docker for container networking.

---

## 7. Your Ubuntu System Example

Your system shows:

```text
DEVICE           TYPE      STATE
enp4s0           ethernet  connected
wlp0s20f3        wifi      unavailable
docker0          bridge    connected
lo               loopback  connected
```

Your active Ethernet interface is:

```text
enp4s0
```

It currently has:

```text
192.168.36.28/24
```

You can inspect it with:

```bash
ip addr show enp4s0
```

or:

```bash
nmcli device show enp4s0
```

---

## 8. Important RHCSA Commands

For RHCSA, remember these commands:

```bash
# List network interfaces
ip link

# Show IP addresses
ip addr

# Show NetworkManager device status
nmcli device status

# Show saved NetworkManager connections
nmcli connection show

# Show details of a device
nmcli device show enp4s0

# Show details of a connection
nmcli connection show "Wired connection 1"
```

---

## 9. Interview Answer

**Question:** How do you find the network interface name on a new Linux system?

**Answer:**

> I can use `ip link` or `nmcli device status` to identify the network interfaces. I don't assume the interface is `eth0` or `enp4s0`, because the actual name depends on the system's predictable naming scheme and hardware.

Example:

```bash
nmcli device status
```

```text
DEVICE      TYPE      STATE
enp4s0      ethernet  connected
wlp0s20f3   wifi      disconnected
```

Therefore, I would use `enp4s0` for the Ethernet configuration on that system.

---

## 10. Quick Memory

```text
eth0       → old/traditional Ethernet name

enp4s0     → Ethernet, PCI-based predictable name

eno1       → onboard Ethernet interface #1

ens33      → firmware/slot-based Ethernet name

wlp0s20f3  → Wi-Fi interface

lo         → loopback

docker0    → Docker bridge
```

### Golden Rule

> **Don't guess the interface name. Check it first.**

```bash
ip link
```

or:

```bash
nmcli device status
```
