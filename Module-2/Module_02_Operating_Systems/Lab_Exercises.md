# Module 2: Operate Running Systems - Lab Exercises

## Complete Hands-On Practice

---

## Lab 1: Boot, Reboot, and Shutdown Systems

### Objectives
- Practice graceful shutdown
- Schedule shutdown with messages
- Perform reboots
- Understand shutdown implications

### Exercises

#### Exercise 1.1: Schedule and Cancel Shutdown

```bash
# 1. Schedule shutdown in 10 minutes
sudo shutdown -h +10 "System maintenance - please save your work"

# 2. Check scheduled shutdown status
shutdown --show

# 3. View system state
who                                 # Users logged in
ps aux | wc -l                      # Number of processes

# 4. Cancel shutdown (before it happens)
sudo shutdown -c

# 5. Verify cancellation
shutdown --show
# Should show: 'No shutdown scheduled'
```

#### Exercise 1.2: Graceful Reboot

```bash
# 1. Check system uptime
uptime
# Shows: time, how long running, users, load average

# 2. Schedule reboot in 5 minutes
sudo shutdown -r +5 "Rebooting for kernel update"

# 3. Verify reboot scheduled
shutdown --show

# 4. Wait for reboot or cancel
sudo shutdown -c
```

#### Exercise 1.3: Immediate Shutdown (Lab Only)

```bash
# WARNING: Only in test environment!
# This immediately powers off system

# View shutdown methods
which shutdown
which poweroff
which reboot
which halt

# Do NOT run these:
# sudo shutdown -h now        # Would power off
# sudo systemctl poweroff     # Would power off
# sudo poweroff -f            # Emergency poweroff

# Instead, practice the commands (don't execute):
echo "These would power off the system:"
echo "  sudo shutdown -h now"
echo "  sudo systemctl poweroff"
```

#### Exercise 1.4: Understand Boot Information

```bash
# Check when system was last booted
who -b
# Output: system boot  2024-01-15 08:30

# Show system uptime
uptime
# Output: 14:35:22 up 6 days, 6:04, 1 user, load average: 0.15, 0.10, 0.08

# View boot messages
dmesg | head -20
# Kernel messages from boot

# Check journal for boot entries
journalctl -b | head -20
# Current boot journal entries

# List all boot records
journalctl --list-boots
```

### Verification

```bash
# Verify no unexpected shutdowns scheduled
shutdown --show
# Should show: 'No shutdown scheduled'

# System should be running normally
systemctl is-system-running
# Should show: 'running'
```

---

## Lab 2: Boot Systems into Different Targets

### Objectives
- Switch between targets without reboot
- Set default boot target
- Understand target dependencies

### Exercises

#### Exercise 2.1: View and Switch Targets

```bash
# 1. Check current target
systemctl get-default
# Output: graphical.target (or multi-user.target)

# 2. Check active target
systemctl status graphical.target

# 3. List all available targets
systemctl list-units --type=target
# Shows all available targets

# 4. List target details
systemctl list-units --type=target --all

# 5. Show target dependencies
systemctl list-dependencies graphical.target
# What services does graphical.target need?
```

#### Exercise 2.2: Switch to Multi-User Target (CLI)

```bash
# WARNING: This kills graphical interface!
# Only run in test environment with console access

# 1. Current status
systemctl get-default
# Should show: graphical.target

# 2. Switch to multi-user (CLI only)
sudo systemctl isolate multi-user.target
# GUI stops immediately
# System drops to login prompt

# 3. Verify target changed
systemctl get-default
# Still shows: graphical.target (not default, just current)

# 4. Check default target
cat /etc/systemd/system/default.target
# Shows: graphical.target (still the default)

# 5. Verify running target
systemctl list-units --type=target --state=active
# Shows: multi-user.target

# 6. Switch back to graphical
sudo systemctl isolate graphical.target
# GUI returns
```

#### Exercise 2.3: Set Default Target (Permanent)

