# Module 2: Deliverables and Coverage

**Topic:** Operate Running Systems

## Materials Present
- `02_Operate_Running_Systems_Lab_Notes.md`
- `Module_02_Operating_Systems/INDEX.md`
- `Module_02_Operating_Systems/Lab_Exercises.md`
- `Module_02_Operating_Systems/Quick_Reference.txt`
- `MODULE_2_SUMMARY.md`

The lab file contains nine numbered sections. The index now uses that same count.

## Objective Map
| Objective area | Study location |
|---|---|
| Boot, reboot, shutdown, and targets | Lab notes Sections 1–2; Labs 1–2 |
| Interrupt boot and regain access | Lab notes Section 3; Lab 3 |
| Processes, priorities, tuning | Lab notes Sections 4–6; Labs 4–5 |
| Logs and persistent journal | Lab notes Sections 7–8; Labs 6–7 |
| Services and file transfer | Lab notes Sections 9–10; Labs 8–9 |

## Lab Safety
Practice boot recovery only on a disposable VM with console access. Keep SELinux enabled and create `/.autorelabel` after changing the root password in the recovery chroot. Use NetworkManager on RHEL 8/9; the legacy `network` service is not the standard network-management unit. The lab procedures are educational and should be rehearsed before exam use.
