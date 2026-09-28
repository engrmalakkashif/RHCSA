# RHCSA Module 9: Manage Users and Groups
## Module Summary

**Status:** Study material created
**Estimated study time:** 8-12 hours

## Objective Coverage
- Create, modify, and delete local user accounts.
- Change passwords and password-aging/account-expiration settings.
- Create, modify, and delete local groups and group memberships.
- Configure privileged access with sudo and validate sudoers syntax.
- Verify account state and ensure changes persist.

## Files
- `../09_Manage_Users_Groups_Lab_Notes.md`: Concepts and commands.
- `INDEX.md`: Navigation and learning paths.
- `Lab_Exercises.md`: Seven practical labs.
- `Quick_Reference.txt`: Account, group, aging, and sudo commands.

## Safety
`userdel -r` deletes home data. Keep a valid admin session while changing sudo policy. Use `usermod -aG` when appending group memberships.