```bash
# 1. Check current default
systemctl get-default
# Output: graphical.target

# 2. Change default to multi-user
sudo systemctl set-default multi-user.target
# Changes /etc/systemd/system/default.target

# 3. Verify change
systemctl get-default
# Should now show: multi-user.target

# 4. Reboot to apply (DON'T DO THIS unless safe!)
# On next boot, system will go to multi-user.target

# 5. Change back to graphical
sudo systemctl set-default graphical.target

# 6. Verify
systemctl get-default
# Should show: graphical.target again
```

#### Exercise 2.4: View Target Dependencies

```bash
# See what graphical.target depends on
systemctl list-dependencies graphical.target

# Show detailed dependencies
systemctl list-dependencies graphical.target --all

# Show reverse dependencies (what needs graphical.target)
systemctl list-dependencies --reverse graphical.target

# Compare with multi-user.target dependencies
systemctl list-dependencies multi-user.target
```

### Verification

```bash
# Confirm default target
systemctl get-default

# Check active target
systemctl list-units --type=target --state=active

# Show systemd default link
ls -la /etc/systemd/system/default.target
```

---

## Lab 3: Boot Process Interruption (Password Reset)

### IMPORTANT: Destructive Exercise

This exercise resets the root password. Only perform in lab/test environment.

### Prerequisites
- Console access to system
- Test VM (not production)

### Exercise 3.1: Boot with rd.break Parameter

```bash
# 1. Reboot system
sudo reboot

# 2. At GRUB menu (appears during boot):
#    - If not visible: hold Shift during early boot
#    - Press 'e' to edit

# 3. Find the line starting with 'linux'
#    Example:
#    linux /vmlinuz-5.10.0-8-generic root=/dev/mapper/cl-root ro quiet

# 4. Add 'rd.break' before 'ro'
#    Change to:
#    linux /vmlinuz-5.10.0-8-generic root=/dev/mapper/cl-root ro rd.break

# 5. Press Ctrl+X to boot

# 6. System boots into dracut emergency shell
#    Prompt: dracut>

# 7. Mount root filesystem as writable
dracut> mount -o remount,rw /sysroot

# 8. Change to actual root
dracut> chroot /sysroot

# 9. Now in chroot, reset password
# whoami                         # Shows: root
passwd root
# Enter new password (twice)

# 10. Exit chroot
exit

# 11. Exit dracut
exit

# 12. System continues boot
#     May take extra time as SELinux relabels
```

### Exercise 3.2: Alternative - rd.recovery Method

```bash
# For some systems, an alternative approach:

# 1. At GRUB menu, press 'e'

# 2. Find 'ro' in linux line

# 3. Replace 'ro quiet' with 'rw init=/bin/bash'
#    This mounts root as writable and starts bash

# 4. Press Ctrl+X to boot

# 5. You get shell immediately as root
#    Can now reset password or fix issues

# 6. After fixing, reboot system
reboot
```

### Verification

```bash
# After reboot with new password, verify login works
su - root
# Should accept new password

# Check that system booted normally
uptime
journalctl -b | grep "System boot"
```

---

## Lab 4: Process Management and Priorities

### Objectives
- Identify CPU and memory intensive processes
- Kill processes safely
- Adjust process priorities
- Use CPU affinity

### Exercises

#### Exercise 4.1: Monitor Processes with ps

```bash
# 1. View all processes
ps aux | head -20
# Shows: USER, PID, %CPU, %MEM, VSZ, RSS, STAT, START, TIME, COMMAND

# 2. Sort by CPU usage
ps aux --sort=-%cpu | head -11
# First line is header, then top 10 by CPU

# 3. Sort by memory usage
ps aux --sort=-%mem | head -11
# First line is header, then top 10 by memory

# 4. View process details
ps -fp 1
# Detailed info on PID 1 (systemd)

# 5. Show process tree
ps auxf | head -20
# Parent-child relationships

# 6. Find specific process
ps aux | grep sshd
ps aux | grep httpd
ps aux | grep -v grep | grep sshd
```

#### Exercise 4.2: Monitor with top

