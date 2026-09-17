# Module 2: Operate Running Systems
## Study Material Index

---

## 📚 Overview

This module covers system operation including:
- Boot/reboot/shutdown procedures
- System targets and runlevels
- Boot interruption and recovery
- Process management and priorities
- Service management
- System logging
- Secure file transfer

**Estimated Study Time:** 25-35 hours

---

## 📖 Study Materials

### 1. Detailed Lab Notes
**File:** `02_Operate_Running_Systems_Lab_Notes.md`

#### Topics Covered:
- ✅ Boot, Reboot, and Shutdown Systems
- ✅ Boot Systems into Different Targets Manually
- ✅ Interrupt Boot Process for System Access
- ✅ Identify and Kill CPU/Memory Intensive Processes
- ✅ Adjust Process Scheduling
- ✅ Manage Tuning Profiles
- ✅ Locate and Interpret System Logs
- ✅ Preserve System Journals
- ✅ Manage Network Services
- ✅ Securely Transfer Files Between Systems

#### Structure:
- 10 major sections with comprehensive explanations
- 100+ code examples
- Real-world scenarios
- Common issues and solutions
- Practical use cases

#### How to Use:
1. Read each section completely
2. Take your own notes
3. Study code examples
4. Understand concepts (not memorize)

---

### 2. Quick Reference Card
**File:** `Quick_Reference.txt`

#### Contents:
- Command summaries organized by topic
- Quick lookup for common tasks
- Process management commands
- Service management shortcuts
- Log filtering examples
- File transfer snippets
- Common scenarios
- Exam tips

#### How to Use:
1. Keep open in terminal while practicing
2. Print for offline reference
3. Use for quick command lookup
4. Review before bed

---

### 3. Lab Exercises
**File:** `Lab_Exercises.md`

#### 9 Complete Labs:
1. **Boot, Reboot, Shutdown** - Practice graceful operations
2. **Boot Targets** - Switch between targets
3. **Boot Interruption** - Reset root password
4. **Process Management** - Monitor and kill processes
5. **Process Priorities** - Adjust nice values
6. **Tuning Profiles** - Switch performance profiles
7. **System Logs** - Query journal entries
8. **Persistent Journals** - Enable storage
9. **Service Management** - Control services
10. **Secure Transfer** - SCP and RSYNC
11. **Integration Lab** - Combine all topics

#### Each Lab Includes:
- Clear objectives
- Step-by-step exercises
- Expected outputs
- Verification steps
- Practical scenarios

#### How to Use:
1. Complete each exercise sequentially
2. Don't look at answers first
3. Verify your work
4. Repeat until confident
5. Combine labs for integration

---

## 🎯 Learning Path

### Week 1: Foundation
```
Day 1-2:  Boot, Reboot, Shutdown
          Target and Runlevels
          
Day 3-4:  Process Management
          Monitor processes
          
Day 5:    Service Management
          Start/stop/enable services
```

### Week 2: Advanced Topics
```
Day 6-7:  Process Priorities
          Process Scheduling
          
Day 8-9:  System Logs
          Journal queries
          
Day 10:   Secure Transfer
          SCP, RSYNC, SFTP
```

### Week 3: Integration & Practice
```
Day 11-12: Tuning Profiles
           Review weak areas
           
Day 13-14: Complete integration labs
           Practice exams
           
Day 15:    Final review
           Confidence check
```

---

## 🗂️ File Organization

```
Module_02_Operating_Systems/
├── INDEX.md                                  (This file)
├── 02_Operate_Running_Systems_Lab_Notes.md  (Main content)
├── Quick_Reference.txt                      (Cheat sheet)
├── Lab_Exercises.md                         (Hands-on practice)
└── Solutions/                               (Answer keys)
    └── (To be added)
```

---

## 💡 Key Concepts to Master

### Tier 1: Essential (Must Know)
- [ ] systemctl commands
- [ ] shutdown vs reboot vs poweroff
- [ ] journalctl basic queries
- [ ] ps and top usage
- [ ] scp file transfer

### Tier 2: Important (Should Know)
- [ ] Target switching and defaults
- [ ] Process priorities (nice/renice)
- [ ] Service enable/disable
- [ ] Boot parameter interruption
- [ ] RSYNC synchronization

### Tier 3: Advanced (Nice to Know)
- [ ] SELinux context in boot recovery
- [ ] tuned profile customization
- [ ] Journal encryption
- [ ] CPU affinity with taskset
- [ ] I/O scheduling with ionice

---

## 🔍 Important Commands

### Top 20 Commands for This Module

```bash
1.  systemctl start/stop service
2.  systemctl enable/disable service
3.  ps aux
4.  top / htop
5.  kill / pkill
6.  nice / renice
7.  shutdown / reboot / poweroff
8.  systemctl get-default
9.  systemctl isolate target
10. journalctl
11. journalctl -u service
12. journalctl -p priority
13. scp file user@host
14. rsync -av source dest
15. tuned-adm list
16. tuned-adm profile
17. systemctl list-dependencies
18. systemctl status service
19. dmesg
20. taskset -c CPU PID
```

---

## 📊 Topics by Difficulty

### Easy (1-2 hours each)
- Shutdown and reboot operations
- Basic systemctl commands
- Simple ps/top usage
- Basic scp transfer

### Medium (3-5 hours each)
- Service management (enable/disable)
- Process monitoring
- Target switching
- Journal queries
- File synchronization

### Hard (5-10 hours each)
- Boot interruption procedures
- Process priority tuning
- Performance profile management
- Journal persistence setup
- SELinux context in recovery

---

