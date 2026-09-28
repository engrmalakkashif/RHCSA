# RHCSA Module 8: Manage Basic Networking
## Study Index

## Overview
Practice persistent network configuration with NetworkManager, IPv4/IPv6, hostname resolution, network service startup, and firewalld access restrictions.

**Recommended study time:** 10-14 hours

## Materials
- [Detailed Lab Notes](../08_Manage_Basic_Networking_Lab_Notes.md)
- [Lab Exercises](Lab_Exercises.md)
- [Quick Reference](Quick_Reference.txt)
- [Module Summary](MODULE_8_SUMMARY.md)

## Topic Map
1. Interface and profile inspection
2. Static and DHCP IPv4 configuration
3. IPv6 automatic and static configuration
4. Hostname and resolver behavior
5. NetworkManager/service startup
6. firewalld zones, services, and ports
7. Persistence checks

## Learning Paths
- **Beginner (3 days):** Inspect interfaces, configure IPv4, then IPv6 and resolver behavior; finish with firewall labs.
- **Intermediate (1–2 days):** Complete Labs 2, 3, 4, and 6.
- **Exam review (2–3 hours):** Configure one supplied profile, one resolver entry, and one permanent firewall allowance; verify both saved and live state.

## Mastery Checklist
- [ ] Identify the correct device and connection profile.
- [ ] Configure static and automatic IPv4/IPv6 as requested.
- [ ] Set DNS and hostname resolution and verify with `getent`.
- [ ] Configure network services and connections to start automatically.
- [ ] Permit or remove only required firewall services/ports.
- [ ] Confirm changes persist after reload/reboot.