```bash
# 1. Start top
top
# Real-time process monitoring

# 2. Interactive commands in top:
P               # Sort by CPU (press P)
M               # Sort by memory (press M)
q               # Quit top
h or ?          # Show help
Space           # Refresh display
d 1             # Change refresh interval to 1 second

# 3. Exit top
q

# 4. Single snapshot in batch mode
top -b -n 1
# Shows one snapshot to stdout

# 5. Show specific processes
top -b -n 1 -p 1 -p 2
# Show PIDs 1 and 2 only

# 6. Sort by memory in batch mode
top -b -n 1 -o %MEM | head -20
```

#### Exercise 4.3: Start Process with Nice Priority

```bash
# 1. Start process with low priority (background task)
nice -n 15 sleep 300 &
# Nice value: +15 (lower priority)

# 2. Check nice value
ps -o pid,user,nice,cmd | grep sleep

# 3. Start with higher priority (needs root)
sudo nice -n -5 sleep 300 &
# Nice value: -5 (higher priority, root only)

# 4. Verify
ps -o pid,user,nice,cmd | grep sleep

# 5. Kill test processes
pkill sleep

# 6. Compare different priorities
time nice -n 19 sha256sum /dev/zero &
# Low priority, may take longer
# Ctrl+C to stop
```

#### Exercise 4.4: Adjust Running Process Priority

```bash
# 1. Start a process
sleep 3600 &
# Note the PID (e.g., 12345)

# 2. Get the PID
MYPID=$!
echo $MYPID

# 3. Check current priority
ps -o pid,nice,cmd | grep sleep | grep $MYPID

# 4. Lower priority (higher nice value)
renice -n 10 -p $MYPID
# Now lower priority

# 5. Verify change
ps -o pid,nice,cmd | grep $MYPID

# 6. Increase priority (needs root, lower nice value)
sudo renice -n 5 -p $MYPID

# 7. Verify
ps -o pid,nice,cmd | grep $MYPID

# 8. Kill test process
kill $MYPID
```

#### Exercise 4.5: CPU Affinity

```bash
# 1. Show available CPUs
nproc
# Number of CPU cores

# 2. Start process on specific CPU
taskset -c 0 sleep 300 &
CPUPID=$!
# Restricted to CPU 0

# 3. Check CPU binding
taskset -cp $CPUPID
# Shows: CPUs: 0

# 4. Change CPU binding
taskset -cp 1 $CPUPID
# Now on CPU 1

# 5. Verify
taskset -cp $CPUPID

# 6. Bind to multiple CPUs
taskset -cp 0,1,2 $CPUPID
# Use CPUs 0, 1, and 2

# 7. Kill test process
kill $CPUPID
```

#### Exercise 4.6: Kill Processes

```bash
# 1. Start a test process
sleep 3600 &
PID=$!
echo $PID

# 2. Check if running
ps -p $PID
kill -0 $PID && echo "Running" || echo "Not running"

# 3. Graceful kill (SIGTERM)
kill -TERM $PID
# Process gets 10 seconds to clean up

# 4. Verify it's dead
ps -p $PID && echo "Still running" || echo "Killed"

# 5. Start another test
sleep 3600 &
PID=$!

# 6. Force kill (SIGKILL)
kill -9 $PID
# Immediate termination

# 7. Verify
ps -p $PID && echo "Still running" || echo "Killed"

# 8. Kill by process name
sleep 3600 &
sleep 3600 &
pgrep sleep                        # Find sleep processes
pkill -f "sleep 3600"              # Kill all matching
```

### Verification

```bash
# Check no test processes left
ps aux | grep sleep
ps aux | grep $MYPID

# System should be responsive
top -b -n 1 -o %CPU | head -3
```

---

## Lab 5: Tuning Profiles

### Objectives
- List available profiles
- Switch profiles
- Understand performance impact

### Exercises

#### Exercise 5.1: Explore Tuning Profiles

```bash
# 1. Check if tuned is running
systemctl status tuned

# 2. List available profiles
tuned-adm list
# Shows all available profiles with descriptions

# 3. Get information on balanced profile
tuned-adm profile_info balanced

# 4. Get information on performance profile
tuned-adm profile_info performance

# 5. Show current active profile
tuned-adm active
# Output: Current active profile: balanced

# 6. Recommended profile for your system
tuned-adm recommend
# Suggests profile based on system
```

