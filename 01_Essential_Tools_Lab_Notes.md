# RHCSA Exam Preparation: Understand and Use Essential Tools
## Detailed Lab Notes & Study Guide

---

## Table of Contents
1. [Shell Prompt & Command Syntax](#shell-prompt--command-syntax)
2. [Input-Output Redirection](#input-output-redirection)
3. [Text Analysis with grep & Regular Expressions](#text-analysis-with-grep--regular-expressions)
4. [Remote Access with SSH](#remote-access-with-ssh)
5. [User Management & Login](#user-management--login)
6. [File Archiving & Compression](#file-archiving--compression)
7. [Text File Creation & Editing](#text-file-creation--editing)
8. [File & Directory Operations](#file--directory-operations)
9. [Links (Hard & Soft)](#links-hard--soft)
10. [File Permissions (ugo/rwx)](#file-permissions-ugorms)
11. [System Documentation](#system-documentation)
12. [Lab Exercises & Practice](#lab-exercises--practice)

---

## Shell Prompt & Command Syntax

### Understanding the Shell Prompt

```bash
# Basic prompt structure
[user@hostname directory]$        # Regular user prompt
[user@hostname directory]#        # Root user prompt
```

### Command Syntax Fundamentals

```bash
# Basic command structure
command [options] [arguments]

# Examples:
ls -l /home                  # command with option and argument
grep -i "pattern" file.txt   # command with option and pattern/file
```

### Key Command Rules
- Commands are case-sensitive
- Options can be short (`-l`) or long (`--long`)
- Multiple short options can be combined: `ls -la` = `ls -l -a`
- Arguments typically come after options
- Use `--` to separate options from arguments containing dashes

### Common Command Patterns

```bash
# Getting help
command --help              # Brief help
man command                 # Full manual page
command -h                  # Alternative help flag

# Executing multiple commands
command1; command2          # Sequential execution (regardless of success)
command1 && command2        # Sequential (only if command1 succeeds)
command1 || command2        # Sequential (only if command1 fails)

# Running in background
command &                   # Run in background
jobs                        # List background jobs
fg %1                       # Bring job 1 to foreground
bg %1                       # Resume job 1 in background
```

### Command History

```bash
# History navigation
history                     # Show command history
!5                         # Execute command 5
!!                         # Execute last command
!string                    # Execute last command starting with 'string'
Ctrl+R                     # Search history (Ctrl+R again for previous matches)

# History in ~/.bash_history
HISTSIZE=1000              # Number of history entries in memory
HISTFILESIZE=2000          # Number of lines in history file
```

---

## Input-Output Redirection

### Standard Streams

```
stdin  (0)  - Standard input (keyboard by default)
stdout (1)  - Standard output (terminal by default)
stderr (2)  - Standard error (terminal by default)
```

### Output Redirection

```bash
# Redirect stdout to file (overwrite)
command > file.txt
ls > file_list.txt          # Overwrites file_list.txt

# Redirect stdout to file (append)
command >> file.txt
echo "new line" >> file.txt # Appends to file.txt

# Redirect stderr to file
command 2> error.log
grep "pattern" *.txt 2> errors.txt

# Redirect stderr to append
command 2>> error.log

# Redirect both stdout and stderr to file
command &> output.txt
command > output.txt 2>&1    # Alternative syntax
ls /nonexistent &> log.txt

# Redirect stdout to one file, stderr to another
command > output.txt 2> error.txt

# Discard output completely
command > /dev/null 2>&1
```

### Input Redirection

```bash
# Redirect stdin from file
command < file.txt
sort < unsorted.txt         # Sort the contents of unsorted.txt

# Read from multiple files (here-document)
cat << EOF
This is a multi-line
document. Anything here
becomes input to cat.
EOF

# Here-string (<<<)
grep "search" <<< "some text here"
```

### Pipes (|)

```bash
# Pipe stdout from one command to stdin of another
command1 | command2

# Common pipe examples
cat file.txt | grep "error"
ls -l | grep "user1"
ps aux | grep "httpd"
cat file.txt | wc -l
sort file.txt | uniq
ps aux | wc -l
```

### Advanced Redirection

```bash
# Duplicate output
command | tee file.txt              # Display AND save to file
command | tee -a file.txt           # Append instead of overwrite
command | tee file1.txt file2.txt   # Save to multiple files

# Execute command with modified FD
exec 3< file.txt                # Open file descriptor 3 for reading
exec 4> output.txt              # Open file descriptor 4 for writing
command >&3                     # Redirect stdout to FD 3

# Combining streams
command 2>&1 | grep "pattern"   # Pipe both stdout and stderr
command 1>&2                    # Redirect stdout to stderr
command 2>&1 | tee log.txt      # Log both streams
```

### Practical Examples

```bash
# Find all errors and warnings
grep -i "error\|warning" /var/log/messages 2> /dev/null

# Create a backup with timestamp
cp important.txt important.txt.backup >> backup.log 2>&1

# Chain multiple commands
cat data.txt | sort | uniq | wc -l

# Redirect for logging and monitoring
./script.sh > /var/log/script.log 2>&1 &
```

---

## Text Analysis with grep & Regular Expressions

### grep Basics

```bash
# Basic syntax
grep [OPTIONS] PATTERN [FILE...]

# Search for pattern in file
grep "search_term" file.txt

# Search multiple files
grep "pattern" file1.txt file2.txt file3.txt

# Search in all files in directory
grep "pattern" /path/to/directory/*
grep -r "pattern" /path/to/directory    # Recursive
```

### Common grep Options

```bash
-i              # Case-insensitive search
-v              # Invert match (show lines NOT matching)
-c              # Count matching lines
-n              # Show line numbers
-l              # Show only filenames with matches
-L              # Show only filenames without matches
-o              # Show only the matching part
-w              # Match whole words only
-x              # Match entire lines only
-A NUM          # Show NUM lines after match
-B NUM          # Show NUM lines before match
-C NUM          # Show NUM lines before and after
-r              # Recursive search in directories
-e              # Use multiple patterns
--color         # Highlight matches
```

### grep Examples

```bash
# Basic searches
grep "root" /etc/passwd              # Find root user
grep -c "error" log.txt              # Count errors
grep -i "ERROR" log.txt              # Case-insensitive
grep -v "#" config.txt               # Exclude comments
grep -n "pattern" file.txt           # Show line numbers

# Word and line matching
grep -w "the" file.txt               # Only exact word "the"
grep -x "exact line" file.txt        # Only exact matches

# Context around matches
grep -A 2 "error" log.txt            # 2 lines after error
grep -B 2 "error" log.txt            # 2 lines before error
grep -C 3 "error" log.txt            # 3 lines before and after

# Multiple patterns
grep -e "error" -e "warning" log.txt
grep "pattern1\|pattern2" file.txt

# Recursive search
grep -r "function_name" /home/user/code/
grep -r "TODO" . --include="*.py"    # Search only .py files

# Invert match
grep -v "^#" config.txt              # Exclude comment lines
grep -v "^$" file.txt                # Exclude empty lines

# Filename matching
grep -l "pattern" *.txt              # Show filenames with match
grep -L "pattern" *.txt              # Show filenames without match

# Show only the match
grep -o "[0-9]*\.[0-9]*" file.txt   # Extract IP addresses
```

### Regular Expressions (regex)

```bash
# Basic regex characters
.                   # Any single character
*                   # Zero or more of previous character
^                   # Start of line
$                   # End of line
[]                  # Character class (any character inside)
[^]                 # Negated character class
\                   # Escape special character

# Extended regex (grep -E or egrep)
+                   # One or more of previous
?                   # Zero or one of previous
()                  # Grouping
|                   # OR operator
{}                  # Repeat count
```

### regex Examples

```bash
# Basic patterns
grep "^admin" /etc/passwd           # Lines starting with "admin"
grep "\.txt$" list.txt              # Lines ending with ".txt"
grep "^[0-9]" file.txt              # Lines starting with digit
grep "[aeiou]" file.txt             # Lines containing vowels
grep "[^0-9]" file.txt              # Lines with non-digits

# Email pattern
grep -E "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" emails.txt

# IP address pattern
grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$" ips.txt

# Extended regex (grep -E or egrep)
grep -E "error|warning|critical" log.txt    # Multiple patterns
egrep "^(root|bin|daemon)" /etc/passwd      # OR patterns

# Word boundaries
grep -E "\berror\b" log.txt         # Exact word "error"
grep -E "^(admin|root)" /etc/passwd # Lines starting with admin or root

# Repeat patterns
grep -E "[0-9]{3}-[0-9]{3}-[0-9]{4}" phone.txt  # Phone number
grep -E "a{2,4}" file.txt           # "aa", "aaa", or "aaaa"
```

### Advanced grep Techniques

```bash
# Combining with other commands
grep "error" log.txt | wc -l        # Count errors
grep -i "user" /etc/passwd | cut -d: -f1  # Extract usernames
ps aux | grep "httpd"               # Find httpd processes

# Using sed or awk with grep
grep "pattern" file.txt | sed 's/old/new/'
grep "pattern" file.txt | awk '{print $1}'

# Store in variable
MATCHES=$(grep -c "error" log.txt)
echo "Found $MATCHES errors"

# Conditional execution
grep -q "pattern" file.txt && echo "Found" || echo "Not found"
```

### Practice Commands

```bash
# System files
grep "^root" /etc/passwd
grep -c "user1" /var/log/auth.log
grep "FAILED" /var/log/auth.log | wc -l

# Log analysis
grep "ERROR\|WARN" /var/log/messages
grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" /var/log/access.log
grep -v "^#" /etc/ssh/sshd_config | grep -v "^$"
```

---

## Remote Access with SSH

### SSH Basics

```bash
# Basic SSH connection
ssh username@hostname
ssh username@192.168.1.100
ssh user@example.com

# SSH with port
ssh -p 2222 user@example.com        # Non-standard port

# Execute command remotely
ssh user@host "command"
ssh user@host "ls -la /home"
ssh root@server "systemctl restart httpd"

# Run command and exit
ssh user@host "uptime"              # Run uptime and return
```

### SSH Options

```bash
-p PORT         # Specify port (default 22)
-l USER         # Specify username (alternative to user@host)
-i KEY          # Use specific private key
-v              # Verbose (show connection details)
-vv             # Very verbose
-q              # Quiet mode
-X              # Enable X11 forwarding
-Y              # Enable trusted X11 forwarding
-L              # Local port forwarding
-R              # Remote port forwarding
-N              # Do not execute command (for port forwarding)
-f              # Run in background
-t              # Force pseudo-terminal allocation
-T              # Disable pseudo-terminal allocation
-o              # Pass SSH options
```

### SSH Configuration

```bash
# SSH config file location
~/.ssh/config

# Example ~/.ssh/config
Host web-server
    Hostname 192.168.1.100
    User admin
    Port 2222
    IdentityFile ~/.ssh/id_rsa

Host dev-*
    User developer
    IdentityFile ~/.ssh/dev_key

# Usage after configuration
ssh web-server              # Uses settings from ~/.ssh/config
```

### SSH Key Management

```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "passphrase"
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519  # Modern algorithm

# Key locations
~/.ssh/id_rsa               # Private key (keep secret!)
~/.ssh/id_rsa.pub           # Public key
~/.ssh/authorized_keys      # Contains public keys of allowed users

# Copy public key to server (for password-less login)
ssh-copy-id -i ~/.ssh/id_rsa.pub user@host
# Manual: append id_rsa.pub to ~/.ssh/authorized_keys on server

# SSH agent (cache passphrase)
ssh-agent bash              # Start agent in new shell
ssh-add ~/.ssh/id_rsa       # Add key to agent
ssh-add -l                  # List keys in agent

# Set key permissions
chmod 700 ~/.ssh            # Directory
chmod 600 ~/.ssh/id_rsa     # Private key
chmod 644 ~/.ssh/id_rsa.pub # Public key
chmod 600 ~/.ssh/authorized_keys  # On server
```

### SSH Tunneling & Forwarding

```bash
# Local port forwarding (access remote service locally)
ssh -L LOCAL_PORT:REMOTE_HOST:REMOTE_PORT user@JUMP_HOST
ssh -L 3306:db.internal.com:3306 user@jump-host
# Then: mysql -h localhost -P 3306

# Remote port forwarding (expose local service remotely)
ssh -R REMOTE_PORT:LOCAL_HOST:LOCAL_PORT user@REMOTE_HOST

# SOCKS proxy
ssh -D 1080 user@proxy-server
# Configure browser/app to use localhost:1080 as proxy
```

### SCP - Secure Copy

```bash
# Copy file to remote
scp localfile user@host:/remote/path/
scp file.txt admin@192.168.1.100:/home/admin/

# Copy file from remote
scp user@host:/remote/file.txt ./local/path/
scp admin@server:/etc/config.conf ./

# Copy directory
scp -r /local/dir user@host:/remote/path/

# Specific port
scp -P 2222 file.txt user@host:/path/
```

### SFTP - Secure FTP

```bash
# Start SFTP session
sftp user@host

# SFTP commands (once connected)
ls                          # List remote files
pwd                         # Print working directory (remote)
cd /path                    # Change directory (remote)
put localfile               # Upload file
get remotefile              # Download file
put -r localdir             # Upload directory

# Exit SFTP
exit
bye
```

### Common SSH Problems & Solutions

```bash
# Permission denied (publickey)
# Solution: Check:
ls -la ~/.ssh/                      # Permissions on ~/.ssh
ls -la ~/.ssh/authorized_keys       # Check if exists on server
cat ~/.ssh/id_rsa.pub | ssh user@host "cat >> ~/.ssh/authorized_keys"

# Connection refused
# Solution: Check if SSH daemon is running
systemctl status sshd               # On server
netstat -tlnp | grep :22            # Check listening port

# Timeout
# Solution: Check firewall/network
ping -c 1 host
telnet host 22

# Too many authentication failures
# Solution: Specify correct key
ssh -i ~/.ssh/correct_key user@host
```

### Practice Scenarios

```bash
# Lab 1: Basic SSH connection
ssh root@192.168.1.100

# Lab 2: Execute remote command
ssh user@host "systemctl status httpd"

# Lab 3: Copy files
scp -r /local/backup user@backup-server:/backups/

# Lab 4: Port forwarding
ssh -L 3306:localhost:3306 user@remote-db-server
# Connect to localhost:3306 from local machine

# Lab 5: Disable password auth (key-only)
ssh-copy-id -i ~/.ssh/id_rsa.pub user@host
ssh user@host "sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config"
```

---

## User Management & Login

### User Accounts & Switching

```bash
# Current user information
whoami                      # Current username
id                          # UID, GID, groups
id -u                       # Just UID
id -g                       # Just GID
id -G                       # All groups
groups                      # Groups current user belongs to
groups username             # Groups for specific user
```

### Switching Users

```bash
# Switch to another user
su username                 # Switch to user (requires password)
su - username               # Switch to user AND load their environment
su -                        # Switch to root
su root                     # Alternate root switch

# Execute single command as user
su - username -c "command"
su - root -c "systemctl restart httpd"
```

### Sudo - Execute as Superuser

```bash
# Basic sudo usage
sudo command                # Execute command as root
sudo -l                     # List sudo privileges for current user
sudo -u username command    # Execute as specific user

# Sudo options
-u USER         # Run as USER (default is root)
-i              # Login shell (load environment)
-s              # Shell without login
-b              # Run in background
-E              # Preserve environment variables
-S              # Read password from stdin

# Examples
sudo systemctl restart sshd
sudo -u postgres psql       # Switch to postgres user
sudo -i                     # Root shell with environment
sudo -E pip install package # Install with preserved env
```

### sudoers File Configuration

```bash
# Edit sudoers (always use visudo!)
visudo                      # Edit /etc/sudoers safely

# sudoers syntax examples
user1 ALL=(ALL) ALL         # Full sudo access
user2 ALL=/bin/ls           # Only ls command
%group1 ALL=(ALL) NOPASSWD: ALL  # Group without password

# Check sudoers syntax
visudo -c                   # Check for errors

# Read sudoers
sudo -l                     # Show what user can do
```

### Multi-user Targets

```bash
# Run level / target
systemctl get-default       # Show default target
systemctl set-default multi-user.target    # Set default target
systemctl set-default graphical.target

# Switch target (temporarily)
systemctl isolate multi-user.target        # Switch to CLI mode
systemctl isolate graphical.target         # Switch to GUI mode

# Target units
systemctl list-units --type=target

# Available targets
ls /usr/lib/systemd/system/*.target
```

### Login Sessions

```bash
# Current sessions
who                         # Users currently logged in
w                           # More detailed who
last                        # Login history
last -f /var/log/wtmp       # Full login history

# TTY information
tty                         # Current terminal
ps                          # Current shell/terminal info

# Logout / Exit
exit                        # Exit shell/session
Ctrl+D                      # Alternative exit
logout                      # Explicit logout
```

---

## File Archiving & Compression

### tar - Tape Archive

```bash
# tar syntax
tar [OPTIONS] [ARCHIVE] [FILES]

# Common options
-c              # Create archive
-x              # Extract archive
-t              # List contents
-f FILE         # Use archive file (not tape)
-v              # Verbose (show files processed)
-z              # Compress with gzip
-j              # Compress with bzip2
-J              # Compress with xz
-p              # Preserve permissions
-P              # Preserve absolute paths (keep /)

# Create tar archive
tar -cf archive.tar file1 file2 dir1/
tar -cvf archive.tar *                  # Verbose

# Create compressed tar
tar -czf archive.tar.gz file1 file2     # gzip
tar -cjf archive.tar.bz2 file1 file2    # bzip2
tar -cJf archive.tar.xz file1 file2     # xz

# Extract tar archive
tar -xf archive.tar
tar -xvf archive.tar                    # Verbose
tar -xf archive.tar -C /destination/    # Extract to directory

# Extract compressed archive
tar -xzf archive.tar.gz                 # gzip
tar -xjf archive.tar.bz2                # bzip2
tar -xJf archive.tar.xz                 # xz

# List archive contents
tar -tf archive.tar
tar -tzf archive.tar.gz
tar -tvf archive.tar                    # Verbose listing
```

### gzip - GNU Compression

```bash
# Compress single file
gzip filename                           # Creates filename.gz
gzip -k filename                        # Keep original

# Decompress
gunzip filename.gz                      # Removes .gz
gzip -d filename.gz

# Compress with level (1-9)
gzip -9 filename                        # Maximum compression (slower)
gzip -1 filename                        # Minimum compression (faster)

# Compress stdout
cat file | gzip > file.gz
ps aux | gzip > processes.gz

# Decompress stdout
gunzip -c file.gz                       # Decompress to stdout
gunzip -c file.gz | head -20            # View first 20 lines
```

### bzip2 - Bzip Compression

```bash
# Compress with bzip2
bzip2 filename                          # Creates filename.bz2
bzip2 -k filename                       # Keep original

# Decompress
bunzip2 filename.bz2                    # Remove .bz2
bzip2 -d filename.bz2

# Compression levels
bzip2 -9 filename                       # Maximum (very slow)
bzip2 -1 filename                       # Minimum (faster)

# Note: bzip2 typically has better compression than gzip
#       but is slower
```

### xz - XZ Compression

```bash
# Compress with xz
xz filename                             # Creates filename.xz
xz -k filename                          # Keep original

# Decompress
unxz filename.xz                        # Remove .xz
xz -d filename.xz

# Compression levels
xz -9 filename                          # Maximum compression
xz -0 filename                          # Minimum compression

# Note: xz typically offers best compression but is slowest
```

### Practical Archiving Examples

```bash
# Backup home directory
tar -czf home_backup.tar.gz ~/
tar -cjf home_backup.tar.bz2 ~/

# Backup excluding certain files
tar -czf backup.tar.gz --exclude='*.tmp' --exclude='cache' /home/user/

# Create dated backup
tar -czf backup_$(date +%Y%m%d).tar.gz /important/data/

# Split large archive
tar -cf - /data | gzip | split -b 100M - backup.tar.gz.

# Extract specific file from archive
tar -xzf archive.tar.gz path/to/specific/file

# List archive without extracting
tar -tzf archive.tar.gz | head

# Verify archive integrity
tar -tzf archive.tar.gz > /dev/null && echo "OK" || echo "Corrupt"

# Backup with incremental (only changed files)
tar -czf full_backup.tar.gz /data
tar -czf incremental.tar.gz --newer-mtime-than full_backup.tar.gz /data
```

### Compression Comparison

```
Format      Compression Ratio   Speed       Common Use
gzip        Good                Fast        Web, archives
bzip2       Better              Medium      Larger files
xz          Best                Slow        Linux distributions
```

---

## Text File Creation & Editing

### Creating Text Files

```bash
# Using cat
cat > newfile.txt << EOF
Line 1 of text
Line 2 of text
Line 3 of text
EOF

# Using echo
echo "Content" > file.txt
echo "Additional content" >> file.txt

# Using touch (create empty file)
touch newfile.txt

# Using printf
printf "Line 1\nLine 2\n" > file.txt
```

### Viewing Text Files

```bash
# View entire file
cat filename.txt
cat file1.txt file2.txt             # Multiple files

# View with line numbers
cat -n filename.txt
nl filename.txt

# View first/last lines
head filename.txt                   # First 10 lines (default)
head -5 filename.txt                # First 5 lines
tail filename.txt                   # Last 10 lines (default)
tail -5 filename.txt                # Last 5 lines
tail -f filename.txt                # Follow file (show new lines)

# Page through file
less filename.txt                   # Scrollable viewer
more filename.txt                   # Basic pager

# View specific range
sed -n '10,20p' filename.txt        # Lines 10-20
awk 'NR>=10 && NR<=20' filename.txt
```

### vi/vim Editor

```bash
# Start vim
vim filename.txt
vi filename.txt                     # Traditional vi

# Vim modes
i               # Insert mode (before cursor)
I               # Insert at beginning of line
a               # Append mode (after cursor)
A               # Append at end of line
o               # New line below
O               # New line above
ESC             # Return to command mode

# Command mode (press ESC first)
:w              # Write (save)
:q              # Quit
:wq             # Write and quit
:q!             # Quit without saving
:set number     # Show line numbers
:set nonu       # Hide line numbers

# Navigation (command mode)
h, j, k, l      # Left, down, up, right
G               # Go to end of file
1G              # Go to beginning
25G             # Go to line 25
^               # Start of line
$               # End of line
w               # Next word
b               # Previous word
/pattern        # Search forward
?pattern        # Search backward
n               # Next match
N               # Previous match

# Editing (command mode)
dd              # Delete line
d5d             # Delete 5 lines
D               # Delete to end of line
yy              # Copy (yank) line
5yy             # Copy 5 lines
p               # Paste after
P               # Paste before
u               # Undo
Ctrl+R          # Redo
x               # Delete character
r               # Replace character
~               # Toggle case

# Selection (visual mode)
v               # Visual mode (character)
V               # Visual mode (line)
Ctrl+V          # Visual block mode
```

### nano Editor

```bash
# Start nano
nano filename.txt

# Basic commands (Ctrl+)
Ctrl+X          # Exit (prompts to save)
Ctrl+O          # Write out (save)
Ctrl+K          # Cut line
Ctrl+U          # Uncut (paste)
Ctrl+C          # Show cursor position
Ctrl+W          # Find
Ctrl+Y          # Page up
Ctrl+V          # Page down
Ctrl+A          # Start of line
Ctrl+E          # End of line

# Navigation
Arrow keys      # Move cursor
Alt+Home        # Start of document
Alt+End         # End of document
```

### sed - Stream Editor

```bash
# Basic sed syntax
sed [OPTIONS] 'command' file

# Substitution
sed 's/old/new/' file               # Replace first occurrence per line
sed 's/old/new/g' file              # Replace all occurrences
sed 's/old/new/2' file              # Replace 2nd occurrence per line
sed 's/old/new/gi' file             # Case-insensitive replacement

# With flags
sed -i 's/old/new/g' file           # In-place edit
sed -i.bak 's/old/new/g' file       # In-place with backup

# Delete lines
sed '/pattern/d' file               # Delete lines containing pattern
sed '5d' file                       # Delete line 5
sed '5,10d' file                    # Delete lines 5-10
sed '/^$/d' file                    # Delete empty lines

# Print lines
sed -n '/pattern/p' file            # Print lines with pattern
sed -n '5,10p' file                 # Print lines 5-10
sed -n '$ p' file                   # Print last line

# Address ranges
sed '1,3s/old/new/g' file           # Replace in lines 1-3
sed '/^root/,/^$/ d' file           # Delete from line with "root" to blank
```

### awk - Text Processing

```bash
# Basic awk syntax
awk [OPTIONS] 'pattern {action}' file

# Field processing
awk '{print $1}' file               # Print first field
awk '{print $NF}' file              # Print last field
awk '{print $1, $3}' file           # Print fields 1 and 3
awk '{print NF}' file               # Number of fields

# Field separator
awk -F: '{print $1}' /etc/passwd    # Use : as separator
awk -F, '{print $2}' data.csv       # Use comma as separator
awk 'BEGIN {FS=":"} {print $1}'     # Set separator in BEGIN

# Pattern matching
awk '/error/ {print}' log.txt       # Print lines with "error"
awk '$1 > 100' numbers.txt          # Print if first field > 100
awk 'NR == 5' file                  # Print line 5

# Variables
awk '{sum += $1} END {print sum}'   # Sum column
awk '{count++} END {print count}'   # Count lines
awk 'BEGIN {FS=":"} {print $1}' /etc/passwd  # Process /etc/passwd
```

---

## File & Directory Operations

### File Management

```bash
# Create files
touch filename.txt                  # Create empty file
touch file1 file2 file3             # Multiple files
touch -m filename                   # Update modification time

# Copy files
cp source.txt destination.txt       # Copy file
cp -i source.txt destination.txt    # Interactive (confirm overwrite)
cp -v source.txt destination.txt    # Verbose
cp -p source.txt destination.txt    # Preserve permissions/times
cp -r source_dir destination_dir    # Copy directory recursively
cp -a source_dir destination_dir    # Archive mode (preserves everything)

# Move/Rename files
mv oldname.txt newname.txt          # Rename
mv file.txt /path/to/destination/   # Move file
mv -i source destination            # Interactive
mv -v source destination            # Verbose

# Delete files
rm filename.txt                     # Delete file
rm -i filename.txt                  # Interactive (confirm)
rm file1 file2 file3                # Multiple files
rm *.txt                            # Pattern match (use carefully!)
rm -f filename                      # Force delete (no prompt)

# Delete directories
rmdir empty_directory               # Only if empty
rm -r directory_name                # Recursive delete (with files)
rm -rf directory_name               # Force recursive delete

# File info
ls -l file.txt                      # Detailed info
stat file.txt                       # Detailed file statistics
file file.txt                       # Determine file type
wc file.txt                         # Word, line, byte count
du -h file.txt                      # Disk usage
```

### Directory Management

```bash
# Create directories
mkdir directory_name                # Create single directory
mkdir -p path/to/nested/dir         # Create with parents
mkdir dir1 dir2 dir3                # Multiple directories

# Change directory
cd /path/to/directory               # Absolute path
cd ..                               # Parent directory
cd ~                                # Home directory
cd -                                # Previous directory
pwd                                 # Print working directory

# List directory contents
ls                                  # Simple listing
ls -l                               # Long format
ls -la                              # Include hidden files
ls -lh                              # Human-readable sizes
ls -lS                              # Sort by size
ls -lt                              # Sort by time
ls -R                               # Recursive listing
ls -d */                            # List directories only

# Tree view
tree                                # Tree of directories
tree -L 2                           # Limit depth to 2 levels

# Directory size
du -h directory_name                # Size of directory
du -sh directory_name               # Total size only
du -sh *                            # Size of each item

# Current directory structure
find . -type f | head               # List files
find . -type d | head               # List directories
```

### Pathname & Globbing

```bash
# Absolute vs relative paths
/etc/passwd                         # Absolute (starts with /)
./config.txt                        # Relative (current directory)
../backup/data                      # Relative (parent directory)

# Globbing patterns
*                   # Any characters (not including /)
?                   # Single character
[abc]               # Character class (a, b, or c)
[a-z]               # Range (any lowercase letter)
[!abc]              # Negation (not a, b, or c)
[[:alpha:]]         # Alpha characters
[[:digit:]]         # Digits (0-9)
[[:space:]]         # Whitespace

# Examples
ls *.txt                            # All .txt files
ls file?.txt                        # file1.txt, fileA.txt, etc.
ls [0-9]*.txt                       # Files starting with digit
ls !(*.txt)                         # All except .txt (needs extglob)
rm *.bak                            # Delete all .bak files
cp *.log /backup/                   # Copy all logs
```

### Special Directories

```bash
# Important system directories
/                       # Root filesystem
/home                   # User home directories
/root                   # Root user home
/etc                    # System configuration
/var                    # Variable data (logs, cache)
/tmp                    # Temporary files (cleared on reboot)
/opt                    # Optional software
/usr                    # User programs and libraries
/usr/local              # Locally installed software
/bin                    # Essential binaries
/sbin                   # System binaries
/lib                    # Libraries
/dev                    # Device files
/proc                   # Process information
/sys                    # System information

# Current directory references
.                       # Current directory
..                      # Parent directory
~                       # Home directory
~username               # Another user's home
~+                      # $PWD (current directory)
~-                      # $OLDPWD (previous directory)
```

---

## Links (Hard & Soft)

### Soft Links (Symbolic Links)

```bash
# Create soft link
ln -s /path/to/original /path/to/link
ln -s original link                 # Relative path
ln -s /etc/hosts /tmp/hosts_link    # Absolute path

# Soft link characteristics
# - Contains path to original file
# - Can point to files or directories
# - Can be broken (if original deleted)
# - Can cross filesystems
# - Can cross directories

# Example
ln -s /usr/bin/python3 python
./python --version                  # Works via link

# Update soft link
rm old_link
ln -s /new/path new_link

# Find soft links
ls -l                               # Shows -> points to
find . -type l                      # Find all symlinks
find . -type l -exec ls -la {} \;   # Find and show links
```

### Hard Links

```bash
# Create hard link
ln original hardlink                # Same filesystem only

# Hard link characteristics
# - Points to same inode
# - Cannot distinguish original from link
# - Cannot link directories
# - Cannot cross filesystems
# - Deleting one doesn't affect others

# Example
ln file.txt file_backup.txt
# Both point to same data
# Delete file.txt: file_backup.txt still has data

# View inode
ls -i                               # Show inode numbers
stat file.txt                       # Show inode

# Hard vs Soft link comparison
ln file.txt hard.txt                # Hard link
ln -s file.txt soft.txt             # Soft link
ls -li                              # Compare
```

### Link Verification

```bash
# Check link type
ls -l                               # Shows -> for soft links
file link_name                      # Identify link type
stat link_name                      # Show link details

# Verify soft link target
readlink symlink_name               # Show link target
readlink -f symlink_name            # Show full path

# Check inode for hard links
ls -i file1 hardlink1               # Same inode = hard link
ls -i file1 softlink1               # Different inode = soft link
```

### Practical Link Examples

```bash
# Create symlink to config
ln -s /etc/apache2/apache2.conf /home/admin/

# Link to frequently used directory
ln -s /home/user/projects ~/proj

# Create link for compatibility
ln -s /usr/bin/python3 /usr/bin/python

# Backup via hard link (same filesystem)
ln original_file backup_file

# Multiple links to same file
ln original link1
ln original link2
ln original link3
# All point to same data

# Remove link (doesn't affect original)
rm link_name
# Original file remains intact
```

---

## File Permissions (ugo/rwx)

### Permission Basics

```bash
# Permission components
u       # User (owner)
g       # Group
o       # Others
a       # All (u+g+o)

r       # Read (4)
w       # Write (2)
x       # Execute (1)

# Permission notation
-       # Not set
+       # Add permission
=       # Set exactly

# Examples
chmod u+r file              # User can read
chmod g-w file              # Group cannot write
chmod o=x file              # Others can only execute
```

### Viewing Permissions

```bash
# List with permissions
ls -l                               # Detailed listing
ls -la                              # Including hidden

# Permission display
drwxr-xr-x  2 user group 4096 file
# d = directory (- for file)
# rwx = user permissions
# r-x = group permissions
# r-x = other permissions

# Numeric permissions
chmod 755 file                      # rwxr-xr-x
chmod 644 file                      # rw-r--r--
chmod 700 file                      # rwx------

# Octal calculation
r(4) + w(2) + x(1) = 7
Example: rwx------ = 700
```

### Changing Permissions

```bash
# Symbolic mode
chmod u+x file                      # Add execute for user
chmod g+w file                      # Add write for group
chmod o-r file                      # Remove read for others
chmod a+x file                      # Add execute for all
chmod u=rwx,g=rx,o=rx file         # Set specific permissions

# Numeric mode
chmod 755 file                      # rwxr-xr-x
chmod 644 file                      # rw-r--r--
chmod 700 file                      # rwx------
chmod 600 file                      # rw-------
chmod 777 file                      # rwxrwxrwx

# Recursive permissions
chmod -R 755 directory              # All files and subdirs
chmod -R g+w directory              # Add group write recursively
find directory -type f -exec chmod 644 {} \;

# Preserve permissions
cp -p original copy                 # Copy preserves permissions
tar -p archive.tar                  # Preserve when archiving
```

### File Ownership

```bash
# View ownership
ls -l                               # Shows user and group
stat file.txt                       # Detailed ownership

# Change owner
chown newuser file.txt              # Change user
chown newuser:newgroup file.txt     # Change user and group
chown :newgroup file.txt            # Change group only

# Recursive ownership
chown -R newuser:newgroup directory
find directory -exec chown user:group {} \;

# Permissions for new files (umask)
umask                               # Show current umask
umask 022                           # Set umask (in ~/.bashrc)
# Default file permissions: 666 - umask = 644
# Default dir permissions: 777 - umask = 755
```

### Special Permissions

```bash
# Setuid (Set User ID)
chmod 4755 file                     # Binary runs as owner
chmod u+s file

# Setgid (Set Group ID)
chmod 2755 directory                # New files inherit group
chmod g+s directory

# Sticky bit
chmod 1777 directory                # Only owner can delete files
chmod o+t directory

# Finding special permissions
find / -perm -4000                  # Files with setuid
find / -perm -2000                  # Files with setgid
find / -perm -1000                  # Files with sticky bit
```

### ACL - Access Control Lists (Advanced)

```bash
# View ACL
getfacl file.txt

# Set ACL
setfacl -m u:username:rwx file.txt  # User specific permissions
setfacl -m g:groupname:rx file.txt  # Group specific permissions
setfacl -x u:username file.txt      # Remove ACL entry

# Recursive ACL
setfacl -R -m u:username:rwx directory

# Default ACL (for new files in directory)
setfacl -d -m u:username:rwx directory
```

---

## System Documentation

### man - Manual Pages

```bash
# View manual page
man command                         # View manual for command
man -k keyword                      # Search by keyword
man -f command                      # Show one-line description

# Manual sections
man 1 command                       # User command
man 5 config                        # File format
man 8 sshd                          # System administration

# Manual page navigation (less pager)
Space               # Page down
b                   # Page up
/pattern            # Search
n                   # Next match
N                   # Previous match
g                   # Go to start
G                   # Go to end
q                   # Quit

# Useful man pages for RHCSA
man chmod
man chown
man ls
man tar
man grep
man sed
man awk
man ssh
man sshd_config
```

### info - GNU Info Pages

```bash
# View info page
info command                        # View info documentation
info -d directory                   # From specific directory

# Navigation (Emacs-like)
Space               # Page down
Backspace           # Page up
Tab                 # Next menu item
Enter               # Follow link
n                   # Next chapter
p                   # Previous chapter
u                   # Up (parent node)
q                   # Quit

# Common info pages
info coreutils                      # GNU core utilities
info gzip
info tar
```

### /usr/share/doc - Documentation Files

```bash
# Documentation directory
ls /usr/share/doc/                  # Available documentation
ls /usr/share/doc/package-name/     # Package documentation

# Common files
README              # Project readme
CHANGELOG           # Version history
LICENSE             # License info
AUTHORS             # Contributors
INSTALL             # Installation instructions

# View documentation
cat /usr/share/doc/package-name/README
less /usr/share/doc/package-name/README
```

### whatis & whereis

```bash
# One-line description
whatis command                      # Brief description
whatis -w 'pattern*'                # Pattern matching

# Locate command
whereis command                     # Show binary, source, man locations
whereis -b command                  # Binary only
whereis -s command                  # Source only
whereis -m command                  # Manual only
which command                       # Full path to binary
type command                        # Command type (built-in, alias, etc)
```

### help Command

```bash
# Built-in command help
help                                # List built-ins
help command                        # Help for built-in command

# External command help
command --help
command -h
command help
```

### Find Files & Paths

```bash
# locate - find by name
updatedb                            # Update file database
locate filename                     # Find by name
locate -i filename                  # Case-insensitive

# find - comprehensive search
find / -name filename               # Search entire system
find . -name "*.txt"                # Find .txt files
find . -type f -name "*.log"        # Files only
find . -type d -name "backup"       # Directories only
find / -size +10M                   # Larger than 10MB
find / -mtime -7                    # Modified in last 7 days
find / -user username               # Owned by user

# which - find command
which ls                            # /bin/ls
which python                        # /usr/bin/python
```

### Help Resources

```bash
# System information
uname -a                            # System info
hostnamectl                         # Hostname/OS info
cat /etc/os-release                 # OS information
cat /proc/cpuinfo                   # CPU information

# Package information
rpm -qi package_name                # Red Hat package info
rpm -qa                             # All installed packages
rpm -ql package_name                # Files in package
dpkg -l                             # Debian packages (if present)

# System logs
journalctl                          # System journal
journalctl -u service.service       # Logs for service
tail -f /var/log/messages           # Follow system log
tail -f /var/log/auth.log           # Authentication log
```

---

## Lab Exercises & Practice

### Exercise 1: Command Syntax & Shells

```bash
# Task 1: Navigate and view system
pwd
cd ~
ls -la
cd /etc
pwd

# Task 2: Use command history
history
!ls                                 # Repeat ls command
Ctrl+R                              # Search history

# Task 3: Get help
ls --help
man ls
whatis ls
```

### Exercise 2: I/O Redirection

```bash
# Task 1: Output redirection
ls > files.txt                      # Save listing to file
cat files.txt                       # View saved listing
ls /nonexistent 2> errors.txt       # Capture error
cat errors.txt                      # View error

# Task 2: Input redirection
sort < unsorted.txt > sorted.txt
cat << EOF > document.txt
This is line 1
This is line 2
EOF

# Task 3: Pipes
ls | wc -l                          # Count files
cat files.txt | grep "etc"          # Filter output
ps aux | grep "bash" | wc -l
```

### Exercise 3: grep & Regular Expressions

```bash
# Task 1: Basic grep
grep "root" /etc/passwd
grep -c "nologin" /etc/passwd
grep -n "bash" /etc/passwd

# Task 2: Exclude lines
grep -v "^#" /etc/ssh/sshd_config
grep -v "^$" config.txt             # Exclude blank lines

# Task 3: Regular expressions
grep "^[a-z]" /etc/passwd           # Start with lowercase
grep "[0-9]" file.txt               # Contains digit
grep "^\." file.txt                 # Starts with dot
grep -E "^(root|admin)" /etc/passwd
```

### Exercise 4: SSH & Remote Access

```bash
# Task 1: Generate SSH keys
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# Task 2: Copy public key
ssh-copy-id -i ~/.ssh/id_rsa.pub user@remote-server
# Or manually: cat ~/.ssh/id_rsa.pub | ssh user@host "cat >> ~/.ssh/authorized_keys"

# Task 3: Test SSH
ssh user@remote-server "hostname"
ssh -v user@remote-server           # Verbose output
ssh root@192.168.1.100 "uptime"

# Task 4: File transfer
scp file.txt user@server:/tmp/
scp user@server:/etc/hosts ./
scp -r /data user@backup-server:/backups/
```

### Exercise 5: User Management

```bash
# Task 1: User information
whoami
id
id -u
groups

# Task 2: Switch users
su - testuser
sudo -u testuser whoami
sudo -i                             # Root shell

# Task 3: Check sudo access
sudo -l
sudo systemctl status httpd

# Task 4: View login history
who
w
last
```

### Exercise 6: File Archiving & Compression

```bash
# Task 1: Create archives
tar -cf archive.tar file1 file2 dir1
tar -czf archive.tar.gz file1 file2
tar -cjf archive.tar.bz2 file1

# Task 2: List archive contents
tar -tf archive.tar
tar -tzf archive.tar.gz
tar -tvf archive.tar

# Task 3: Extract archives
tar -xf archive.tar
tar -xzf archive.tar.gz -C /tmp/
tar -xjf archive.tar.bz2

# Task 4: Compression utilities
gzip file.txt                       # Creates file.txt.gz
gunzip file.txt.gz                  # Creates file.txt
bzip2 largefile                     # Creates largefile.bz2
bunzip2 largefile.bz2
```

### Exercise 7: File Editing

```bash
# Task 1: Create text files
cat > newfile.txt << EOF
Line 1: First line
Line 2: Second line
Line 3: Third line
EOF

echo "New content" > file2.txt
printf "Test\nLines\n" > file3.txt

# Task 2: Edit with vim
vim newfile.txt
# Press i to insert
# Type content
# Press ESC
# Type :wq to save and exit

# Task 3: Edit with nano
nano newfile.txt
# Type content
# Ctrl+X to exit
# Press Y to save

# Task 4: View files
cat newfile.txt
head newfile.txt
tail newfile.txt
nl newfile.txt
```

### Exercise 8: File Operations

```bash
# Task 1: Create/copy/move
mkdir testdir
touch testdir/file1.txt testdir/file2.txt
cp testdir/file1.txt testdir/file1_backup.txt
mv testdir/file2.txt testdir/file2_renamed.txt

# Task 2: Directory operations
mkdir -p path/to/nested/directory
cp -r testdir backup_testdir
rm testdir/file1_backup.txt

# Task 3: Globbing patterns
ls *.txt
rm *.tmp
cp *.log /backup/
ls [0-9]*
```

### Exercise 9: Links

```bash
# Task 1: Create soft links
ln -s /etc/hostname ~/hostname_link
ln -s /var/log ~/logs_link
ls -la ~/hostname_link
readlink ~/hostname_link

# Task 2: Create hard links
cp file.txt original.txt
ln original.txt hardlink.txt
ls -i original.txt hardlink.txt    # Same inode

# Task 3: Working with links
cat ~/hostname_link                 # Works through link
rm ~/hostname_link                  # Deletes link, not original
rm hardlink.txt                     # Delete hard link
cat original.txt                    # Original still exists
```

### Exercise 10: Permissions

```bash
# Task 1: View permissions
ls -l file.txt
stat file.txt

# Task 2: Change permissions (symbolic)
chmod u+x script.sh                 # User execute
chmod g+r file.txt                  # Group read
chmod o-w file.txt                  # Other no write
chmod a-x file.txt                  # All no execute

# Task 3: Change permissions (numeric)
chmod 755 script.sh                 # rwxr-xr-x
chmod 644 document.txt              # rw-r--r--
chmod 700 secret.txt                # rw-------
chmod 600 config.txt

# Task 4: Change ownership
sudo chown newuser file.txt
sudo chown newuser:newgroup file.txt
sudo chown -R newuser:newgroup /path/to/dir

# Task 5: Default permissions (umask)
umask                               # View current
umask 022                           # Set umask
# Files: 666-022=644, Dirs: 777-022=755
```

### Exercise 11: Documentation

```bash
# Task 1: Man pages
man chmod
man ls
man tar
man grep
man ssh

# Task 2: Info pages
info coreutils
info gzip

# Task 3: System documentation
ls /usr/share/doc/
cat /usr/share/doc/bash/README
ls /usr/share/doc/openssh-clients/

# Task 4: Help commands
whatis cat
whereis bash
which python
help cd
```

### Exercise 12: Integration Lab

```bash
# Complete task combining multiple skills

# 1. Create directory structure
mkdir -p ~/rhcsa_lab/backup
cd ~/rhcsa_lab

# 2. Create sample files
for i in {1..5}; do echo "Sample $i" > file$i.txt; done

# 3. View files
ls -l
grep "Sample" *.txt

# 4. Archive files
tar -czf backup/files_$(date +%Y%m%d).tar.gz *.txt

# 5. Create links
ln -s backup/files*.tar.gz latest_backup
ls -la latest_backup

# 6. Change permissions
chmod 750 ~/rhcsa_lab
chmod 644 ~/rhcsa_lab/*.txt
chmod 755 ~/rhcsa_lab/backup

# 7. Verify
ls -la
tar -tzf backup/*.tar.gz
ls -la latest_backup
```

---

## Summary of Key Commands

### Navigation & Shell
```
pwd, cd, ls, cp, mv, rm, mkdir, rmdir, touch
```

### Text Processing
```
cat, head, tail, grep, sed, awk, wc, sort, uniq
```

### Redirection & Pipes
```
>, >>, <, |, 2>, &>, tee
```

### Archives & Compression
```
tar, gzip, bzip2, xz, gunzip, bunzip2, unxz
```

### Users & Permissions
```
whoami, id, su, sudo, chmod, chown, passwd, users, groups
```

### SSH & Remote
```
ssh, scp, sftp, ssh-keygen, ssh-copy-id
```

### File Information
```
file, stat, ls, du, wc, find, locate, which
```

### Editors
```
vim, nano, cat, echo, sed
```

### Documentation
```
man, info, whatis, whereis, help
```

---

## Exam Tips

1. **Practice typing commands** - Speed matters in exam
2. **Understand options** - Know what `-l`, `-r`, `-f` mean for each command
3. **Know error redirection** - Redirect stderr correctly
4. **Master grep patterns** - Regex is heavily tested
5. **SSH key setup** - Practice password-less authentication
6. **Permissions matter** - Know octal and symbolic notation
7. **Archive formats** - Know when to use tar, gzip, bzip2
8. **Text editors** - Be comfortable with vim and nano
9. **File system navigation** - Know directory structure
10. **Use documentation** - `man`, `--help`, and `/usr/share/doc/`

---

## Quick Reference Card

| Task | Command |
|------|---------|
| Redirect to file | `> file` |
| Append to file | `>> file` |
| Redirect error | `2> file` |
| Pipe output | `\| command` |
| Search text | `grep pattern file` |
| Replace text | `sed 's/old/new/' file` |
| Compress | `tar -czf file.tar.gz dir` |
| Decompress | `tar -xzf file.tar.gz` |
| SSH connect | `ssh user@host` |
| Copy file | `scp local user@host:remote` |
| Change perms | `chmod 755 file` |
| View manual | `man command` |
| Find files | `find / -name file` |
| Count lines | `wc -l file` |
| Sort data | `sort file` |

---

## Practice Environment Setup

For best exam preparation:

1. **Use a Linux VM** (VirtualBox, VMware, AWS)
2. **Install required tools**: vim, nano, tar, gzip, openssh
3. **Create test scenarios** based on objectives
4. **Time yourself** on exercises (exam is 2.5 hours for ~10 tasks)
5. **Review errors** - understand why commands fail
6. **Practice without GUI** - terminal only
7. **Read man pages** - understand documentation
8. **Combine skills** - complex tasks using multiple commands

Good luck with your RHCSA exam preparation!
