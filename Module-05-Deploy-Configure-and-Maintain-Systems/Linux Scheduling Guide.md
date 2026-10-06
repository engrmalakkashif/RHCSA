# Linux Scheduling Guide — `crontab` and `at`

A practical, step-by-step RHCSA guide to scheduling recurring and one-time tasks in Linux.

---

## 1. What Is Linux Job Scheduling?

Linux scheduling allows you to automatically run commands or scripts at a specific time.

There are two important tools for RHCSA:

| Tool | Purpose |
|---|---|
| `cron` / `crontab` | Run tasks repeatedly on a schedule |
| `at` | Run a task once at a future time |

### Easy way to remember

```text
cron = Repeat
at   = Once
```

### Real-world examples

```text
cron → Run a server health check every 5 minutes
cron → Create a backup every night at 2 AM

at   → Restart a service once at 11:30 PM
at   → Run a maintenance script once after 10 minutes
```

---

# Part 1 — `cron` and `crontab`

## 2. What Is `cron`?

`cron` is a Linux service that automatically runs commands or scripts according to a schedule.

It is useful for recurring tasks such as:

- Every minute
- Every hour
- Every day
- Every Sunday
- Every month
- Backups
- Log cleanup
- Monitoring
- Health checks
- Maintenance scripts

---

## 3. Check the Cron Service

On Ubuntu/Debian, the service is normally called `cron`.

Check its status:

```bash
systemctl status cron
```

You should see something similar to:

```text
Active: active (running)
```

### Start and enable cron

If it is not running:

```bash
sudo systemctl enable --now cron
```

This does two things:

```text
enable → Start automatically at boot
--now  → Start it immediately
```

Verify:

```bash
systemctl status cron
```

---

# 4. Manage Your Crontab

A **crontab** is the schedule table containing your user's cron jobs.

## View your cron jobs

```bash
crontab -l
```

If you have no jobs, you may see:

```text
no crontab for kashif-khan
```

---

## Edit your cron jobs

```bash
crontab -e
```

This opens your user's crontab in an editor.

Add a cron entry, save it, and exit.

Then verify:

```bash
crontab -l
```

---

## Remove all your cron jobs

```bash
crontab -r
```

⚠️ **Be careful!**

This removes all cron jobs belonging to your current user.

Before removing anything, check:

```bash
crontab -l
```

---

# 5. Root's Crontab

Normal user's crontab:

```bash
crontab -l
```

Root's crontab:

```bash
sudo crontab -l
```

Edit root's crontab:

```bash
sudo crontab -e
```

### Important

These are different:

```bash
crontab -e
```

means:

```text
Edit the current user's crontab
```

While:

```bash
sudo crontab -e
```

means:

```text
Edit root's crontab
```

---

# 6. Cron Syntax

A standard user crontab entry contains:

```text
5 time fields + command
```

The format is:

```text
* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of week (0-7)
│ │ │ └──── Month (1-12)
│ │ └────── Day of month (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)
```

Full format:

```cron
minute hour day-of-month month day-of-week command
```

---

# 7. Understand Each Cron Field

## Minute

Range:

```text
0-59
```

Example:

```cron
30
```

Means:

```text
At minute 30
```

---

## Hour

Range:

```text
0-23
```

Example:

```cron
2
```

Means:

```text
At 2 AM
```

---

## Day of Month

Range:

```text
1-31
```

Example:

```cron
1
```

Means:

```text
On the 1st day of the month
```

---

## Month

Range:

```text
1-12
```

Example:

```cron
6
```

Means:

```text
June
```

---

## Day of Week

Common values:

```text
0 = Sunday
1 = Monday
2 = Tuesday
3 = Wednesday
4 = Thursday
5 = Friday
6 = Saturday
7 = Sunday
```

Both `0` and `7` can represent Sunday in traditional cron implementations.

---

# 8. Special Character `*`

The asterisk means:

```text
Every
```

For example:

```cron
* * * * * command
```

Means:

```text
Every minute
of every hour
of every day
of every month
regardless of weekday
```

---

# 9. Common Cron Examples

## Every minute

```cron
* * * * * command
```

Meaning:

```text
Run every minute
```

---

## Every hour

```cron
0 * * * * command
```

Meaning:

```text
Run at minute 0 of every hour
```

Examples:

```text
01:00
02:00
03:00
04:00
...
```

---

## Every day at 2:00 AM

```cron
0 2 * * * command
```

Breakdown:

```text
0  → minute 0
2  → hour 2
*  → every day of month
*  → every month
*  → every day of week
```

---

## Every Sunday at 3:00 AM

```cron
0 3 * * 0 command
```

Meaning:

```text
03:00 every Sunday
```

---

## Every month on the 1st at midnight

```cron
0 0 1 * * command
```

Meaning:

```text
00:00 on the 1st day of every month
```