#### Exercise 5.2: Switch Profiles

```bash
# 1. Current profile
tuned-adm active

# 2. Switch to performance
sudo tuned-adm profile performance

# 3. Verify change
tuned-adm active
# Should show: performance

# 4. Check CPU governor changed
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# Shows: performance (if CPU frequency scaling available)

# 5. Switch to powersave
sudo tuned-adm profile powersave

# 6. Verify
tuned-adm active

# 7. Switch back to balanced
sudo tuned-adm profile balanced

# 8. Final verification
tuned-adm active
```

#### Exercise 5.3: Monitor Profile Impact

```bash
# 1. With balanced profile
tuned-adm active
echo "Balanced profile:"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq

# 2. Switch to performance
sudo tuned-adm profile performance
echo "Performance profile:"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq

# 3. Check system stats
vmstat 1 5
# CPU usage with different profiles

# 4. Switch to powersave
sudo tuned-adm profile powersave
echo "Powersave profile:"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# 5. Return to balanced
sudo tuned-adm profile balanced
```

### Verification

```bash
# Confirm profile
tuned-adm active

# Check tuned service
systemctl is-active tuned
```

---

## Lab 6: System Logs and Journalctl

### Objectives
- Query journal entries
- Filter by service, priority, time
- Search for specific events
- Enable persistent storage

### Exercises

#### Exercise 6.1: Basic Journal Viewing

```bash
# 1. View entire journal (paged)
journalctl | head -20
# Shows oldest entries

# 2. View recent entries
journalctl -n 20
# Last 20 entries

# 3. Follow journal in real-time
journalctl -f
# Shows new entries as they occur
# Press Ctrl+C to exit

# 4. Show entries from current boot
journalctl -b
# All entries since last boot

# 5. Show entries from previous boot
journalctl -b -1
# Previous boot entries

# 6. List all boots
journalctl --list-boots
```

#### Exercise 6.2: Filter by Service

```bash
# 1. Show entries from sshd
journalctl -u sshd

# 2. Show last 10 sshd entries
journalctl -u sshd -n 10

# 3. Show SSH entries from last hour
journalctl -u sshd --since "1 hour ago"

# 4. Show httpd entries
journalctl -u httpd

# 5. Show systemd entries
journalctl -u systemd

# 6. Multiple services
journalctl -u sshd -u httpd
```

#### Exercise 6.3: Filter by Priority

```bash
# 1. Show errors and above
journalctl -p err
# Only ERROR level and higher

# 2. Show warnings and above
journalctl -p warning

# 3. Show info level
journalctl -p info
# This is a lot!

# 4. Show debug level (most verbose)
journalctl -p debug

# 5. Combined: SSH errors
journalctl -u sshd -p err

# 6. Boot errors
journalctl -b -p err
```

#### Exercise 6.4: Time-Based Filtering

```bash
# 1. Last hour
journalctl --since "1 hour ago"

# 2. Last 24 hours
journalctl --since "24 hours ago"

# 3. Specific date
journalctl --since "2024-01-15"

# 4. Date range
journalctl --since "2024-01-15" --until "2024-01-16"

# 5. Today only
journalctl --since today

# 6. This boot only
journalctl -b --since "1 hour ago"
```

#### Exercise 6.5: Search and Filter

```bash
# 1. Search for "error"
journalctl | grep -i "error"

# 2. Search in specific service
journalctl -u sshd | grep "Failed"

# 3. Failed SSH attempts
journalctl -u sshd | grep "Failed password"

# 4. Count occurrences
journalctl -u sshd | grep -c "Failed"

# 5. Authentication events
journalctl -u sshd | grep "session"

# 6. Boot messages
journalctl -b | grep "kernel"
```

#### Exercise 6.6: Different Output Formats

```bash
# 1. Short format (default)
journalctl -n 5

# 2. Short ISO format
journalctl -n 5 -o short-iso

# 3. Verbose format
journalctl -n 5 -o verbose

# 4. JSON format
journalctl -n 5 -o json

# 5. JSON pretty format
journalctl -n 5 -o json-pretty

# 6. Just messages
journalctl -n 5 -o cat
```

