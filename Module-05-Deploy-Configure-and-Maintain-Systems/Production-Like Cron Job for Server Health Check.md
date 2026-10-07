# Production-Like Cron Job for Server Health Check

This guide shows how to schedule a server health-check script using **cron** in a production-like way on RHEL.

## 1. Existing Script

Our original script is:

```bash
/home/kashif/Documents/server-health.sh
```

First, verify it:

```bash
ls -l /home/kashif/Documents/server-health.sh
```

---

## 2. Install the Script in a System Location

Instead of running a production cron job directly from `/home`, copy the script to `/usr/local/sbin`.

```bash
sudo install -o root -g root -m 0750 \
/home/kashif/Documents/server-health.sh \
/usr/local/sbin/server-health.sh
```

Verify:

```bash
ls -l /usr/local/sbin/server-health.sh
```

Expected:

```text
-rwxr-x---. 1 root root ... /usr/local/sbin/server-health.sh
```

### Why?

- `root:root` → only root owns the script
- `0750` → root can read/write/execute; group can read/execute
- `/usr/local/sbin` → appropriate location for locally installed system administration scripts

---

## 3. Create a Log File

Create a dedicated log file:

```bash
sudo touch /var/log/server-health.log
```

Set ownership:

```bash
sudo chown root:root /var/log/server-health.log
```

Set permissions:

```bash
sudo chmod 640 /var/log/server-health.log
```

Verify:

```bash
ls -l /var/log/server-health.log
```

Expected:

```text
-rw-r-----. 1 root root ... /var/log/server-health.log
```

---

## 4. Create the Cron Job

For a system-level production-style job, use `/etc/cron.d/`.

Create:

```bash
sudo vi /etc/cron.d/server-health
```

Add:

```cron
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
MAILTO=

# Run server health check every 30 minutes
*/30 * * * * root /usr/bin/flock -n /run/lock/server-health.lock /usr/local/sbin/server-health.sh >> /var/log/server-health.log 2>&1
```

Save:

```text
:wq
```

---

## 5. Understand the Cron Line

```cron
*/30 * * * * root /usr/bin/flock -n /run/lock/server-health.lock /usr/local/sbin/server-health.sh >> /var/log/server-health.log 2>&1
```

### Schedule

```text
*/30 * * * *
```

Means:

> Run every 30 minutes.

It runs at:

```text
00 minutes
30 minutes
```

of every hour.

### User

```text
root
```

The `/etc/cron.d` format requires the username.

### flock

```bash
/usr/bin/flock -n /run/lock/server-health.lock
```

Prevents multiple copies of the script from running at the same time.

`-n` means:

> If another copy is already running, do not wait; exit immediately.

### Script

```bash
/usr/local/sbin/server-health.sh
```

This is the script being executed.

### Logging

```bash
>> /var/log/server-health.log
```

Appends normal output to the log.

```bash
2>&1
```

Sends error output to the same log file.

---

## 6. Check the Cron Service

On RHEL, the cron service is called `crond`.

Check it:

```bash
sudo systemctl status crond
```

Make sure it is running.

Enable and start it:

```bash
sudo systemctl enable --now crond
```

---

## 7. Check the Cron Configuration

View the cron job:

```bash
sudo cat /etc/cron.d/server-health
```

Check your personal crontab:

```bash
crontab -l
```

For this setup, the personal crontab can remain empty because the job is managed through:

```text
/etc/cron.d/server-health
```

---

## 8. Test the Script Manually

Run:

```bash
sudo /usr/local/sbin/server-health.sh
```

The health-check output should appear on the terminal.

---

## 9. Test the Production-Like Command Manually

To test the same command that cron will execute:

```bash
sudo bash -c '/usr/bin/flock -n /run/lock/server-health.lock /usr/local/sbin/server-health.sh >> /var/log/server-health.log 2>&1'
```

Check the log:

```bash
sudo tail -50 /var/log/server-health.log
```

You should see the server health-check output.

---

## 10. Why `sudo command >> /var/log/file` Can Fail

This command can fail:

```bash
sudo command >> /var/log/server-health.log
```

because the shell processes:

```bash
>> /var/log/server-health.log
```

as the normal user.

Use:

```bash
sudo bash -c 'command >> /var/log/server-health.log 2>&1'
```

so the redirection is also performed as root.

---

## 11. Check Cron Execution

View recent cron activity:

```bash
sudo tail -20 /var/log/cron
```

Or:

```bash
sudo grep CROND /var/log/cron | tail -20
```

You should eventually see:

```text
(root) CMD (...)
```

for the server-health job.

You can also check:

```bash
sudo journalctl -u crond
```

---

## 12. Test More Quickly

The production schedule is:

```cron
*/30 * * * *
```

For testing, temporarily change it to:

```cron
* * * * *
```

This runs the script every minute.

Then watch the log:

```bash
sudo tail -f /var/log/server-health.log
```

After confirming that cron works, change the schedule back to:

```cron
*/30 * * * *
```

---

## 13. Final Production-Like Structure

```text
/home/kashif/Documents/server-health.sh
                |
                v
/usr/local/sbin/server-health.sh
                |
                v
/etc/cron.d/server-health
                |
                v
              flock
                |
                v
/var/log/server-health.log
```

### Final Files

Script:

```text
/usr/local/sbin/server-health.sh
```

Cron configuration:

```text
/etc/cron.d/server-health
```

Log:

```text
/var/log/server-health.log
```

Lock:

```text
/run/lock/server-health.lock
```

## 14. Final Cron Configuration

```cron
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
MAILTO=

# Run server health check every 30 minutes
*/30 * * * * root /usr/bin/flock -n /run/lock/server-health.lock /usr/local/sbin/server-health.sh >> /var/log/server-health.log 2>&1
```

## 15. Useful Commands

```bash
# Check cron service
systemctl status crond

# Check cron configuration
sudo cat /etc/cron.d/server-health

# Check script
ls -l /usr/local/sbin/server-health.sh

# Run script manually
sudo /usr/local/sbin/server-health.sh

# Check log
sudo tail -50 /var/log/server-health.log

# Monitor log live
sudo tail -f /var/log/server-health.log

# Check cron activity
sudo grep CROND /var/log/cron | tail -20

# Check personal crontab
crontab -l
```

## Key Concepts

```text
cron      → recurring jobs
at        → one-time jobs
/etc/cron.d → system-level cron jobs
flock     → prevents overlapping executions
>         → overwrite
>>        → append
2>&1      → send errors to the same output
crond     → cron service on RHEL
```

This setup is suitable as a **RHCSA lab exercise** and introduces several practices commonly used for system administration: dedicated script locations, controlled permissions, system-level scheduling, locking, and logging.
