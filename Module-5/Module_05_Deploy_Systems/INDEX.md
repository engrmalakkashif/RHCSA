# RHCSA Module 5: Deploy, Configure, and Maintain Systems
## Complete Navigation & Study Guide

---

## Quick Navigation

### By Learning Path
- **[Beginner Path](#beginner-learning-path)** - Start here if new to system deployment
- **[Intermediate Path](#intermediate-learning-path)** - For experienced Linux users
- **[Advanced Path](#advanced-learning-path)** - Exam-focused speed learning

### By File Type
- **[Lab Notes](../05_Deploy_Configure_Maintain_Lab_Notes.md)** - Detailed explanations
- **[Quick Reference](Quick_Reference.txt)** - Command cheat sheet
- **[Lab Exercises](Lab_Exercises.md)** - Hands-on practice

### By Topic
1. [System Time and Date Configuration](#topic-1-system-time-and-date-configuration)
2. [Hostname and Network Configuration](#topic-2-hostname-and-network-configuration)
3. [Task Scheduling (at/cron/timers)](#topic-3-task-scheduling-at-cron-systemd-timers)
4. [Service Management](#topic-4-service-management)
5. [Boot Targets and System Runlevels](#topic-5-boot-targets-and-system-runlevels)
6. [Software Package Management](#topic-6-software-package-management)
7. [Repository Configuration](#topic-7-repository-configuration)
8. [Bootloader Configuration (GRUB)](#topic-8-bootloader-configuration-grub)
9. [System Maintenance and Updates](#topic-9-system-maintenance-and-updates)

---

## Study Schedules

### Beginner Learning Path
**Duration:** 14-18 hours over 4-5 days

**Day 1 (4 hours):**
1. Read Lab Notes: Time/Date & Hostname/Network (2 hours)
2. Lab Exercise 1: Time Configuration (1 hour)
3. Lab Exercise 2: Hostname & Network (1 hour)

**Day 2 (3.5 hours):**
1. Read Lab Notes: Task Scheduling (1.5 hours)
2. Lab Exercise 3: Cron and at (2 hours)

**Day 3 (3.5 hours):**
1. Read Lab Notes: Service Management (1 hour)
2. Lab Exercise 4: Service Management (2 hours)
3. Lab Exercise 5: Boot Targets (0.5 hours)

**Day 4 (3 hours):**
1. Read Lab Notes: Packages & Repositories (1.5 hours)
2. Lab Exercise 6: Package Management (1.5 hours)

**Day 5 (4 hours):**
1. Read Lab Notes: GRUB & Maintenance (1.5 hours)
2. Lab Exercise 7: Repository Configuration (1 hour)
3. Lab Exercise 8: GRUB Configuration (1.5 hours)

### Intermediate Learning Path
**Duration:** 7-9 hours over 2-3 days

**Day 1 (4 hours):**
1. Skim Lab Notes (30 min)
2. Lab Exercises 1-3 (3 hours)
3. Lab Exercise 4 (30 min)

**Day 2 (4 hours):**
1. Lab Exercises 5-7 (3 hours)
2. Lab Exercise 8 (1 hour)

### Advanced Learning Path (Exam Focused)
**Duration:** 3-4 hours

**Hour 1:**
1. Quick Reference scan (15 min)
2. Topic deep-dives: Tasks, Services, GRUB (45 min)

**Hour 2-3:**
1. Lab Exercises 3-5 (1.5 hours)
2. Lab Exercise 8 (1 hour)
3. Practice weak areas (30 min)

---

## Topic Deep Dives

### Topic 1: System Time and Date Configuration

**Key Concepts:**
- NTP synchronization importance
- Timezone management
- chrony vs ntpd
- Time verification

**Essential Commands:**
```bash
timedatectl set-timezone TIMEZONE
sudo timedatectl set-ntp true
sudo chronyc tracking
chronyc sources
date
```

**Exam Objectives:**
- Configure system time ✓
- Set timezone correctly ✓
- Verify NTP sync ✓

**Practice:**
- [Lab Exercise 1](Lab_Exercises.md#lab-exercise-1-configure-system-time-and-timezone)
- [Lab Notes Section 1](../05_Deploy_Configure_Maintain_Lab_Notes.md#1-system-time-and-date-configuration)

---

### Topic 2: Hostname and Network Configuration

**Key Concepts:**
- Hostname vs FQDN
- hostnamectl usage
- NetworkManager (nmcli)
- Static vs DHCP IP
- DNS configuration

**Essential Commands:**
```bash
sudo hostnamectl set-hostname NAME
sudo nmcli connection modify NAME ipv4.method manual
sudo nmcli connection modify NAME ipv4.addresses "IP/PREFIX"
nmcli connection show
nmcli device show
```

**Exam Objectives:**
- Set hostname ✓
- Configure static IP ✓
- Configure DHCP ✓
- Set DNS ✓

**Practice:**
- [Lab Exercise 2](Lab_Exercises.md#lab-exercise-2-configure-hostname-and-network)
- [Lab Notes Section 2](../05_Deploy_Configure_Maintain_Lab_Notes.md#2-hostname-and-network-configuration)

---

### Topic 3: Task Scheduling (at/cron/systemd timers)

**Key Concepts:**
- at command for one-time tasks
- cron format and expressions
- crontab management
- systemd timers (modern approach)
- Special cron strings (@reboot, @daily, etc.)

**Essential Commands:**
```bash
at TIME
crontab -e
crontab -l
systemctl list-timers
sudo systemctl start TIMER.timer
```

**Exam Objectives:**
- Schedule one-time tasks (at) ✓
- Schedule recurring tasks (cron) ✓
- Create systemd timers ✓
- Manage scheduled tasks ✓

**Practice:**
- [Lab Exercise 3](Lab_Exercises.md#lab-exercise-3-schedule-tasks-with-crontab-and-at)
- [Lab Notes Section 3](../05_Deploy_Configure_Maintain_Lab_Notes.md#3-task-scheduling-with-at-cron-and-systemd-timers)

---

### Topic 4: Service Management

**Key Concepts:**
- systemd and systemctl
- Service unit files
- Enable/disable services
- Service logs with journalctl
- Service dependencies

**Essential Commands:**
```bash
sudo systemctl start SERVICE
sudo systemctl enable SERVICE
sudo systemctl status SERVICE
sudo journalctl -u SERVICE
systemctl show SERVICE
```

**Exam Objectives:**
- Start/stop services ✓
- Enable/disable services ✓
- Check service status ✓
- View service logs ✓
- Manage service dependencies ✓

**Practice:**
- [Lab Exercise 4](Lab_Exercises.md#lab-exercise-4-manage-services-and-enable-on-boot)
- [Lab Notes Section 4](../05_Deploy_Configure_Maintain_Lab_Notes.md#4-service-management-and-systemctl)

---

### Topic 5: Boot Targets and System Runlevels

**Key Concepts:**
- Targets vs runlevels
- Common targets (graphical, multi-user, rescue)
- Default target configuration
- Switching targets
- GRUB boot parameters

**Essential Commands:**
```bash
sudo systemctl get-default
sudo systemctl set-default TARGET
sudo systemctl isolate TARGET
systemctl list-units --type=target
```

**Exam Objectives:**
- Set default boot target ✓
- Switch targets ✓
- Boot to rescue/emergency ✓
- Understand target dependencies ✓

**Practice:**
- [Lab Exercise 5](Lab_Exercises.md#lab-exercise-5-configure-boot-target)
- [Lab Notes Section 5](../05_Deploy_Configure_Maintain_Lab_Notes.md#5-boot-targets-and-system-runlevels)

---

### Topic 6: Software Package Management

**Key Concepts:**
- yum/dnf commands
- Package search and info
- Package groups
- Local package installation
- Package dependencies
- Package history

**Essential Commands:**
```bash
sudo yum install PACKAGE
sudo yum remove PACKAGE
yum search KEYWORD
yum info PACKAGE
sudo yum update
yum list installed
```

**Exam Objectives:**
- Install packages ✓
- Remove packages ✓
- Update packages ✓
- Search packages ✓
- Work with package groups ✓

**Practice:**
- [Lab Exercise 6](Lab_Exercises.md#lab-exercise-6-install-and-update-packages)
- [Lab Notes Section 6](../05_Deploy_Configure_Maintain_Lab_Notes.md#6-software-package-management)

---

### Topic 7: Repository Configuration

**Key Concepts:**
- Repository configuration files
- yum-config-manager usage
- Enabling/disabling repositories
- Subscription management
- Repository structure

**Essential Commands:**
```bash
yum repolist
sudo yum-config-manager --enable REPO
sudo yum-config-manager --disable REPO
sudo subscription-manager register
yum-config-manager --dump
```

**Exam Objectives:**
- Enable/disable repositories ✓
- Manage subscriptions ✓
- View repository configuration ✓
- Add repositories ✓

**Practice:**
- [Lab Exercise 7](Lab_Exercises.md#lab-exercise-7-configure-repository-and-subscription)
- [Lab Notes Section 7](../05_Deploy_Configure_Maintain_Lab_Notes.md#7-repository-configuration)

---

### Topic 8: Bootloader Configuration (GRUB)

**Key Concepts:**
- GRUB2 configuration
- Kernel parameters
- grubby tool
- Regenerating GRUB config
- BIOS vs UEFI

**Essential Commands:**
```bash
sudo vi /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo grubby --info=ALL
sudo grubby --update-kernel=ALL --args="PARAM=VALUE"
sudo systemctl get-default
```

**Exam Objectives:**
- Modify GRUB parameters ✓
- Add kernel parameters ✓
- Regenerate GRUB config ✓
- Use grubby ✓
- Boot specific targets ✓

**Practice:**
- [Lab Exercise 8](Lab_Exercises.md#lab-exercise-8-grub-configuration-and-boot-parameters-integration-lab)
- [Lab Notes Section 8](../05_Deploy_Configure_Maintain_Lab_Notes.md#8-bootloader-configuration-and-grub)

---

### Topic 9: System Maintenance and Updates

**Key Concepts:**
- System health monitoring
- Update management
- Kernel updates
- Security updates
- Automatic updates with yum-cron
- System cleanup

**Essential Commands:**
```bash
df -h
free -h
yum check-update
sudo yum update
sudo yum update --security
uname -r
sudo journalctl -p err
```

**Exam Objectives:**
- Monitor system health ✓
- Update system ✓
- Install security updates ✓
- Manage kernel updates ✓
- Automatic updates ✓

**Practice:**
- [Lab Notes Section 9](../05_Deploy_Configure_Maintain_Lab_Notes.md#9-system-maintenance-and-updates)

---

## Key Concepts Tier List

### Tier 1 (Must Know - Exam Critical)
1. Set system time and timezone (timedatectl)
2. Configure static IP with nmcli
3. Create cron jobs (crontab -e)
4. Enable/disable services (systemctl)
5. Set default boot target (systemctl set-default)
6. Install/remove packages (yum install/remove)
7. Regenerate GRUB config
8. Check for updates (yum check-update)
9. View service logs (journalctl -u)
10. Configure DNS

### Tier 2 (Important - Exam Likely)
1. Schedule one-time tasks (at)
2. Verify NTP synchronization
3. Set hostname (hostnamectl)
4. Reload service config (systemctl reload)
5. Switch boot targets (systemctl isolate)
6. Search packages (yum search)
7. Enable/disable repositories
8. Add kernel parameters (grubby)
9. Update kernel
10. Monitor disk/memory

### Tier 3 (Good to Know - Exam Possible)
1. systemd timer units (advanced)
2. Service unit files
3. crontab access control
4. Subscription management
5. BIOS vs UEFI GRUB
6. Yum-cron setup
7. Package groups
8. GRUB menu options
9. System journal management
10. NTP daemon configuration

---

## Pre-Exam Checklist

### Knowledge Verification
- [ ] Understand time synchronization methods
- [ ] Know hostnamectl and nmcli usage
- [ ] Know cron format and at command
- [ ] Know systemctl service management
- [ ] Know boot targets vs runlevels
- [ ] Know yum package commands
- [ ] Know repository management
- [ ] Know GRUB configuration
- [ ] Know system maintenance tasks
- [ ] Know kernel parameter management

### Hands-On Skills
- [ ] Set system time and timezone
- [ ] Configure static IP address
- [ ] Create cron jobs
- [ ] Enable/disable services
- [ ] Set and switch boot targets
- [ ] Install/update packages
- [ ] Enable/disable repositories
- [ ] Modify GRUB configuration
- [ ] Update kernel
- [ ] Check system health

---

## Time Allocation Guide

### Total Study Time: 14-18 hours

**By Activity:**
- Reading Lab Notes: 4-5 hours
- Hands-on Exercises: 8-10 hours
- Quick Reference: 1-2 hours
- Review: 1-2 hours

**By Topic:**
- Time/Date: 1-2 hours
- Hostname/Network: 1.5-2 hours
- Task Scheduling: 2-2.5 hours
- Service Management: 1.5-2 hours
- Boot Targets: 1-1.5 hours
- Package Management: 1.5-2 hours
- Repository/Subscription: 1-1.5 hours
- GRUB Configuration: 1.5-2 hours
- System Maintenance: 1-1.5 hours

---

## Success Metrics

**After completing this module, you should:**

✓ Configure system time and timezone confidently
✓ Set hostname and static IP addresses
✓ Create recurring and one-time scheduled tasks
✓ Enable/disable services on boot
✓ Set and switch boot targets
✓ Install, update, and remove packages
✓ Manage repositories and subscriptions
✓ Configure GRUB bootloader
✓ Monitor and maintain system health
✓ Pass all lab exercises

---

**Next Steps After This Module:**
1. Review Quick Reference daily for 1 week
2. Repeat Lab Exercise 8 multiple times
3. Test on different systems
4. Move to Module 6: Manage Users and Groups
5. Reference this module as needed in later modules

---

*End of INDEX - Module 5: Deploy, Configure, and Maintain Systems*