### Verification

```bash
# Verify journal is accessible
journalctl --disk-usage
# Shows journal size

# Check recent activity
journalctl -n 10
```

---

## Lab 7: Preserve System Journals

### Objectives
- Enable persistent journal storage
- Configure journal retention
- Verify persistent storage

### Exercises

#### Exercise 7.1: Enable Persistent Storage

```bash
# 1. Check current storage (temporary)
ls -la /run/log/journal/

# 2. Create persistent directory
sudo mkdir -p /var/log/journal

# 3. Set permissions
sudo chmod 2755 /var/log/journal

# 4. Restart journald
sudo systemctl restart systemd-journald

# 5. Verify persistent storage
ls -la /var/log/journal/
# Should have UUID-named directory

# 6. Verify journal works
journalctl -n 5
```

#### Exercise 7.2: Journal Maintenance

```bash
# 1. Check disk usage
journalctl --disk-usage
# Shows: Archived and active journals take up X

# 2. Check journal size before and after
journalctl --disk-usage
df -h /var

# 3. Limit journal size to 500MB
sudo journalctl --vacuum-size=500M

# 4. Verify size reduced
journalctl --disk-usage

# 5. Rotate journals
sudo systemctl rotate-journals

# 6. List journals
ls -la /var/log/journal/*/
```

#### Exercise 7.3: Check Configuration

```bash
# 1. View journald config
sudo cat /etc/systemd/journald.conf | grep -v "^#" | grep -v "^$"

# 2. Check storage setting
grep "^Storage" /etc/systemd/journald.conf
# Should show: Storage=persistent

# 3. If not set, edit config
sudo vi /etc/systemd/journald.conf
# Uncomment and ensure: Storage=persistent

# 4. Apply changes
sudo systemctl restart systemd-journald

# 5. Verify persistent storage
ls /var/log/journal/
```

### Verification

```bash
# Check persistent storage
ls -la /var/log/journal/*/

# Verify journal accessible after reboot (simulated)
journalctl -b -1 | head -5  # Previous boot messages

# Check journal size
journalctl --disk-usage
```

---

## Lab 8: Service Management

### Objectives
- Start, stop, enable, disable services
- Check service status
- Understand service dependencies

### Exercises

#### Exercise 8.1: Service Status Operations

```bash
# 1. Check sshd service status
sudo systemctl status sshd

# 2. Check if running
sudo systemctl is-active sshd
# Output: active or inactive

# 3. Check if enabled on boot
sudo systemctl is-enabled sshd
# Output: enabled or disabled

# 4. Stop the service
sudo systemctl stop sshd
sudo systemctl status sshd
# Should show: inactive (dead)

# 5. Try SSH - should fail
ssh localhost
# Permission denied (can't connect)

# 6. Start service again
sudo systemctl start sshd
sudo systemctl status sshd
# Should show: active (running)

# 7. SSH works now
ssh localhost
# Or: ssh $USER@localhost
```

#### Exercise 8.2: Enable/Disable on Boot

```bash
# 1. Check if enabled
sudo systemctl is-enabled httpd

# 2. If not running, start it
sudo systemctl start httpd 2>/dev/null || echo "httpd not installed"

# 3. Enable for boot
sudo systemctl enable httpd
sudo systemctl is-enabled httpd
# Output: enabled

# 4. Check symlink
ls -la /etc/systemd/system/multi-user.target.wants/ | grep httpd

# 5. Disable from boot
sudo systemctl disable httpd
sudo systemctl is-enabled httpd
# Output: disabled

# 6. Verify symlink removed
ls /etc/systemd/system/multi-user.target.wants/ | grep httpd
# httpd.service not there

# 7. Service still running but won't start on boot
sudo systemctl status httpd | grep Active

# 8. Stop service
sudo systemctl stop httpd 2>/dev/null || echo "Already stopped"
```

#### Exercise 8.3: Restart and Reload