---

# 10. Practical Example — `server-health.sh`

Suppose you have this script:

```text
/home/kashif-khan/Documents/RHCSA/Module-07-Create-Simple-Shell-Scripts/server-health.sh
```

First, check that the file exists:

```bash
ls -l /home/kashif-khan/Documents/RHCSA/Module-07-Create-Simple-Shell-Scripts/server-health.sh
```

---

## Step 1 — Make the Script Executable

Run:

```bash
chmod +x /home/kashif-khan/Documents/RHCSA/Module-07-Create-Simple-Shell-Scripts/server-health.sh
```

Verify:

```bash
ls -l /home/kashif-khan/Documents/RHCSA/Module-07-Create-Simple-Shell-Scripts/server-health.sh
```

You should see executable permissions, for example:

```text
-rwxr-xr-x
```

---

## Step 2 — Test the Script Manually

Before scheduling it, always test it manually.

Run:

```bash
/home/kashif-khan/Documents/RHCSA/Module-07-Create-Simple-Shell-Scripts/server-health.sh
```

If it works manually, continue with cron.

This is an important troubleshooting habit:

```text
Test manually
     ↓
Confirm script works
     ↓
Schedule with cron
```

---

# 11. Schedule `server-health.sh` Every Minute

Open your user's crontab:

```bash
crontab -e
```

Add:

```cron
* * * * * /home/kashif-khan/Documents/RHCSA/Module-07-Create-Simple-Shell-Scripts/server-health.sh >> /home/kashif-khan/Documents/server-health.log 2>&1
```

Save and exit.

---

# 12. Understand the Health Check Cron Entry

The entry:

```cron
* * * * * /home/kashif-khan/Documents/RHCSA/Module-07-Create-Simple-Shell-Scripts/server-health.sh >> /home/kashif-khan/Documents/server-health.log 2>&1
```

Can be divided into:

```text
* * * * *
│ │ │ │ │
│ │ │ │ └── Every day of week
│ │ │ └──── Every month
│ │ └────── Every day of month
│ └──────── Every hour
└────────── Every minute
```

Then:

```text
/path/to/server-health.sh
```

is the command being executed.

Finally:

```bash
>> /home/kashif-khan/Documents/server-health.log 2>&1
```

redirects the output to a log file.

---

# 13. Verify the Cron Job

Run:

```bash
crontab -l
```

You should see:

```cron
* * * * * /home/kashif-khan/Documents/RHCSA/Module-07-Create-Simple-Shell-Scripts/server-health.sh >> /home/kashif-khan/Documents/server-health.log 2>&1
```

---

# 14. Check the Log

After waiting at least one minute:

```bash
cat /home/kashif-khan/Documents/server-health.log
```

For continuous monitoring:

```bash
tail -f /home/kashif-khan/Documents/server-health.log
```

Press:

```text
Ctrl+C
```

to stop `tail -f`.

---

# 15. `>` vs `>>`

Output redirection is very important when working with cron.

## `>`

Example:

```bash
command > output.log
```

`>` overwrites the file.

Example:

```text
Run 1 → output.log contains Run 1
Run 2 → output.log contains Run 2
Run 3 → output.log contains Run 3
```

The previous output is replaced.

---

## `>>`

Example:

```bash
command >> output.log
```

`>>` appends to the file.

Example:

```text
Run 1 → output.log contains Run 1
Run 2 → output.log contains Run 1 + Run 2
Run 3 → output.log contains Run 1 + Run 2 + Run 3
```

For recurring health checks, `>>` is useful because it keeps historical output.

---

# 16. Understanding Linux File Descriptors

Linux commonly uses three standard file descriptors:

```text
0 = stdin
1 = stdout
2 = stderr
```

### Standard input

```text
0 = stdin
```

Input coming into a command.

### Standard output

```text
1 = stdout
```

Normal command output.

### Standard error

```text
2 = stderr
```

Error messages.

---

# 17. Understanding `2>&1`

Consider:

```bash
command >> output.log 2>&1
```

First:

```bash
>> output.log
```

means:

```text
Append stdout to output.log
```

Then:

```bash
2>&1
```

means:

```text
Send stderr to the same destination as stdout
```

Therefore:

```bash
command >> output.log 2>&1
```

means:

```text
Normal output ──┐
                ├──> output.log
Error output ───┘
```

This is especially useful with cron because cron jobs run without an interactive terminal.

---

# 18. Check Cron Execution

Check the cron service:

```bash
systemctl status cron
```

On Ubuntu/Debian, cron activity is commonly logged in:

```text
/var/log/syslog
```

Search for cron activity:

```bash
grep CRON /var/log/syslog
```

Or monitor it live:

```bash
sudo tail -f /var/log/syslog | grep CRON
```

You may see entries similar to:

```text
CRON[12345]: (kashif-khan) CMD (/home/kashif-khan/Documents/...)
```

