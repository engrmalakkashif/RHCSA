# RHCSA Module 10: Manage Security
## Study Index

## Overview
Configure default permissions, SSH public-key authentication, and SELinux state and policy labels. Maintain least privilege and verify changes survive reboot.

**Recommended study time:** 12-16 hours

## Materials
- [Detailed Lab Notes](../10_Manage_Security_Lab_Notes.md)
- [Lab Exercises](Lab_Exercises.md)
- [Quick Reference](Quick_Reference.txt)
- [Module Summary](MODULE_10_SUMMARY.md)

## Topic Map
1. umask and default permission bits
2. SSH key pairs and authorized_keys
3. SELinux modes and persistent configuration
4. File/process context inspection and restorecon
5. Persistent file-context rules
6. SELinux port labels
7. SELinux booleans
8. firewalld review and least-privilege rules ([full procedure in Module 8](../../Module-08-Manage-Basic-Networking/Module_08_Manage_Basic_Networking/INDEX.md))

## Learning Paths
- **Beginner (3–4 days):** Study umask and SSH, then SELinux mode, labels, ports, and booleans; complete all labs.
- **Intermediate (2 days):** Complete Labs 1, 2, and 4–7.
- **Exam review (3 hours):** Restore a file label, configure a persistent fcontext/boolean/port label from task data, and verify enforcing mode.

## Mastery Checklist
- [ ] Explain how umask affects newly created objects.
- [ ] Configure SSH key login without exposing the private key.
- [ ] Set and verify runtime and persistent SELinux modes.
- [ ] Inspect file and process contexts and restore defaults.
- [ ] Create persistent file-context and port-label rules.
- [ ] Set a boolean temporarily and persistently as requested.
- [ ] Inspect and verify required firewalld access without opening unrelated services.
- [ ] Verify security state after a new session and reboot.