## ✅ Pre-Exam Checklist

- [ ] All 10 labs completed 2+ times
- [ ] Quick reference card memorized
- [ ] Can execute each command from memory
- [ ] Understand the purpose of each command
- [ ] Practiced in test environment
- [ ] Comfortable with GRUB editing
- [ ] Understand systemd targets
- [ ] Can troubleshoot boot issues
- [ ] Know service dependencies
- [ ] File transfer working smoothly

---

## 🎓 Study Tips

### Active Learning
1. **Read** - Understand concepts
2. **Type** - Execute every command
3. **Experiment** - Modify and test
4. **Explain** - Teach what you learned
5. **Review** - Reinforce knowledge

### Practice Effectively
- Don't skip exercises
- Don't copy-paste commands
- Don't memorize without understanding
- Do test your knowledge regularly
- Do combine topics in new scenarios

### Time Management
- Spend 60% time practicing
- Spend 20% time learning theory
- Spend 20% time reviewing

---

## 🔗 Cross-References

### Related Modules
- **Module 1** - Essential tools used throughout
- **Module 3** - Storage management basics needed
- **Module 5** - Network services introduced here
- **Module 6** - User-related process management
- **Module 7** - Security relevant to boot process
- **Module 10** - Service management continued

### Prerequisite Knowledge
- Basic Linux command line
- File permissions and ownership
- Text file editing (vim/nano)
- Understanding of processes

---

## 📝 Practice Scenarios

### Scenario 1: Emergency Recovery
- System won't boot normally
- Need to reset root password
- **Topics:** rd.break, chroot, dracut

### Scenario 2: System Tuning
- Web server performance too low
- Need to optimize for throughput
- **Topics:** tuning profiles, process priorities

### Scenario 3: Service Troubleshooting
- SSH service not starting
- Need to diagnose
- **Topics:** journalctl, systemctl, logs

### Scenario 4: Secure Backup
- Need to backup critical files to server
- Preserve permissions
- **Topics:** scp, rsync, permissions

### Scenario 5: System Maintenance
- Schedule shutdown with warning
- Monitor running processes
- Enable services for boot
- **Topics:** shutdown, ps, systemctl enable

---

## 📞 Getting Help

### If You Get Stuck

**For command help:**
```bash
command --help
man command
info command
whatis command
```

**For service issues:**
```bash
systemctl status service
journalctl -u service
systemctl list-dependencies service
```

**For process issues:**
```bash
ps aux | grep process
top -b -n 1 -p PID
lsof -p PID
```

---

## 🚀 Success Metrics

### After Completing This Module, You Should:
- ✅ Confidently boot/reboot systems
- ✅ Switch between different targets
- ✅ Recover from boot failures
- ✅ Monitor and manage processes
- ✅ Understand process scheduling
- ✅ Manage system services
- ✅ Query and analyze logs
- ✅ Transfer files securely
- ✅ Understand system performance tuning
- ✅ Handle system emergencies

---

## 📅 Typical Study Schedule

```
Week 1 (Days 1-5):
- Read Lab Notes sections 1-3
- Complete Labs 1-3
- Review Quick Reference
- Practice commands daily

Week 2 (Days 6-10):
- Read Lab Notes sections 4-7
- Complete Labs 4-7
- Combine scenarios
- Timed practice exercises

Week 3 (Days 11-15):
- Read Lab Notes sections 8-10
- Complete Labs 8-10
- Full integration lab
- Self-assessment exam

Total Time: 25-35 hours
```

---

## 🎯 Exam Readiness

### Skills You Must Have
- Boot/reboot/shutdown systems ✓
- Switch targets without rebooting ✓
- Reset root password via boot interrupt ✓
- Identify resource-heavy processes ✓
- Adjust process priorities ✓
- Start/stop/enable services ✓
- Query system logs efficiently ✓
- Transfer files securely ✓

### Common Exam Tasks
1. Boot system to specific target
2. Reset forgotten root password
3. Find and terminate runaway process
4. Enable service on boot
5. Query logs for specific events
6. Backup files to remote server
7. Check and interpret system status
8. Troubleshoot service failures

---

## 📚 Additional Resources

### Official Documentation
- Red Hat System Administration I (RH124)
- Red Hat System Administration II (RH134)
- systemd documentation

### Online References
- man pages (on exam system!)
- `/usr/share/doc/` system documentation
- Red Hat Knowledge Base

### Practice Tools
- Actual RHEL system or VM
- systemctl commands
- journalctl queries
- Virtual machine labs

---

## ✨ Key Takeaways

1. **systemctl is fundamental** - Master every option
2. **Logs are your friend** - Learn journalctl well
3. **Understand targets** - Not just memorize them
4. **Process management** - Essential for troubleshooting
5. **Service dependencies** - Know what affects what
6. **Boot recovery** - Practice until comfortable
7. **Security first** - Understand firewall and permissions
8. **Practical skills** - Speed matters in exam

---

## 🏆 You're Ready When

- Can execute every command without notes
- Understand why each command is used
- Can troubleshoot common issues
- Can combine commands in new ways
- Comfortable in exam environment
- Consistent scores 75%+ on practice exams
- Can complete tasks in under 3 minutes each

---

**Version:** 1.0  
**Last Updated:** September 2026  
**Status:** ✅ Complete - Ready for Study

---

**Next Steps:** 
1. Review this index
2. Start with Lab Exercises 1
3. Follow the learning path
4. Complete all exercises
5. Move to Module 3 when done

**Good luck with Module 2!** 🚀

---

*This index is part of the comprehensive RHCSA exam preparation guide.*