```bash
# Start a service
sudo systemctl start httpd 2>/dev/null || echo "httpd not available"

# 1. Restart service
sudo systemctl restart httpd
# Stops then starts (clean restart)

# 2. Reload service
sudo systemctl reload httpd
# Service continues, config reloaded (less disruptive)

# 3. Try restart (restart if running)
sudo systemctl try-restart httpd

# 4. Conditional restart
sudo systemctl condrestart httpd
```

#### Exercise 8.4: Service Dependencies

```bash
# 1. Show what httpd needs
systemctl list-dependencies httpd

# 2. Show detailed dependencies
systemctl list-dependencies httpd --all

# 3. Show what depends on httpd
systemctl list-dependencies --reverse httpd

# 4. Compare SSH dependencies
systemctl list-dependencies sshd

# 5. Show conflicts
systemctl list-dependencies --conflicts httpd
```

#### Exercise 8.5: List Services

```bash
# 1. List all enabled services
systemctl list-unit-files --type=service --state=enabled

# 2. List all disabled services
systemctl list-unit-files --type=service --state=disabled

# 3. List running services
systemctl list-units --type=service --state=running

# 4. Count services
systemctl list-units --type=service | wc -l

# 5. Find specific service
systemctl list-unit-files | grep ssh
systemctl list-unit-files | grep http
```

### Verification

```bash
# Final checks
sudo systemctl status sshd

# List running services
systemctl list-units --type=service --state=running | head

# Check enabled services
systemctl list-unit-files --type=service --state=enabled | head
```

---

## Lab 9: Secure File Transfer

### Objectives
- Transfer files with SCP
- Synchronize with RSYNC
- Use SFTP for interactive transfer

### Exercises

#### Exercise 9.1: Setup SSH Keys

```bash
# 1. Generate SSH key pair (if not present)
test -f ~/.ssh/id_rsa || ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# 2. Check keys
ls -la ~/.ssh/id_rsa*
# id_rsa (private), id_rsa.pub (public)

# 3. Local SSH setup (for testing)
ssh-copy-id -i ~/.ssh/id_rsa.pub $USER@localhost 2>/dev/null || \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# 4. Test passwordless SSH
ssh $USER@localhost whoami
# Should work without password
```

#### Exercise 9.2: SCP File Transfer

```bash
# 1. Create test files
mkdir -p scp_test
echo "Test file 1" > scp_test/file1.txt
echo "Test file 2" > scp_test/file2.txt
ls -la scp_test/

# 2. Copy to "remote" (localhost for testing)
scp scp_test/file1.txt $USER@localhost:/tmp/file1_scp.txt

# 3. Verify transfer
ssh $USER@localhost ls -la /tmp/file1_scp.txt
ssh $USER@localhost cat /tmp/file1_scp.txt

# 4. Copy directory
scp -r scp_test $USER@localhost:/tmp/scp_test_copy

# 5. Verify directory copy
ssh $USER@localhost ls -la /tmp/scp_test_copy/

# 6. Copy FROM "remote" to local
scp $USER@localhost:/tmp/file1_scp.txt ./file1_retrieved.txt

# 7. Verify local copy
ls -la file1_retrieved.txt
cat file1_retrieved.txt

# 8. Copy with verbose output
scp -v scp_test/file2.txt $USER@localhost:/tmp/file2_scp.txt
```

#### Exercise 9.3: RSYNC Synchronization

```bash
# 1. Create source and destination directories
mkdir -p rsync_source rsync_dest
echo "file 1" > rsync_source/file1.txt
echo "file 2" > rsync_source/file2.txt
echo "file 3" > rsync_source/file3.txt

# 2. Basic rsync
rsync -av rsync_source/ rsync_dest/
# Synchronizes files

# 3. Verify synchronization
ls -la rsync_dest/

# 4. Add a file to source
echo "file 4" > rsync_source/file4.txt

# 5. Rsync again (only copies new file)
rsync -av rsync_source/ rsync_dest/

# 6. Test --delete option
echo "extra" > rsync_dest/extra.txt
rsync -av --delete rsync_source/ rsync_dest/
# extra.txt removed

# 7. Dry run (test without copying)
echo "test_file" > rsync_source/test.txt
rsync -avn rsync_source/ rsync_dest/
# Shows what would be copied

# 8. Exclude patterns
rsync -av --exclude='*.txt' rsync_source/ rsync_dest/
# *.txt files not copied
```

