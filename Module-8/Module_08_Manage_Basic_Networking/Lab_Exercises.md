# Module 8 Lab Exercises: Manage Basic Networking

Use a disposable VM or console-connected lab. Substitute lab-provided addresses, interface names, gateways, DNS servers, services, and zones. Documentation prefixes in examples must not be used on production networks.

## Lab 1: Inventory Network State
1. Record `ip -brief address`, `ip route`, `ip -6 route`, `nmcli device status`, and active connections.
2. Identify the interface, profile name, default route, and DNS configuration.
3. Identify active firewalld zones and list their rules.

**Verify:** Distinguish interface names from connection-profile names.

## Lab 2: Configure a Static IPv4 Profile
1. Choose the specified existing profile; record its current settings.
2. Set IPv4 method, address/prefix, gateway, DNS, and `connection.autoconnect yes` from the task values.
3. Activate the profile from a console or with a recovery path available.
4. Verify address, route, DNS, profile values, and access to the required target.

**Verify:** The expected static address and default route are active and saved in the profile.

## Lab 3: Configure DHCP IPv4
1. Set the assigned profile to `ipv4.method auto` and clear obsolete static settings if required.
2. Activate the profile and wait for its lease.
3. Verify address, route, DNS, and auto-connect behavior.

**Verify:** The active settings are DHCP-provided and the profile is saved.

## Lab 4: Configure IPv6
1. Configure the task's required IPv6 method (`auto` or `manual`).
2. For manual configuration, set the provided address/prefix, gateway, and DNS.
3. Activate the profile and inspect `ip -6 address` and `ip -6 route`.
4. Test name resolution and connectivity to the supplied IPv6 destination.

**Verify:** Do not disable IPv6 or assume IPv4 DNS settings configure IPv6.

## Lab 5: Hostname Resolution
1. Set the required static hostname with `hostnamectl`.
2. If instructed, add the provided mapping to `/etc/hosts` without overwriting unrelated entries.
3. Configure DNS on the NetworkManager profile when required.
4. Verify with `hostnamectl`, `getent hosts NAME`, and resolver inspection.

**Verify:** The result follows the intended source (hosts or DNS) and persists.

## Lab 6: Service and Connection Startup
1. Confirm NetworkManager is enabled and active; enable/start it only if required.
2. Set the specified connection profile to autoconnect.
3. Enable/start the requested network service by its systemd unit.
4. Verify `systemctl is-enabled`, `systemctl is-active`, and profile autoconnect setting.

**Verify:** The service and profile are configured to return after reboot.

## Lab 7: Permanent Firewall Rule
1. Inspect the active zone and current service/port rules.
2. Add only the task-requested service or protocol/port to the correct zone with `--permanent`.
3. Reload firewalld and check runtime and permanent listings.
4. Remove the rule, reload, and verify the removal.

**Verify:** Permanent and runtime state agree after reload; unrelated services remain unchanged.

## Lab 8: Integrated Persistence Check
Configure one IPv4/IPv6 property, a resolver mapping, a network service's startup state, and a required firewall service. Record the relevant profile, `getent`, systemd, and firewall outputs. Reboot only if authorized, then verify all settings again.
