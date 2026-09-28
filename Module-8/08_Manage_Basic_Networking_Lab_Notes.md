# RHCSA Module 8: Manage Basic Networking
## Comprehensive Lab Notes & Reference Guide

This module covers persistent IPv4/IPv6 configuration, hostname resolution, startup behavior, and firewall access with NetworkManager and firewalld. Interface names, addresses, gateways, DNS servers, and allowed services are task-specific; use supplied values.

## Contents
1. Inspect interfaces and connections
2. Configure IPv4 with nmcli
3. Configure IPv6 with nmcli
4. Hostname resolution
5. Start network services automatically
6. Restrict access with firewalld
7. Verification and persistence

## 1. Inspect Interfaces and Connections

RHEL uses NetworkManager to manage network devices and connection profiles. A device is a network interface; a connection profile stores its configuration. Do not assume the interface is named `eth0`.

```bash
ip -brief address
ip route
nmcli device status
nmcli connection show
nmcli connection show --active
nmcli device show DEVICE
```

Use the connection profile name in `nmcli connection modify`, not necessarily the device name. Before changing a remote system, identify a console or recovery path: activating a new profile can interrupt SSH access.

## 2. Configure IPv4 with nmcli

For a static profile, configure address/prefix, gateway, DNS, and method. Replace placeholders with task values:

```bash
sudo nmcli connection modify "PROFILE" \
  ipv4.method manual \
  ipv4.addresses "192.0.2.25/24" \
  ipv4.gateway "192.0.2.1" \
  ipv4.dns "192.0.2.53 198.51.100.53" \
  connection.autoconnect yes
sudo nmcli connection up "PROFILE"
```

For DHCP, use `ipv4.method auto`; clear stale static values if needed. Validate the assigned address, default route, and resolver settings with `ip address`, `ip route`, and `nmcli device show`.

A profile can be inspected or changed interactively with `nmcli connection edit PROFILE`. Changes to a profile persist; device state alone may not.

## 3. Configure IPv6 with nmcli

IPv6 commonly uses SLAAC or DHCPv6 (`ipv6.method auto`). Static configuration uses a prefix length and optional gateway/DNS:

```bash
sudo nmcli connection modify "PROFILE" \
  ipv6.method manual \
  ipv6.addresses "2001:db8:10::25/64" \
  ipv6.gateway "2001:db8:10::1" \
  ipv6.dns "2001:db8:10::53" \
  connection.autoconnect yes
sudo nmcli connection up "PROFILE"
```

Inspect with `ip -6 address`, `ip -6 route`, and `nmcli device show`. IPv6 address assignment can be automatic while DNS information is delivered separately. Do not disable IPv6 unless explicitly required.

## 4. Hostname Resolution

Resolution may use `/etc/hosts`, DNS, and NSS policy in `/etc/nsswitch.conf`. A local hosts entry is useful for a small static mapping; use the provided hostname and address.

```text
192.0.2.40 app1.example.test app1
```

```bash
getent hosts app1.example.test
getent ahosts app1.example.test
```

Set the system hostname with `hostnamectl set-hostname NAME`. DNS servers on a NetworkManager profile should be configured through `nmcli`, not by hand-editing a generated `/etc/resolv.conf`.

## 5. Start Network Services Automatically

Enable the relevant service so it starts on boot, and start it now if required:

```bash
sudo systemctl enable --now NetworkManager
systemctl is-enabled NetworkManager
systemctl is-active NetworkManager
nmcli connection show PROFILE | grep autoconnect
```

For a specific network service requested by a task, identify its unit, check it with `systemctl status`, then enable/start it. Do not enable unrelated daemons or expose their ports without a requirement.

## 6. Restrict Access with firewalld

firewalld uses zones and runtime/permanent configuration. First inspect active zones and current rules:

```bash
sudo firewall-cmd --state
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --get-default-zone
sudo firewall-cmd --zone=public --list-all
```

Allow a named service permanently, then reload and verify:

```bash
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload
sudo firewall-cmd --zone=public --list-services
```

A port may be opened when no service definition applies:

```bash
sudo firewall-cmd --permanent --zone=public --add-port=8443/tcp
sudo firewall-cmd --reload
```

Use `--remove-service` or `--remove-port` to remove unwanted permanent access. `--add-service` without `--permanent` affects runtime only and is lost after reload/reboot. `--permanent` changes saved policy but generally requires reload before affecting runtime. Bind the correct interface or source to a zone only when the task specifies it. Never flush rules or switch to a permissive policy as a shortcut.

## 7. Verification and Persistence

Verify the intended state at both configuration and live levels:

```bash
nmcli connection show PROFILE
ip -brief address
ip route
getent hosts HOSTNAME
sudo firewall-cmd --permanent --zone=ZONE --list-all
sudo firewall-cmd --zone=ZONE --list-all
systemctl is-enabled NetworkManager
```

Check both IPv4 and IPv6 if requested. Test reachability to the specified gateway/service, but remember a failed ping can reflect ICMP filtering rather than a broken route. Reboot only when safe, then verify that connection autoactivation, hostname resolution, service startup, and permanent firewall rules persist.

### Safety Notes
- Keep console access before changing the profile used by your SSH session.
- Do not use example documentation addresses on a real host.
- Open only required services/ports and use the narrowest applicable zone/source.
- Make the change permanent and reload; then inspect runtime and saved state.
