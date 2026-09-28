# RHCSA Module 10: Manage Security
## Module Summary

**Status:** Study material created
**Estimated study time:** 12-16 hours

## Objective Coverage
- Configure and verify default file permissions with umask.
- Configure SSH public-key authentication with appropriate ownership/modes.
- Set runtime and persistent SELinux enforcing/permissive modes.
- Inspect file and process contexts and restore default labels.
- Create persistent file-context mappings and SELinux port labels.
- Change SELinux booleans at runtime and persistently.
- Review required firewalld access using least-privilege rules (full workflow in Module 7).
- Verify access-control changes after new sessions and reboot.

## Files
- `../10_Manage_Security_Lab_Notes.md`: Concepts and workflows.
- `INDEX.md`: Navigation and study paths.
- `Lab_Exercises.md`: Eight hands-on labs.
- `Quick_Reference.txt`: Commands and verification.

## Safety
Keep SELinux enforcing unless explicitly directed otherwise. Never expose a private SSH key. Retain working access while testing SSH or sudo changes. Module 8 covers firewalld configuration.