#### Exercise 9.4: SFTP Interactive Transfer

```bash
# 1. Start SFTP session
sftp localhost
# Connected to localhost

# 2. SFTP commands:
ls                              # List remote files
lls                             # List local files
pwd                             # Remote working directory
lpwd                            # Local working directory
cd /tmp                         # Change remote directory
lcd scp_test                    # Change local directory

# 3. Upload file
put file1.txt                   # Upload file1.txt
ls                              # Verify upload

# 4. Download file
get /tmp/file2_scp.txt          # Download file2_scp.txt
lls                             # Check local files

# 5. Create remote directory
mkdir sftp_test_dir

# 6. Upload multiple
mput *.txt                      # Upload all .txt files

# 7. Download multiple
mget sftp_test_dir/*            # Download all from directory

# 8. Delete remote file
rm unwanted_file.txt

# 9. Exit SFTP
exit
```

### Verification

```bash
# Check transferred files exist
ls -la /tmp/file1_scp.txt
ls -la file1_retrieved.txt

# Verify directory sync
ls -la rsync_dest/

# Check permissions preserved (if used -p)
stat rsync_dest/file1.txt
```

---

## Integration Lab: Complete System Operations

### Scenario
Configure a complete system maintenance workflow including shutdown, service management, log review, and backup.

### Tasks

```bash
#!/bin/bash
# Complete system operations lab

echo "=== System Operations Lab ==="

# 1. System Information
echo "1. System Information"
uptime
systemctl get-default
tuned-adm active

# 2. Process Monitoring
echo "2. Top CPU Processes"
ps aux --sort=-%cpu | head -5

echo "3. Top Memory Processes"
ps aux --sort=-%mem | head -5

# 4. Service Status
echo "4. Service Status"
sudo systemctl status sshd
sudo systemctl is-enabled sshd

# 5. Recent Logs
echo "5. Recent System Logs"
journalctl -n 5

# 6. SSH Errors (if any)
echo "6. SSH Events"
journalctl -u sshd -n 3

# 7. Process Priorities
echo "7. Starting background task"
nice -n 15 sleep 60 &
BGPID=$!
ps -o pid,nice,cmd | grep $BGPID

# 8. Create and backup file
echo "8. File Backup Test"
mkdir -p ~/backup_test
echo "Important data" > ~/backup_test/data.txt
tar -czf ~/backup_test_$(date +%Y%m%d).tar.gz ~/backup_test

# 9. Shutdown countdown (cancelled)
echo "9. Shutdown countdown test"
echo "Would schedule: sudo shutdown -h +2 'Maintenance'"
# DON'T ACTUALLY RUN THIS

# 10. Cleanup
echo "10. Cleanup"
kill $BGPID 2>/dev/null || true
rm -rf ~/backup_test
echo "Lab complete!"
```

---

## Summary Checklist

- [ ] Practiced shutdown and reboot operations
- [ ] Switched between graphical and multi-user targets
- [ ] Understood target dependencies
- [ ] Practiced boot interruption (rd.break)
- [ ] Identified CPU and memory intensive processes
- [ ] Adjusted process priorities with nice/renice
- [ ] Used CPU affinity with taskset
- [ ] Killed processes with appropriate signals
- [ ] Explored tuning profiles
- [ ] Queried journal with various filters
- [ ] Enabled persistent journal storage
- [ ] Started, stopped, enabled services
- [ ] Understood service dependencies
- [ ] Transferred files securely with SCP/RSYNC
- [ ] Used SFTP for interactive transfer

---

## Next Steps

1. Complete all exercises 2-3 times
2. Practice in different scenarios
3. Combine multiple topics in custom scenarios
4. Move to Module 3 when confident
5. Review weak areas daily

---

**Excellent work! You've completed Module 2 labs.**

*End of Module 2 Lab Exercises*