This confirms cron is attempting to execute the scheduled command.

---

# 19. Cron Troubleshooting Checklist

If a cron job does not work, check these in order:

## Step 1 — Is cron running?

```bash
systemctl status cron
```

## Step 2 — Does the cron job exist?

```bash
crontab -l
```

## Step 3 — Does the script work manually?

```bash
/path/to/server-health.sh
```

## Step 4 — Is the script executable?

```bash
ls -l /path/to/server-health.sh
```

If needed:

```bash
chmod +x /path/to/server-health.sh
```

## Step 5 — Check cron logs

```bash
grep CRON /var/log/syslog
```

## Step 6 — Check your output/error log

```bash
cat /home/kashif-khan/Documents/server-health.log
```

---

# Part 2 — `at`

## 20. What Is `at`?

`at` is used to schedule a command or script to run **once in the future**.

Think:

```text
cron = recurring
at   = one-time
```

Examples:

```text
Run a command after 5 minutes
Run a script tonight at 11:30 PM
Run a maintenance task tomorrow at 8 AM
```

After the job executes, it does not repeat.

---

# 21. Install `at`

On Ubuntu/Debian:

```bash
sudo apt install at
```

After installation, enable and start the `atd` service:

```bash
sudo systemctl enable --now atd
```

Check the service:

```bash
systemctl status atd
```

You should see:

```text
Active: active (running)
```

---

# 22. Schedule a Job with `at`

To schedule a job one minute from now:

```bash
at now + 1 minute
```

You will enter an interactive prompt:

```text
at>
```

Now enter the command:

```bash
echo "Hello from at"
```

Finish the job with:

```text
Ctrl+D
```

You should receive output similar to:

```text
job 5 at Wed Oct  7 00:05:00 2026
```

The exact job ID and time will depend on your system.

---

# 23. Important: `Ctrl+D` with `at`

When you see:

```text
at>
```

Linux is waiting for the command you want to schedule.

After entering the command:

```bash
echo "Hello from at"
```

press:

```text
Ctrl+D
```

`Ctrl+D` tells the shell:

```text
I have finished entering the job.
```

It submits the job to `atd`.

---

# 24. Check Pending `at` Jobs

Use:

```bash
atq
```

Example:

```text
5    Wed Oct  7 00:05:00 2026 a kashif-khan
```

The important value here is:

```text
5
```

This is the job ID.

---

# 25. Run the Health Script with `at`

Schedule the health script to run one minute from now:

```bash
at now + 1 minute
```

At the `at>` prompt, enter:

```bash
/home/kashif-khan/Documents/RHCSA/Module-07-Create-Simple-Shell-Scripts/server-health.sh >> /home/kashif-khan/Documents/server-health.log 2>&1
```

Then press:

```text
Ctrl+D
```

Check the pending job:

```bash
atq
```

Wait until the scheduled time.

Then check again:

```bash
atq
```

The job should disappear after successful execution.

Check the output:

```bash
cat /home/kashif-khan/Documents/server-health.log
```

---

# 26. Useful `at` Examples

## Run after 5 minutes

```bash
at now + 5 minutes
```

---

## Run at 11:30 PM

```bash
at 23:30
```

---

## Run tomorrow at 8 AM

```bash
at 08:00 tomorrow
```

---

## List scheduled jobs

```bash
atq
```

---

## Remove a scheduled job

If the job ID is:

```text
5
```

remove it with:

```bash
atrm 5
```

Then verify:

```bash
atq
```

---

# 27. `cron` vs `at`

| Feature | `cron` | `at` |
|---|---|---|
| Recurring job | ✅ | ❌ |
| One-time job | ❌ | ✅ |
| Every minute | ✅ | ❌ |
| Every hour | ✅ | ❌ |
| Every day | ✅ | ❌ |
| Specific future time | ✅ | ✅ |
| Runs once | ❌ | ✅ |
| Main command | `crontab` | `at` |
| List jobs | `crontab -l` | `atq` |
| Remove jobs | `crontab -r` / edit | `atrm JOB_ID` |
| Service | `cron` | `atd` |

---

# 28. Practical Comparison

### Scenario 1 — Recurring Health Check

Requirement:

```text
Run server-health.sh every 5 minutes.
```

Use:

```text
cron
```

Example:

```cron
*/5 * * * * /path/to/server-health.sh
```

---

### Scenario 2 — One-Time Maintenance

Requirement:

```text
Run maintenance.sh once after 10 minutes.
```

Use:

```text
at
```

Example:

```bash
at now + 10 minutes
```

Then:

```bash
/path/to/maintenance.sh
```

Press:

```text
Ctrl+D
```

---

# 29. RHCSA Quick Reference

## Cron

Check service:

```bash
systemctl status cron
```

Enable/start:

```bash
sudo systemctl enable --now cron
```

View jobs:

```bash
crontab -l
```

Edit jobs:

```bash
crontab -e
```

Remove all user jobs:

```bash
crontab -r
```

Root crontab:

```bash
sudo crontab -e
```

Cron logs on Ubuntu/Debian:

```bash
grep CRON /var/log/syslog
```

---

## `at`

Install:

```bash
sudo apt install at
```

Enable/start:

```bash
sudo systemctl enable --now atd
```

Check:

```bash
systemctl status atd
```

Schedule:

```bash
at now + 5 minutes
```

List jobs:

```bash
atq
```

Remove job:

```bash
atrm JOB_ID
```

---

# 30. RHCSA Practice Lab

Practice the following without copying the answer immediately.

## Lab 1 — Cron

Create a cron job that runs:

```bash
date
```

every minute and writes the output to:

```text
~/cron-test.log
```

### Expected approach

```bash
crontab -e
```

Add:

```cron
* * * * * date >> ~/cron-test.log
```

Check:

```bash
crontab -l
```

Wait one or two minutes and run:

```bash
cat ~/cron-test.log
```

---

## Lab 2 — Daily Cron

Create a cron job that runs a backup script every day at 2 AM.

Template:

```cron
0 2 * * * /path/to/backup.sh
```

---

## Lab 3 — Weekly Cron

Run a script every Sunday at 3 AM.

Template:

```cron
0 3 * * 0 /path/to/script.sh
```

---

## Lab 4 — One-Time `at`

Schedule:

```bash
date
```

to run one minute from now.

Start:

```bash
at now + 1 minute
```

Enter:

```bash
date
```

Press:

```text
Ctrl+D
```

Check:

```bash
atq
```

---

## Lab 5 — Remove an `at` Job

Create a job:

```bash
at now + 10 minutes
```

Then list it:

```bash
atq
```

Find the job ID and remove it:

```bash
atrm JOB_ID
```

Verify:

```bash
atq
```

---

# 31. Cron Field Cheat Sheet

```text
┌──────── minute       0-59
│ ┌────── hour         0-23
│ │ ┌──── day           1-31
│ │ │ ┌── month         1-12
│ │ │ │ ┌ day-of-week   0-7
│ │ │ │ │
* * * * * command
```

Common patterns:

```cron
* * * * * command
```

Every minute.

```cron
0 * * * * command
```

Every hour.

```cron
0 2 * * * command
```

Every day at 2 AM.

```cron
0 3 * * 0 command
```

Every Sunday at 3 AM.

```cron
0 0 1 * * command
```

First day of every month at midnight.

```cron
*/5 * * * * command
```

Every 5 minutes.

---

# 32. RHCSA Interview Questions

## Q1. What is cron?

`cron` is a service used to execute commands or scripts automatically on a recurring schedule.

---

## Q2. What is crontab?

A crontab is a file/table containing scheduled cron jobs for a user.

---

## Q3. What is the difference between `cron` and `at`?

```text
cron → recurring scheduled jobs
at   → one-time scheduled jobs
```

---

## Q4. How do you view your cron jobs?

```bash
crontab -l
```

---

## Q5. How do you edit your cron jobs?

```bash
crontab -e
```

---

## Q6. How do you schedule a job every minute?

```cron
* * * * * command
```

---

## Q7. How do you schedule a job every day at 2 AM?

```cron
0 2 * * * command
```

---

## Q8. What does `>>` mean?

It appends output to a file without overwriting existing content.

---

## Q9. What does `2>&1` mean?

It redirects standard error (`stderr`, file descriptor 2) to the same destination as standard output (`stdout`, file descriptor 1).

---

## Q10. How do you list `at` jobs?

```bash
atq
```

---

## Q11. How do you remove an `at` job?

```bash
atrm JOB_ID
```

---

## Q12. What service runs `at` jobs?

```text
atd
```

Check it with:

```bash
systemctl status atd
```

---

# 33. Final RHCSA Memory Map

```text
                    Linux Scheduling
                           │
             ┌─────────────┴─────────────┐
             │                           │
           cron                         at
             │                           │
          Repeat                        Once
             │                           │
       ┌─────┴─────┐               ┌─────┴─────┐
       │            │               │           │
   crontab -e   crontab -l         at          atq
       │            │               │           │
     Edit          View           Schedule      List
       │                            │
       └──────────────┐             │
                      │             │
                Recurring       One-time
                  jobs            jobs
```

## The most important commands

```bash
# CRON
systemctl status cron
crontab -l
crontab -e

# AT
systemctl status atd
at now + 5 minutes
atq
atrm JOB_ID
```

## The most important concept

```text
cron = Repeat
at   = Once
```

For RHCSA, remember:

> **Use `cron`/`crontab` for recurring scheduled tasks and `at` for one-time scheduled tasks.**
