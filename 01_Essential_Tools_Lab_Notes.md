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

The shell prompt is your interface to the Linux system. Understanding its components helps you navigate efficiently.

```bash
# Basic prompt structure
[user@hostname directory]$        # Regular user prompt
[user@hostname directory]#        # Root user prompt (# indicates root)
```

**Prompt Components:**
- `user`: Currently logged-in username
- `hostname`: Name of the computer
- `directory`: Current working directory (often shortened to just the folder name)
- `$`: Regular user indicator
- `#`: Root (superuser) indicator

### Command Syntax Fundamentals

All Linux commands follow a standard syntax pattern:

```bash
# Basic command structure
command [options] [arguments]

# Examples demonstrating proper syntax:
ls -l /home                     # command: ls, option: -l, argument: /home
grep -i "pattern" file.txt      # command: grep, option: -i, args: pattern and file
cp -r source destination        # command: cp, option: -r, args: source and destination
```

### Key Command Rules & Conventions

```bash
# 1. Commands are case-sensitive
ls                              # Works - lists files
LS                              # Doesn't work - not recognized
Ls                              # Doesn't work - not recognized

# 2. Options can be short or long
# Short options (single letter prefixed with -)
ls -l                           # Long format
grep -i pattern file            # Case-insensitive

# Long options (usually multiple characters prefixed with --)
ls --long                       # Same as ls -l
grep --ignore-case pattern file # Same as grep -i

# 3. Multiple short options can be combined
ls -l -a                        # List format, show hidden files
ls -la                          # Same effect - combined
tar -c -z -v -f file.tar.gz dir # Create, zip, verbose, file
tar -czvf file.tar.gz dir       # Combined - same effect

# 4. Arguments typically come after options
grep pattern file.txt           # Correct - pattern then file
grep file.txt pattern           # Incorrect - wrong order

# 5. Use -- to separate options from arguments containing dashes
grep -- "-pattern" file.txt     # Searches for literal "-pattern"
ls -- -special-file             # Lists file starting with dash

# 6. Quoting handles special characters
echo "Hello World"              # Double quotes preserve spaces
echo 'Hello World'              # Single quotes do the same
echo Hello\ World               # Backslash escapes the space
```

### Common Command Patterns

```bash
# Getting help about commands
command --help                  # Brief help text
man command                     # Full manual page
command -h                      # Alternative help flag
info command                    # GNU info documentation
whatis command                  # One-line command description
```

### Sequential Command Execution

```bash
# Execute commands one after another regardless of success
command1; command2              # Command2 runs even if command1 fails
ls /etc; echo "Done"            # Both execute

# Conditional execution - next only if previous succeeds
command1 && command2            # Command2 runs only if command1 succeeds
cd /tmp && ls                   # List only if cd succeeds
mkdir newdir && cd newdir       # Create and enter directory

# Conditional execution - next only if previous fails
command1 || command2            # Command2 runs only if command1 fails
cd /tmp || echo "Failed"        # Echo only if cd fails
test -f file.txt || echo "File not found"

# Combining conditions
command1 && command2 || command3  # Run 2 if 1 succeeds, else run 3
cd /tmp && ls || pwd            # Try cd/ls, or show current dir

# Running in background
command &                       # Run command in background
sleep 100 &                     # Background: returns shell prompt immediately
sleep 100                       # Foreground: shell waits for completion

# Background job management
jobs                            # List all background jobs
jobs -l                         # List with process IDs
fg %1                           # Bring job 1 to foreground
bg %1                           # Resume job 1 in background (if stopped)
kill %1                         # Terminate job 1
```

### Command History & Recall

```bash
# View command history
history                         # Show all history (usually last 1000 commands)
history 10                      # Show last 10 commands
history | grep "grep"           # Find commands containing "grep"

# Execute from history
!5                              # Execute command number 5
!!                              # Execute last command exactly
!ls                             # Execute last command starting with "ls"
!?pattern                       # Execute last command containing "pattern"
!-1                             # Execute last command (same as !!)

# History expansion and substitution
^old^new                        # Replace "old" with "new" in last command
# Example: If last was "cat file.txt"
# ^file^document changes it to "cat document.txt"

# Interactive history search
Ctrl+R                          # Search history backward (type to search)
Ctrl+S                          # Search history forward
Ctrl+R again                    # Move to previous match
Enter                           # Execute found command

# History configuration (~/.bashrc)
export HISTSIZE=1000            # Number of history entries in memory
export HISTFILESIZE=2000        # Number of lines in history file
export HISTTIMEFORMAT="%F %T "  # Add timestamps to history
```

### Useful Keyboard Shortcuts

```bash
# Line editing
Ctrl+A                          # Move cursor to start of line
Ctrl+E                          # Move cursor to end of line
Ctrl+K                          # Delete from cursor to end of line
Ctrl+U                          # Delete from cursor to start of line
Ctrl+L                          # Clear screen (like 'clear' command)
Ctrl+C                          # Interrupt/stop current command
Ctrl+D                          # Send EOF (end input) or exit shell
Ctrl+Z                          # Suspend current job
Ctrl+R                          # Search command history
Ctrl+V                          # Insert next character literally
Alt+D                           # Delete word forward
Alt+Backspace                   # Delete word backward
```

### Command Prompt Navigation

```bash
# Checking current location
pwd                             # Print Working Directory - show full path
echo $PWD                       # Alternative: show value of PWD variable

# Changing directories
cd /path/to/directory           # Change to absolute path
cd relative/path                # Change to relative path
cd ..                           # Go to parent directory
cd ../..                        # Go up two levels
cd ~                            # Go to home directory (~/ = home)
cd /                            # Go to root of filesystem
cd -                            # Go to previous directory
cd ~username                    # Go to another user's home

# Viewing current directory
ls                              # List contents of current directory
ls -l                           # Long format listing
pwd                             # Show full path to current directory
```

### Navigating Directory Structure

```bash
# Understanding paths
/absolute/path                  # Path starting with / (from root)
relative/path                   # Path from current location
./current/file                  # ./ explicitly means current directory
../parent/file                  # ../ means parent directory

# Efficient navigation
pushd /another/dir              # Change dir and save previous location
popd                            # Return to saved location
dirs                            # Show directory stack

# Checking if paths exist
test -d /path && echo "exists" || echo "doesn't exist"
[ -f /path/file ] && echo "file exists"
```

---

## Input-Output Redirection

I/O redirection is fundamental to Linux power users. It controls where commands get input and where they send output.

### Understanding Standard Streams

Every Linux process has three standard data streams:

```
stdin  (File Descriptor 0)  - Standard input (keyboard by default)
stdout (File Descriptor 1)  - Standard output (terminal/screen by default)
stderr (File Descriptor 2)  - Standard error (terminal/screen by default)
```

**Real-world analogy:**
- stdin: Where the command listens for data (like listening to user input)
- stdout: Where the command sends results (what you see on screen)
- stderr: Where the command sends error messages (also on screen usually)

### Output Redirection Operators

#### Redirecting stdout

```bash
# Redirect stdout to file (overwrite - CAREFUL!)
command > file.txt
ls > files.txt                  # List goes to file, not screen
echo "test" > output.txt        # "test" written to file, replacing contents

# Append stdout to file (add to end)
command >> file.txt
echo "line 1" > file.txt
echo "line 2" >> file.txt        # Now file has both lines
cat file.txt
# Output: line 1
#         line 2

# Practical examples
history > command_history.txt   # Save command history to file
ls -la >> file_listing.txt      # Append directory listing to file
ps aux > running_processes.txt  # Save running processes
```

#### Redirecting stderr

```bash
# Redirect stderr to file (errors only)
command 2> errors.txt
grep "pattern" *.txt 2> errors.txt  # Errors go to file, matches to screen

# Append stderr to file
command 2>> errors.txt
find / -name "test" 2>> errors.txt  # Append errors

# Practical examples
ls /nonexistent 2> error.log    # Error message in file, not on screen
grep -r "pattern" / 2> errors.txt  # Recursive search, errors logged
```

#### Redirecting Both stdout and stderr

```bash
# Both to same file (overwrite)
command &> output.txt
command > output.txt 2>&1        # Alternative syntax
ls /nonexistent &> all_output.txt

# Both to same file (append)
command &>> output.txt
command >> output.txt 2>&1       # Alternative syntax

# Practical examples
./script.sh &> script_output.txt  # Capture everything
find / -name "*" &> full_output.txt  # All output and errors

# Complex redirection
command > good_output.txt 2> error_output.txt  # Separate files
# stdout goes to good_output.txt
# stderr goes to error_output.txt
```

#### Special Redirection Cases

```bash
# Discard output completely
command > /dev/null             # Discard stdout
command 2> /dev/null            # Discard stderr
command &> /dev/null            # Discard both
ls /nonexistent > /dev/null 2>&1  # Silent - no output at all

# Check if command succeeds without output
grep -q "pattern" file.txt      # -q (quiet) suppresses output
test -f file.txt > /dev/null && echo "exists"

# Copy output to file AND display
command | tee output.txt
ls | tee file_list.txt          # See list AND save it
ps aux | tee processes.txt      # Show AND save running processes

# Append with tee
command | tee -a output.txt     # Append instead of overwrite

# Save to multiple files
command | tee file1.txt file2.txt file3.txt
```

### Input Redirection

```bash
# Use file as input (instead of keyboard)
command < file.txt
sort < unsorted_list.txt        # Sort reads from file instead of stdin
wc -l < data.txt                # Count lines in file

# Practical use
grep "search" < large_file.txt  # Search in file content
cat < file.txt                  # Display file content
```

### Here Documents (Multi-line Input)

```bash
# Create multi-line input to command
cat << EOF
This is line 1
This is line 2
This is line 3
EOF

# Practical: Create configuration file
cat > /tmp/config.txt << 'EOF'
# Configuration file
SERVER_HOST=localhost
SERVER_PORT=8080
DEBUG=true
EOF

# Practical: Create script
cat > my_script.sh << 'EOF'
#!/bin/bash
echo "This is my script"
echo "It has multiple lines"
EOF
chmod +x my_script.sh

# Pass heredoc to command
sort << EOF
zebra
apple
banana
EOF
# Output will be sorted: apple, banana, zebra

# Using variables in heredoc
NAME="John"
cat << EOF
Hello $NAME
Your age is: $AGE
EOF

# Prevent variable expansion with 'EOF' in quotes
cat << 'EOF'
This won't expand: $NAME
And this won't: $(whoami)
EOF
```

### Here Strings (Single-line Input)

```bash
# Pass string as input (<<<)
grep "pattern" <<< "some text here"
wc -w <<< "one two three"       # Outputs: 3

# Practical examples
tr 'a-z' 'A-Z' <<< "hello"      # Convert to uppercase
cat <<< "This is a line"        # Display string
```

### Pipes: Connecting Commands

Pipes connect the stdout of one command to the stdin of another, creating powerful data processing chains.

```bash
# Basic pipe syntax
command1 | command2

# Examples - processing commands together
cat file.txt | grep "error"     # Show lines containing "error"
ls | wc -l                      # Count number of files
ps aux | grep "bash"            # Find bash processes
cat file.txt | head -5          # Show first 5 lines

# Chaining multiple pipes
cat data.txt | grep "pattern" | wc -l  # Count matching lines
ps aux | grep python | grep -v grep    # Find python, exclude grep itself
cat file.txt | sort | uniq              # Sort and remove duplicates

# Complex examples
# Get top 3 largest files
ls -lS | head -4 | awk '{print $9, $5}'

# Find most frequently used commands in history
history | awk '{print $2}' | sort | uniq -c | sort -rn | head -10

# Check system load and memory
ps aux | wc -l                  # Process count
free | grep Mem                 # Memory information
df -h | grep /                  # Disk usage for root
```

### Advanced Pipe Techniques

```bash
# Using tee to branch output
command | tee file.txt          # Display AND save to file
ls | tee file_list.txt          # Save directory listing while viewing

# Save to multiple files
command | tee file1.txt file2.txt file3.txt

# Append instead of overwrite
command | tee -a output.txt

# Ignore interrupts
command | tee -i output.txt

# Connect with less for viewing large output
command | less
ps aux | less                   # Scroll through processes

# Connect with more for viewing
command | more

# Combining multiple commands in pipe
cat file.txt | grep "error" | cut -d: -f1 | sort | uniq
# Gets file, finds "error" lines, extracts first column, sorts, removes duplicates
```

### Practical I/O Redirection Examples

```bash
# Log both output and errors
./script.sh > output.log 2>&1 &
# Run script in background, save everything to output.log

# Monitor log file in real-time
tail -f /var/log/messages       # Follow log as it grows

# Search and redirect results
grep "error" /var/log/* 2>/dev/null > errors_summary.txt
# Find all errors, skip permission errors, save results

# Create backup with logging
cp -r /home/user /backup/user 2> backup_errors.log
echo "Backup complete at $(date)" >> backup.log

# Complex filtering
find . -name "*.txt" -type f | wc -l
# Count all text files in current directory and subdirectories

# Data processing chain
cat data.csv | cut -d',' -f1,3 | sort | uniq | tee summary.txt
# Extract columns, sort, remove duplicates, save and display

# Error handling in scripts
if ! grep -q "pattern" file.txt 2>/dev/null; then
    echo "Pattern not found" >&2  # Error message to stderr
    exit 1
fi
```

### Common Redirection Mistakes

```bash
# WRONG: Overwriting when appending intended
command > file.txt              # Overwrites!
command > file.txt              # Overwrites again!

# CORRECT: Use append
command >> file.txt             # Adds to file
command >> file.txt             # Adds more

# WRONG: Missing file descriptor number
command 2 error.txt             # Doesn't redirect stderr!

# CORRECT: Use proper syntax
command 2> error.txt            # Redirects stderr properly

# WRONG: Piping stderr
command 2 | grep pattern        # Doesn't work - error not in pipe

# CORRECT: Redirect stderr first
command 2>&1 | grep pattern     # Now both stdout and stderr pipe

# WRONG: Forgetting redirection
command                         # Output to screen (usually not captured)

# CORRECT: Redirect for capture
command > output.txt            # Output saved to file
```

---

## Text Analysis with grep & Regular Expressions

grep is one of the most powerful text processing tools in Linux. Combined with regular expressions, it becomes indispensable for system administration and troubleshooting.

### grep Fundamentals

#### Basic Syntax

```bash
# Basic grep usage
grep [OPTIONS] PATTERN [FILE...]

# Search for pattern in single file
grep "search_term" file.txt
grep "error" /var/log/messages

# Search multiple files
grep "pattern" file1.txt file2.txt file3.txt
grep "root" /etc/passwd /etc/group

# Search all files in directory
grep "pattern" /path/to/directory/*

# Recursive search in directories
grep -r "pattern" /path/to/directory
grep -r "TODO" ~/projects/       # Find all TODOs in projects

# Search stdin (from pipe)
cat file.txt | grep "pattern"
ps aux | grep "httpd"            # Find httpd processes
```

### Common grep Options Explained

```bash
# Case-insensitive matching
grep -i "ERROR" log.txt          # Matches: error, ERROR, Error, etc.
grep -i "root" /etc/passwd       # Case doesn't matter

# Invert match (show NON-matching lines)
grep -v "#" config.txt           # Show all non-comment lines
grep -v "^$" file.txt            # Exclude blank lines
grep -v "nologin" /etc/passwd    # Show users with real shells

# Count matching lines
grep -c "error" log.txt          # Shows: 42 (if 42 matches)
grep -c "pattern" *.txt          # Count in each file

# Show line numbers
grep -n "error" log.txt          # Shows: 5:error message
grep -n "root" /etc/passwd       # Shows line numbers with content

# Show only filenames (no content)
grep -l "pattern" *.txt          # Shows: file1.txt file2.txt
grep -l "TODO" ~/projects/*      # Which files have TODOs?

# Show filenames WITHOUT matches
grep -L "pattern" *.txt          # Files NOT containing pattern

# Show only the matching part
grep -o "[0-9]*\.[0-9]*" file.txt  # Extract IP addresses
grep -o "user[0-9]*" file.txt    # Extract matching portions

# Match whole words only
grep -w "the" file.txt           # "the" but not "there" or "theft"
grep -w "root" /etc/passwd       # Exact word "root"

# Match entire lines only
grep -x "exact line" file.txt    # Full line must match exactly

# Show context around matches
grep -A 2 "error" log.txt        # 2 lines AFTER match (After)
grep -B 2 "error" log.txt        # 2 lines BEFORE match (Before)
grep -C 3 "error" log.txt        # 3 lines both sides (Context)

# Recursive search
grep -r "pattern" /directory     # Search all files, all subdirs
grep -r "function_name" /home/user/code/  # Search code

# Filter by file type
grep -r "pattern" /directory --include="*.py"
grep -r "TODO" . --include="*.js" --include="*.py"

# Combine multiple patterns
grep -e "error" -e "warning" log.txt
grep "pattern1\|pattern2" file.txt  # Use alternation

# Quiet mode (only exit code, no output)
grep -q "pattern" file.txt       # Returns true if found, false if not
if grep -q "found" file.txt; then
    echo "Pattern found"
fi
```

### Regular Expressions with grep

Regular expressions are patterns used to match text. They're essential for advanced searching.

#### Basic Regular Expression Characters

```bash
# Literal characters
grep "hello" file.txt           # Exact match for "hello"
grep "cat" file.txt             # Matches: cat, concatenate, scatter

# . (dot) - matches ANY single character
grep "c.t" file.txt             # Matches: cat, cut, cot, c9t, c t
grep "..." file.txt             # Matches any 3 characters

# ^ (caret) - start of line
grep "^error" log.txt           # "error" at start of line
grep "^[0-9]" file.txt          # Lines starting with digit
grep "^$" file.txt              # Blank lines (empty lines)

# $ (dollar) - end of line
grep "error$" log.txt           # "error" at end of line
grep "\.txt$" file.txt          # Lines ending with .txt
grep "[0-9]$" file.txt          # Lines ending with digit

# [] (character class) - matches ANY character inside
grep "[aeiou]" file.txt         # Lines with vowels
grep "[0-9]" file.txt           # Lines with digits
grep "[ABC]" file.txt           # A, B, or C

# [^] (negated class) - matches ANY character NOT inside
grep "[^0-9]" file.txt          # Non-digit characters
grep "[^aeiou]" file.txt        # Non-vowels

# - (range) within brackets
grep "[a-z]" file.txt           # Any lowercase letter
grep "[A-Z]" file.txt           # Any uppercase letter
grep "[0-9]" file.txt           # Any digit
grep "[a-zA-Z0-9]" file.txt     # Letters and digits
grep "[a-zA-Z0-9_]" file.txt    # Alphanumeric and underscore

# \ (backslash) - escape special characters
grep "\." file.txt              # Literal dot (not any character)
grep "\.txt$" file.txt          # Files ending with .txt
grep "\$" file.txt              # Dollar sign
grep "\*" file.txt              # Asterisk

# Practical examples
grep "^root" /etc/passwd        # Root user line
grep "bash$" /etc/passwd        # Lines ending with bash
grep "^[a-z]*" file.txt         # Lines starting with letters
grep "[0-9][0-9][0-9]" file.txt # Any three-digit number
```

#### Extended Regular Expressions

Extended regex requires `grep -E` or `egrep`. It adds more features:

```bash
# Use grep -E for extended regex (or just egrep)
grep -E "pattern" file.txt
egrep "pattern" file.txt        # Same as grep -E

# + (plus) - one or more of previous
grep -E "a+" file.txt           # "a", "aa", "aaa", etc.
grep -E "0+" file.txt           # One or more zeros

# ? (question mark) - zero or one of previous
grep -E "colou?r" file.txt      # "color" or "colour"
grep -E "s?" file.txt           # With or without 's'

# * (asterisk) - zero or more of previous
grep -E "a*" file.txt           # "", "a", "aa", "aaa", etc.

# {} (braces) - specific count
grep -E "[0-9]{3}" file.txt     # Exactly 3 digits
grep -E "[0-9]{2,4}" file.txt   # 2 to 4 digits
grep -E "[0-9]{2,}" file.txt    # 2 or more digits

# | (pipe/OR) - alternatives
grep -E "cat|dog" file.txt      # "cat" or "dog"
grep -E "error|warning|critical" log.txt

# () (parentheses) - grouping
grep -E "(ab)+" file.txt        # "ab", "abab", "ababab", etc.
grep -E "^(root|admin)" file.txt  # Lines starting with root or admin

# \< and \> - word boundaries
grep "\berror\b" file.txt       # Exact word "error"
grep -E "\berror\b" file.txt
```

### Practical grep Examples

#### System Administration Examples

```bash
# Find all users with bash shell
grep "bash$" /etc/passwd
# Output: root:x:0:0:root:/root:/bin/bash
#         user1:x:1000:1000:User One:/home/user1:/bin/bash

# Find all users WITHOUT shells (system accounts)
grep "nologin$" /etc/passwd
# Shows service accounts that can't login

# Find comments in configuration files
grep "^#" /etc/ssh/sshd_config  # Show comments
grep "^[^#]" /etc/ssh/sshd_config  # Show non-comments

# Count different shell types
grep -o "bin/.*$" /etc/passwd | sort | uniq -c

# Find blank lines and their count
grep -c "^$" file.txt           # Count of blank lines

# Find lines that contain IP addresses
grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" file.txt
# Example: 192.168.1.100

# Find email addresses
grep -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" file.txt

# Find phone numbers (XXX-XXX-XXXX format)
grep -E "[0-9]{3}-[0-9]{3}-[0-9]{4}" phonelist.txt
```

#### Log File Analysis

```bash
# Find all errors in log
grep -i "error" /var/log/messages

# Find critical errors with context
grep -B 2 -A 2 "CRITICAL" /var/log/messages

# Count errors by type
grep "error" /var/log/messages | cut -d: -f1 | sort | uniq -c

# Find failed login attempts
grep "Failed" /var/log/auth.log

# Find sudo usage
grep "sudo:" /var/log/auth.log

# Most recent errors
tail -50 /var/log/messages | grep error

# Find specific time range (if timestamps present)
grep "2024-01-15" /var/log/messages
grep "2024-01-15 14:" /var/log/messages  # Specific hour
```

#### Multi-file Searching

```bash
# Search in all config files
grep "ServerName" /etc/apache2/*.conf

# Search in all text files recursively
grep -r "function_name" /home/user/code/ --include="*.py"

# Find which files don't contain a pattern
grep -L "import" /home/user/code/*.py

# Find pattern and show which files contain it
grep -l "error" /var/log/*

# Show filename with matching lines
grep "pattern" /etc/*.conf     # Already shows filenames
```

#### Advanced Filtering

```bash
# Exclude certain patterns
grep "error" log.txt | grep -v "test"  # Errors but not in test context

# Case variations
grep -E -i "ERROR|WARNING" log.txt

# Match at specific positions
grep "^error" log.txt           # Start of line
grep "error$" log.txt           # End of line
grep "^ " log.txt               # Indented lines

# Empty or blank lines
grep -c "^$" file.txt           # Count blank lines
grep "^$" file.txt              # Show blank lines
grep -v "^$" file.txt           # Show non-blank lines
```

### grep Performance Tips

```bash
# Use -q for yes/no checks (stops after first match)
grep -q "pattern" file.txt && echo "Found" || echo "Not found"

# Use anchors (^ and $) to narrow search
grep "^error" file.txt          # Faster - narrows scope

# Use character classes instead of alternation
grep -E "[0-9a-f]" file.txt     # Better than [0-9a-f]|[0-9a-f]|...

# Use fixed strings for literal searching
grep -F ".txt" file.txt         # Don't treat . as regex

# Exclude directories with -d
grep -r "pattern" /directory -d skip  # Don't search directories
```

---

## Remote Access with SSH

SSH (Secure Shell) is essential for RHCSA exam and real-world system administration. It provides secure encrypted communication with remote systems.

### SSH Fundamentals

SSH provides three main services:
1. **Remote login** - Access shell on remote system
2. **Remote command execution** - Run commands without interactive session
3. **File transfer** - Copy files securely (scp, sftp)

### Basic SSH Connection

```bash
# Connect to remote system
ssh username@hostname
ssh username@192.168.1.100
ssh user@example.com

# Connect with non-standard port
ssh -p 2222 user@example.com    # Connect to port 2222

# Connect as different user
ssh -l username hostname
ssh -l admin 192.168.1.100      # Alternative syntax

# Connect and execute command
ssh user@host "whoami"          # Shows remote username
ssh user@host "ls -la"          # List remote directory
ssh user@host "systemctl status httpd"  # Check service status

# Connect with command (non-interactive)
ssh user@host "uptime"          # Runs uptime, then exits

# Multiple commands on remote
ssh user@host "cd /etc && grep root passwd"
ssh user@host "apt update && apt upgrade"

# Using variables
REMOTE_HOST="192.168.1.100"
ssh user@$REMOTE_HOST "hostname"
```

### SSH Options

```bash
# Port specification
ssh -p PORT user@host           # Connect to specific port
ssh -p 2222 admin@server.com

# Specify identity file (private key)
ssh -i ~/.ssh/id_rsa user@host
ssh -i ~/.ssh/custom_key admin@server.com

# Verbose output (useful for troubleshooting)
ssh -v user@host                # Single verbose
ssh -vv user@host               # Very verbose
ssh -vvv user@host              # Maximum verbose

# Quiet mode
ssh -q user@host                # Suppress warnings

# X11 forwarding (GUI applications)
ssh -X user@host                # Enable X11 forwarding
ssh -Y user@host                # Trusted X11 forwarding

# Port forwarding (tunneling)
ssh -L LOCAL_PORT:REMOTE_HOST:REMOTE_PORT user@JUMP_HOST
ssh -L 3306:localhost:3306 user@remote-server  # Port forward

# Remote port forwarding
ssh -R REMOTE_PORT:LOCAL_HOST:LOCAL_PORT user@REMOTE_HOST
ssh -R 8080:localhost:8080 user@remote-server

# Background execution
ssh -f user@host "long_running_command"  # Runs in background
ssh -f -N -L 3306:localhost:3306 user@remote  # Just port forward

# No terminal allocation
ssh -T user@host "command"      # Run command without TTY
ssh -t user@host "command"      # Force pseudo-terminal

# Escape from hung SSH session
# Type: Enter, ~, . (dot)
# Type Enter, then tilde, then dot to disconnect hung SSH
```

### SSH Configuration File

SSH configuration goes in `~/.ssh/config` for ease of use.

```bash
# Location: ~/.ssh/config
# Create or edit this file for convenient SSH access

# Example ~/.ssh/config
Host webserver
    Hostname 192.168.1.100
    User admin
    Port 2222
    IdentityFile ~/.ssh/keys/admin_key

Host devserver
    Hostname dev.example.com
    User developer
    Port 22
    IdentityFile ~/.ssh/dev_key
    ServerAliveInterval 60
    ConnectTimeout 10

Host db-*
    User postgres
    Port 5432
    IdentityFile ~/.ssh/postgres_key
    ServerAliveInterval 30

Host *
    ServerAliveInterval 300
    ServerAliveCountMax 2
    Compression yes
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%h-%p-%r
    ControlPersist 600

# Usage after configuration:
ssh webserver              # Connects to 192.168.1.100:2222 as admin
ssh devserver              # Uses devserver configuration
ssh db-01                  # Uses db-* pattern config
```

### SSH Key-Based Authentication

Key-based authentication is more secure than passwords.

#### Generating SSH Keys

```bash
# Generate RSA key pair (traditional)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
# -t rsa: RSA algorithm
# -b 4096: 4096-bit key (strong)
# -f: output filename
# -N "": no passphrase ("" means empty)

# Generate with passphrase (more secure)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "your_passphrase"

# Generate modern Ed25519 key (recommended)
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""

# Generate key with specific name
ssh-keygen -t rsa -b 4096 -f ~/.ssh/work_key -N ""

# Generate with comment (for identification)
ssh-keygen -t rsa -b 4096 -C "user@hostname" -f ~/.ssh/id_rsa
```

#### Key Files and Permissions

```bash
# Key locations and what they are
~/.ssh/id_rsa               # Private key - KEEP SECURE!
~/.ssh/id_rsa.pub           # Public key - safe to share
~/.ssh/authorized_keys      # Contains public keys allowed to login
~/.ssh/config               # SSH configuration file
~/.ssh/known_hosts          # Known remote hosts

# Required permissions (VERY IMPORTANT!)
chmod 700 ~/.ssh            # Directory: rwx------
chmod 600 ~/.ssh/id_rsa     # Private key: rw-------
chmod 644 ~/.ssh/id_rsa.pub # Public key: rw-r--r--
chmod 600 ~/.ssh/authorized_keys  # On server: rw-------

# Check current permissions
ls -la ~/.ssh/
# Should show:
# drwx------ for directory
# -rw------- for private key
# -rw-r--r-- for public key

# Fix permissions if needed
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```

#### Copying Public Key to Remote Server

```bash
# Method 1: Using ssh-copy-id (easiest)
ssh-copy-id -i ~/.ssh/id_rsa.pub user@remote-host
ssh-copy-id user@192.168.1.100

# Specify non-standard port
ssh-copy-id -i ~/.ssh/id_rsa.pub -p 2222 user@host

# Method 2: Manual (if ssh-copy-id not available)
# First, copy the key content
cat ~/.ssh/id_rsa.pub

# Then on remote server, append to authorized_keys
ssh user@host
mkdir -p ~/.ssh
cat >> ~/.ssh/authorized_keys << 'EOF'
paste-your-public-key-here
EOF
chmod 600 ~/.ssh/authorized_keys
exit

# Method 3: One-liner
cat ~/.ssh/id_rsa.pub | ssh user@host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

# Verify it works (should not ask for password)
ssh user@host "whoami"
```

#### SSH Agent (Managing Passphrases)

```bash
# Start SSH agent
ssh-agent bash              # Start agent in new bash shell
eval $(ssh-agent)           # Start agent in current shell

# Add key to agent (caches passphrase)
ssh-add ~/.ssh/id_rsa
ssh-add ~/.ssh/id_rsa.pub

# Add key with specific lifetime
ssh-add -t 3600 ~/.ssh/id_rsa  # Valid for 1 hour

# List keys in agent
ssh-add -l                  # List loaded keys
ssh-add -L                  # Show public keys

# Remove key from agent
ssh-add -d ~/.ssh/id_rsa
ssh-add -D                  # Remove all keys

# Check if agent is running
echo $SSH_AGENT_SOCK        # Shows socket if running
ps aux | grep ssh-agent     # Check processes
```

### SCP - Secure Copy

```bash
# Copy file TO remote server
scp local_file user@host:/remote/path/
scp myfile.txt user@192.168.1.100:/tmp/
scp myfile.txt user@host:~/documents/

# Copy file FROM remote server
scp user@host:/remote/file.txt ./local/path/
scp admin@server.com:/etc/hosts ./hosts.backup
scp user@host:~/file.txt .     # To current directory

# Copy directory (recursive)
scp -r /local/directory user@host:/remote/path/
scp -r ~/projects admin@server.com:/home/admin/

# Copy with specific port
scp -P 2222 local_file user@host:/remote/path/  # Note: capital -P

# Copy with verbose output
scp -v local_file user@host:/remote/
scp -v -r ~/projects user@host:/remote/

# Preserve file attributes
scp -p local_file user@host:/remote/  # Preserve times/permissions

# Between two remote hosts
scp -3 user1@host1:/path/file user2@host2:/path/  # Via local

# Practical examples
scp backup.tar.gz admin@backup-server:/backups/
scp -r /var/www/html admin@webserver:/var/www/
scp user@server:/var/log/messages ./server_logs/
```

### SFTP - Secure File Transfer Protocol

```bash
# Start SFTP session
sftp user@host
sftp -P 2222 user@host      # Non-standard port

# SFTP commands (once connected, at sftp> prompt)
ls                          # List remote files
pwd                         # Print working directory (remote)
cd /path                    # Change directory (remote)
lpwd                        # Local print working directory
lls                         # Local list

# Upload files
put localfile               # Upload one file
put -r local_directory      # Upload directory
mput *.txt                  # Upload multiple files

# Download files
get remotefile              # Download one file
get -r remote_directory     # Download directory
mget *.txt                  # Download multiple files

# Directory operations (remote)
mkdir newdir                # Create remote directory
rmdir olddir                # Remove remote directory
rm file.txt                 # Delete remote file

# File operations
rename oldname newname       # Rename remote file
chmod 755 file.sh           # Change permissions
! command                   # Run local command

# Exit SFTP
exit
bye
quit

# One-line SFTP batch (non-interactive)
sftp -b commands.txt user@host
# commands.txt contains SFTP commands

# Example SFTP batch file (commands.txt)
cd /remote/path
lcd /local/path
get important_file.tar.gz
exit
```

### Common SSH Problems & Solutions

```bash
# Problem: "Permission denied (publickey)"
# Solutions:
ssh -vvv user@host          # Check verbose output
ls -la ~/.ssh/              # Verify permissions
ls -la ~/.ssh/authorized_keys

# Ensure server has correct permissions
ssh user@host "chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"

# Problem: "Connection refused"
# Check if SSH running on server
ssh -p 22 -v user@host      # Try standard port
ping host                   # Check if reachable
# On server: systemctl status sshd

# Problem: "Timeout" connecting
# Check firewall/network
ping -c 1 host
telnet host 22              # Check if port open
# Check server firewall: sudo iptables -L

# Problem: "Too many authentication failures"
ssh -i specific_key user@host  # Specify correct key
# Or add to ssh config to use specific key

# Problem: SSH key not working
ssh-keygen -y -f ~/.ssh/id_rsa  # Verify key format
ssh-add ~/.ssh/id_rsa       # Add to agent
# Check remote: grep $(cat ~/.ssh/id_rsa.pub) ~/.ssh/authorized_keys

# Problem: Stuck/Hung SSH session
# Press: Enter, ~, . (dot) in sequence
# Closes the hung connection

# Problem: SSH too slow (compression)
ssh -C user@host            # Enable compression
# In ~/.ssh/config: Compression yes
```

### SSH Best Practices

```bash
# 1. Use key-based authentication (not passwords)
# In /etc/ssh/sshd_config (on server):
PasswordAuthentication no
PubkeyAuthentication yes

# 2. Restrict SSH permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# 3. Use non-standard port (security through obscurity)
# Port 2222  (in sshd_config)

# 4. Disable root login
# PermitRootLogin no  (in sshd_config)

# 5. Restrict users
# AllowUsers user1 user2 user3  (in sshd_config)

# 6. Use SSH config for convenience
# Add hosts to ~/.ssh/config

# 7. Use SSH agent for passphrase management
eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa

# 8. Regularly rotate keys
# Generate new keys every 6-12 months
ssh-keygen -t ed25519

# 9. Backup private keys securely
tar czf ssh_backup.tar.gz ~/.ssh
# Keep in secure location, encrypted

# 10. Monitor SSH access
tail -f /var/log/auth.log   # Watch login attempts
grep "Failed" /var/log/auth.log  # Find failures
```

---

## User Management & Login

Understanding user management is critical for RHCSA exam. It involves creating users, managing groups, and controlling access.

### User Information Commands

```bash
# Show current user
whoami                      # Just the username
echo $USER                  # Alternate method

# Show comprehensive user info
id                          # UID, GID, and groups
id -u                       # Just the UID
id -g                       # Primary GID
id -G                       # All GIDs
id -n                       # Print names instead of numbers
id username                 # Info for specific user

# List all groups
groups                      # Groups for current user
groups username             # Groups for specific user

# View all users
cat /etc/passwd             # All user accounts
cut -d: -f1 /etc/passwd     # Just usernames

# View all groups
cat /etc/group              # All group definitions
grep groupname /etc/group   # Specific group
```

### Switching Users

```bash
# Switch to another user
su username                 # Switch user (keeps current environment)
su - username               # Switch user with their environment
su -                        # Switch to root
su root                     # Alternate root switch

# Run command as different user
su - username -c "command"
su - admin -c "systemctl restart httpd"

# Run command with current environment
su username -c "command"    # Keeps current environment

# Check if switch successful
whoami                      # Verify username
id                          # Verify UID/GID
pwd                         # Show home directory (- loads it)
```

### Using sudo for Privilege Escalation

```bash
# Execute single command as root
sudo command
sudo systemctl restart sshd

# List user's sudo privileges
sudo -l                     # What can I do with sudo?
sudo -l -U username         # What can another user do?

# Run command as specific user
sudo -u username command
sudo -u postgres psql       # Run as postgres user

# Run interactive shell as root
sudo -i                     # Login shell as root (loads environment)
sudo -s                     # Shell as root (keeps environment)

# Run with specific environment variables
sudo -E pip install package # Preserve environment
sudo -E PATH=$PATH npm install  # Keep PATH variable

# Non-interactive sudo (for scripts)
sudo -n command             # Don't prompt for password (if in sudoers)

# Check sudo without running
sudo -l                     # Check permissions
sudo -v                     # Verify sudo access

# Edit sudoers safely
sudo visudo                 # ALWAYS use visudo, never direct edit
sudo visudo -c              # Check syntax only

# Common sudoers entries
# ALL=(ALL) ALL              # Full sudo access
# user1 ALL=/usr/bin/systemctl  # Only systemctl
# %group1 ALL=(ALL) NOPASSWD: ALL  # Group without password
# user2 ALL=/bin/ls, /bin/cat     # Multiple commands
```

### Sudoers File Configuration

```bash
# Edit sudoers file (VERY IMPORTANT: use visudo!)
sudo visudo

# Example sudoers entries:
# User user1 can run any command as any user
user1 ALL=(ALL) ALL

# Group wheel members can run any command without password
%wheel ALL=(ALL) NOPASSWD: ALL

# User admin can only run systemctl commands
admin ALL=/usr/bin/systemctl

# User webadmin can manage Apache without password
webadmin ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart httpd, /usr/bin/systemctl reload httpd

# User can run specific command without password prompt
backupuser ALL=(ALL) NOPASSWD: /usr/bin/tar

# Commands with arguments
user1 ALL=/usr/bin/vi /etc/hosts, /usr/bin/cat /var/log/messages

# Checking sudoers
sudo visudo -c              # Verify syntax
sudo -l                     # Show what you can do
sudo -l -U otheruser        # Show for another user

# Common sudoers mistakes
# WRONG: /etc/sudoers (don't edit directly!)
# RIGHT: sudo visudo (opens in editor)

# WRONG: %sudo ALL=(ALL) AL  (typo!)
# RIGHT: %sudo ALL=(ALL) ALL
```

### User and Group Management (Privileged Operations)

These commands typically require root access.

```bash
# Create new user
useradd username
sudo useradd newuser        # Create basic user

# Create user with specific settings
sudo useradd -u 1005 -g users -s /bin/bash -m -d /home/newuser -c "User Name" newuser
# -u: specific UID
# -g: primary group
# -s: shell
# -m: create home directory
# -d: home directory path
# -c: comment/description

# Delete user
sudo userdel username       # Delete user account
sudo userdel -r username    # Delete user and home directory

# Modify user
sudo usermod -c "New Name" username  # Change comment
sudo usermod -s /bin/bash username   # Change shell
sudo usermod -d /new/home username   # Change home
sudo usermod -aG groupname username  # Add to group (-a: append, -G: groups)

# Create group
sudo groupadd groupname
sudo groupadd -g 1005 newgroup  # With specific GID

# Delete group
sudo groupdel groupname

# Modify group
sudo groupmod -n newname oldname    # Rename group
sudo groupmod -g 1005 groupname     # Change GID

# Add user to group
sudo usermod -aG groupname username # Add user to group

# Remove user from group
# Edit /etc/group directly (or use GUI tools)

# Change user password
passwd                      # Change own password
sudo passwd username        # Change another user's password

# Lock/Unlock user
sudo passwd -l username     # Lock account
sudo passwd -u username     # Unlock account

# Set password to expire
sudo passwd -e username     # Force password change at next login

# View user info
finger username             # User information (if installed)
id username                 # UID, GID, groups
```

### User Information Files

These files contain user and group information:

```bash
# /etc/passwd - User accounts
# Format: username:x:UID:GID:comment:home:shell
cat /etc/passwd
# Example: root:x:0:0:root:/root:/bin/bash

# /etc/shadow - Password hashes (root only)
sudo cat /etc/shadow
# Contains encrypted passwords (x in passwd means password is here)

# /etc/group - Group definitions
# Format: groupname:x:GID:members
cat /etc/group
# Example: wheel:x:10:user1,user2

# /etc/gshadow - Group passwords (usually empty)
sudo cat /etc/gshadow

# /etc/sudoers - Sudo configuration
sudo visudo                 # Always edit with visudo

# Home directory for users
ls -la /home/               # User home directories
ls -la ~                    # Current user's home
ls -la /root/               # Root's home
```

### User Login Sessions

```bash
# Current login information
who                         # Who is logged in
# Output: username tty date time hostname

# More detailed information
w                           # Who is logged in and what they're doing
# Shows: user, tty, login time, idle time, CPU usage

# Login history
last                        # Show login history
last -n 5                   # Last 5 logins
last username               # Logins for specific user
last -f /var/log/wtmp       # Full login history

# Failed login attempts
lastb                       # Bad login attempts
sudo lastb                  # May need sudo

# Current terminal/TTY
tty                         # Show your terminal
ps -o pid,tty,cmd          # Show processes with tty

# List logged-in users
users                       # Simple user list
whoami                      # Current user
id                          # Detailed user info
```

### Terminal and Shell Management

```bash
# Check current shell
echo $SHELL                 # Current shell path
ps -p $$                    # Process info for current shell
ps -o pid,comm              # All processes

# Available shells
cat /etc/shells             # Shells available on system

# Change user shell
chsh                        # Change own shell
chsh -s /bin/bash username  # Change another user's shell (needs sudo)

# Run different shell
bash                        # Start bash (even if not default)
sh                          # Start sh
ksh                         # Start ksh

# Exit shell/session
exit                        # Exit current shell
logout                      # Logout of session
Ctrl+D                      # EOF - exit shell

# Environment variables
echo $PATH                  # Executable path
echo $HOME                  # Home directory
echo $USER                  # Current user
echo $HOSTNAME              # System hostname
env                         # All environment variables
```

### Terminal Handling

```bash
# Switching between terminals
Alt+F2                      # Switch to terminal 2 (graphical mode)
Alt+F1                      # Switch back to desktop

# In text-only mode (7 terminals available)
Ctrl+Alt+F1                 # Terminal 1
Ctrl+Alt+F2                 # Terminal 2
Ctrl+Alt+F7                 # Back to graphical (if running)

# Suspend and resume
Ctrl+Z                      # Suspend current command
fg                          # Resume in foreground
bg                          # Resume in background
jobs                        # List suspended jobs

# Send to background after starting
Ctrl+Z                      # Suspend
bg %1                       # Resume job 1 in background
```

---

## File Archiving & Compression

Archiving and compression are essential for backups, distribution, and data management in Linux.

### tar - The Tape Archive Utility

tar is the standard archiving tool in Linux. It doesn't compress by default, but can work with compressors.

#### Basic tar Operations

```bash
# Create uncompressed tar archive
tar -cf archive.tar file1 file2 dir1/
# -c: create
# -f: specify filename

# Add to existing tar
tar -rf archive.tar file3.txt  # -r: append (only with uncompressed tar)

# List tar contents
tar -tf archive.tar            # -t: list, -f: file
tar -tf archive.tar | head     # Show first contents
tar -tvf archive.tar           # -v: verbose (show details)

# Extract entire archive
tar -xf archive.tar            # -x: extract
tar -xf archive.tar -C /path   # Extract to specific directory

# Extract specific file
tar -xf archive.tar path/to/specific/file

# Extract specific directory
tar -xf archive.tar -C /destination/ dirname/

# Verify archive
tar -tf archive.tar > /dev/null && echo "OK" || echo "Corrupt"
```

#### Compression with tar

```bash
# Create gzip compressed tar (most common)
tar -czf archive.tar.gz file1 file2 dir/
# -c: create, -z: gzip, -f: filename

# Create bzip2 compressed tar (better compression)
tar -cjf archive.tar.bz2 file1 file2 dir/
# -c: create, -j: bzip2, -f: filename

# Create xz compressed tar (best compression, slowest)
tar -cJf archive.tar.xz file1 file2 dir/
# -c: create, -J: xz, -f: filename

# Verbose archive creation
tar -cvzf archive.tar.gz file1 file2  # Show progress

# List compressed archive
tar -tzf archive.tar.gz                # gzip
tar -tjf archive.tar.bz2               # bzip2
tar -tJf archive.tar.xz                # xz

# Extract compressed archive
tar -xzf archive.tar.gz                # gzip
tar -xjf archive.tar.bz2               # bzip2
tar -xJf archive.tar.xz                # xz

# Extract to specific directory
tar -xzf archive.tar.gz -C /tmp/       # Extract to /tmp/

# Partial extraction from compressed
tar -xzf archive.tar.gz specific/file  # Extract specific file
```

#### Advanced tar Features

```bash
# Preserve permissions and ownership
tar -czpf archive.tar.gz dir/
# -p: preserve permissions

# Exclude files/directories
tar -czf archive.tar.gz --exclude='*.log' --exclude='cache' /data

# Exclude multiple patterns
tar -czf backup.tar.gz --exclude='node_modules' --exclude='*.tmp' /project

# Only certain files
tar -czf archive.tar.gz --include='*.txt' --exclude='*' /data

# Compress with specific level
tar -czf archive.tar.gz --gzip=9 /data  # Max compression

# Update/add files to tar
tar -czf archive.tar.gz -u new_file dir/  # Add if newer

# Incremental backup
tar -czf full_backup.tar.gz /data
# Later...
tar -czf incremental.tar.gz --newer-mtime-than full_backup.tar.gz /data

# Remove from archive
tar -f archive.tar --delete file.txt

# Strip leading path
tar -czf archive.tar.gz -s '/^\.\//'  # Remove ./

# Change directory before archiving
tar -C /source -czf /backup/archive.tar.gz .  # Archive from /source
```

### gzip - GNU Compression

```bash
# Compress single file
gzip filename               # Compresses, replaces with filename.gz
gzip -k filename            # Keep original (-k: keep)

# Decompress
gunzip filename.gz          # Removes .gz extension
gzip -d filename.gz         # Alternative method

# Compression levels (1-9)
gzip -1 filename            # Fastest compression, larger file
gzip -9 filename            # Slowest compression, smallest file (default: 6)
gzip -9 -k filename         # Best compression, keep original

# Compress from stdin
cat large_file | gzip > compressed.gz
tar -cf - /data | gzip > backup.tar.gz

# Decompress to stdout
gunzip -c compressed.gz | tar -x
zcat compressed.gz | head   # View beginning without extracting

# Gzip multiple files
gzip *.txt                  # Each file becomes .gz

# Test compression
gzip -t compressed.gz       # Test integrity

# Show compression info
gzip -l compressed.gz       # Show compressed/uncompressed size

# Recursive compression
gzip -r /directory          # Compress all files in directory
```

### bzip2 - Better Compression

```bash
# Compress with bzip2
bzip2 filename              # Creates filename.bz2, removes original
bzip2 -k filename           # Keep original

# Decompress
bunzip2 filename.bz2
bzip2 -d filename.bz2

# Compression levels (1-9)
bzip2 -1 filename           # Fastest (less compression)
bzip2 -9 filename           # Slowest (best compression, usually default)

# Compress from stdin
cat large_file | bzip2 > compressed.bz2

# Decompress to stdout
bunzip2 -c compressed.bz2 | tar -x

# Test compression
bzip2 -t compressed.bz2

# Note: bzip2 typically compresses better than gzip
#       but is slower, especially at compression
```

### xz - Maximum Compression

```bash
# Compress with xz
xz filename                 # Creates filename.xz
xz -k filename              # Keep original

# Decompress
unxz filename.xz
xz -d filename.xz

# Compression levels (0-9)
xz -0 filename              # Minimum compression, fastest
xz -9 filename              # Maximum compression, slowest

# Check compression ratio
xz --best filename          # Best compression
xz --fast filename          # Fast compression

# Test compression
xz -t compressed.xz

# Decompress to stdout
unxz -c compressed.xz | tar -x

# Note: xz provides best compression but is slowest
#       Good for archival, backups
```

### Practical Archive Examples

```bash
# Create daily backup
DATE=$(date +%Y%m%d)
tar -czf backup_$DATE.tar.gz /home /etc

# Create backup with timestamp
tar -czf backup_$(date +%Y%m%d_%H%M%S).tar.gz /important/data

# Backup excluding certain files
tar -czf backup.tar.gz \
    --exclude='*.log' \
    --exclude='cache' \
    --exclude='.git' \
    /home/user

# Backup with verbosity for monitoring
tar -cvzf backup.tar.gz /data 2>&1 | tee backup.log

# Split large archive
tar -czf - /large/data | split -b 100M - backup.tar.gz.
# Restore: cat backup.tar.gz.* | tar -xz

# Backup to remote over SSH
tar -czf - /data | ssh user@backup-server "cat > backup.tar.gz"

# Incremental backup strategy
# Full backup
tar -czf full_backup.tar.gz /data

# Incremental (changed since full)
tar -czf incr1.tar.gz --newer-mtime-than full_backup.tar.gz /data

# Another incremental
tar -czf incr2.tar.gz --newer-mtime-than incr1.tar.gz /data

# Extract all (full + incrementals)
tar -xzf full_backup.tar.gz
tar -xzf incr1.tar.gz
tar -xzf incr2.tar.gz

# Verify archive contents
tar -tzf archive.tar.gz | head -20  # Preview
tar -tzf archive.tar.gz | wc -l     # Count files
tar -tzf archive.tar.gz | grep "\.txt$"  # Find txt files

# Find and archive
find /home -name "*.txt" -type f | tar -czf text_backup.tar.gz -T -

# Create archive from stdin
cat inputfile | tar -czf archived.tar.gz -
```

### Comparing Compression Methods

```
Format      File Size    Speed      Best For
tar         Original     Fastest    Quick backups, no space needed
tar.gz      ~30-50%      Good       Standard backups
tar.bz2     ~20-30%      Medium     Better compression needed
tar.xz      ~10-20%      Slow       Archival, distribution

Choose based on:
- Speed needed: tar < tar.gz < tar.bz2 < tar.xz
- Space needed: tar > tar.gz > tar.bz2 > tar.xz
- Compatibility: tar.gz (most standard)
- Archival: tar.xz (best compression)
```

---

## Text File Creation & Editing

Creating and editing text files is fundamental to Linux administration.

### Creating Text Files

```bash
# Using echo (single line)
echo "Content here" > file.txt
echo "More content" >> file.txt  # Append

# Using cat with heredoc (multi-line)
cat > newfile.txt << EOF
Line 1 of content
Line 2 of content
Line 3 of content
EOF

# Using cat with heredoc and indentation
cat > config.txt << 'ENDCONFIG'
# Configuration file
SERVER_HOST=localhost
SERVER_PORT=8080
DEBUG=true
ENDCONFIG

# Using printf (formatted)
printf "Line 1\nLine 2\nLine 3\n" > file.txt

# Using touch (empty file)
touch empty_file.txt

# Using tee (from pipe)
echo "Content" | tee newfile.txt
ps aux | tee processes.txt

# Using redirection
ls > file_list.txt
grep "pattern" file.txt > results.txt
```

### Viewing Text Files

```bash
# Display entire file
cat filename.txt
cat file1.txt file2.txt         # Multiple files

# Display with line numbers
cat -n filename.txt
nl filename.txt

# Show non-printing characters
cat -A filename.txt             # $ at end of lines, ^I for tabs

# Show first lines
head filename.txt               # First 10 lines (default)
head -5 filename.txt            # First 5 lines
head -n 20 filename.txt         # First 20 lines

# Show last lines
tail filename.txt               # Last 10 lines
tail -5 filename.txt            # Last 5 lines
tail -20 filename.txt           # Last 20 lines

# Follow file (real-time)
tail -f /var/log/messages       # Follow as it grows
tail -f filename.txt &          # Follow in background

# Page through file
less filename.txt               # Scrollable viewing
# In less: Space (next page), b (previous), q (quit), / (search)

more filename.txt               # Basic paging
# Space (next page), q (quit)

# View specific lines
sed -n '10,20p' filename.txt    # Lines 10-20
awk 'NR>=10 && NR<=20' filename.txt  # Lines 10-20
head -20 filename.txt | tail -10     # Lines 11-20
```

### vi/vim Editor

vim is the standard text editor on Linux systems. Mastering it is essential for the RHCSA exam.

#### vim Modes

```bash
# Start vim
vim filename.txt
vi filename.txt                 # Traditional vi

# vim has three modes:
# 1. Normal mode (default) - for commands
# 2. Insert mode - for typing text
# 3. Command mode - for commands

# Enter insert mode
i                               # Insert before cursor
I                               # Insert at beginning of line
a                               # Append after cursor
A                               # Append at end of line
o                               # New line below cursor
O                               # New line above cursor
s                               # Substitute character
S                               # Substitute line

# Exit insert mode
ESC                             # Return to normal mode
```

#### vim Normal Mode Commands

```bash
# Navigation
h                               # Left
j                               # Down
k                               # Up
l                               # Right
G                               # End of file
1G                              # Beginning of file
25G                             # Go to line 25
^                               # Start of line
$                               # End of line
w                               # Next word
b                               # Previous word
e                               # End of word
(                               # Previous sentence
)                               # Next sentence
{                               # Previous paragraph
}                               # Next paragraph

# Searching
/pattern                        # Search forward
?pattern                        # Search backward
n                               # Next match
N                               # Previous match
*                               # Search for word under cursor

# Deleting
x                               # Delete character under cursor
dd                              # Delete entire line
5dd                             # Delete 5 lines
D                               # Delete to end of line
dw                              # Delete word
d$                              # Delete to end of line
ggdG                            # Delete entire file
```

#### vim Editing Commands

```bash
# Copy/Paste
yy                              # Copy (yank) line
5yy                             # Copy 5 lines
yw                              # Copy word
y$                              # Copy to end of line
p                               # Paste after cursor
P                               # Paste before cursor

# Undo/Redo
u                               # Undo
Ctrl+R                          # Redo
U                               # Undo all changes in line

# Replace
r                               # Replace single character
R                               # Replace mode (type to replace)
~                               # Toggle case of character
s                               # Substitute character
cw                              # Change word
c$                              # Change to end of line
cc                              # Change entire line

# Joins
J                               # Join current and next line
```

#### vim Visual Mode

```bash
# Enter visual mode
v                               # Visual character mode
V                               # Visual line mode
Ctrl+V                          # Visual block mode

# In visual mode
y                               # Yank (copy) selection
d                               # Delete selection
~                               # Toggle case
```

#### vim Command Mode

```bash
# Enter command mode (from normal mode)
:                               # Colon starts command mode

# Essential commands
:w                              # Write (save)
:q                              # Quit
:wq                             # Write and quit
:x                              # Write and quit (same as wq)
:q!                             # Quit without saving
:e filename                     # Open file
:e!                             # Revert to last saved

# Substitution (search and replace)
:s/old/new/                     # Replace first occurrence
:s/old/new/g                    # Replace all on line
:%s/old/new/g                   # Replace all in file
:%s/old/new/gc                  # Replace all with confirmation

# Navigation
:10                             # Go to line 10
:$                              # Go to last line
:set number                     # Show line numbers
:set nonu                       # Hide line numbers

# Other
:!command                       # Execute shell command
:read !command                  # Insert command output
:r filename                     # Insert file contents
:set tabstop=4                  # Set tab width

# Save as
:w newfilename                  # Save with new name
:wq newfilename                 # Save as and quit
```

### nano Editor

nano is simpler than vim and good for beginners.

```bash
# Start nano
nano filename.txt

# Basic commands (shown at bottom of screen)
Ctrl+X                          # Exit (save if modified)
Ctrl+O                          # Write out (save)
Ctrl+K                          # Cut line
Ctrl+U                          # Uncut (paste)
Ctrl+C                          # Show cursor position
Ctrl+W                          # Find (search)
Ctrl+Y                          # Page up
Ctrl+V                          # Page down
Ctrl+A                          # Start of line
Ctrl+E                          # End of line
Ctrl+H                          # Backspace (delete)
Ctrl+D                          # Delete character
Ctrl+R                          # Replace

# Workflow
nano file.txt
# Type content
# Ctrl+X to exit
# Y to save changes
# Confirm filename (press Enter)
```

### sed - Stream Editor

sed performs text transformations on input stream.

```bash
# Basic substitution
sed 's/old/new/' file.txt       # Replace first per line
sed 's/old/new/g' file.txt      # Replace all occurrences
sed 's/old/new/2' file.txt      # Replace 2nd occurrence
sed 's/old/new/i' file.txt      # Case-insensitive

# In-place editing
sed -i 's/old/new/g' file.txt   # Modify file directly
sed -i.bak 's/old/new/g' file.txt  # Create backup (file.txt.bak)

# Delete lines
sed '/pattern/d' file.txt       # Delete lines containing pattern
sed '5d' file.txt               # Delete line 5
sed '5,10d' file.txt            # Delete lines 5-10
sed '/^$/d' file.txt            # Delete blank lines

# Print lines
sed -n '/pattern/p' file.txt    # Print only matching lines
sed -n '5,10p' file.txt         # Print lines 5-10
sed -n '$p' file.txt            # Print last line

# Address ranges
sed '1,3s/old/new/' file.txt    # Replace in lines 1-3
sed '/START/,/END/d' file.txt   # Delete from START to END

# Multiple operations
sed -e 's/old1/new1/' -e 's/old2/new2/' file.txt

# Append/Insert
sed '/pattern/a\New line after' file.txt
sed '/pattern/i\New line before' file.txt

# Example: Create config file
cat > config.txt << 'EOF'
# Configuration
DEBUG=false
HOST=localhost
PORT=8080
EOF

# Edit with sed
sed -i 's/DEBUG=false/DEBUG=true/' config.txt
sed -i 's/HOST=localhost/HOST=0.0.0.0/' config.txt
cat config.txt
```

---

## File & Directory Operations

Managing files and directories efficiently is fundamental to Linux administration.

### File Management

```bash
# Create files
touch newfile.txt               # Create empty file
touch file1 file2 file3         # Multiple files
touch -t 202401151430 file.txt  # Create with specific time

# Copy files
cp source.txt destination.txt
cp file.txt /path/to/copy/      # To directory
cp file1 file2 file3 /destination/  # Multiple files

# Copy with options
cp -i source dest               # Prompt if exists (interactive)
cp -v source dest               # Verbose
cp -p source dest               # Preserve permissions/times
cp -a source dest               # Archive (all attributes)
cp -r source_dir dest_dir       # Recursive (directories)

# Move/Rename
mv old_name new_name            # Rename file
mv file.txt /path/to/move/      # Move file
mv file1 file2 file3 /destination/  # Move multiple

# Move with options
mv -i source destination        # Prompt if exists
mv -v source destination        # Verbose
mv -f source destination        # Force (no prompt)

# Delete files
rm filename.txt
rm file1 file2 file3            # Multiple files
rm *.txt                        # Pattern matching
rm -i filename.txt              # Prompt before delete
rm -f filename.txt              # Force delete
rm -v filename.txt              # Verbose

# File information
ls -l file.txt                  # Detailed info
stat file.txt                   # Comprehensive info
file file.txt                   # File type
wc file.txt                     # Line, word, byte count
du -h file.txt                  # Disk usage
```

### Directory Management

```bash
# Create directories
mkdir dirname
mkdir dir1 dir2 dir3            # Multiple directories
mkdir -p /path/to/nested/dir    # Create parents

# Change directory
cd /absolute/path
cd relative/path
cd ..                           # Parent directory
cd ../..                        # Up two levels
cd ~                            # Home directory
cd -                            # Previous directory

# List directories
ls                              # Simple list
ls -l                           # Long format
ls -la                          # Including hidden
ls -lh                          # Human-readable sizes
ls -lS                          # Sort by size
ls -lt                          # Sort by time
ls -R                           # Recursive
ls -d */                        # Directories only

# Tree view
tree
tree -L 2                       # Limit depth
tree -d                         # Directories only

# Current directory
pwd                             # Print working directory
echo $PWD                       # Alternative

# Directory size
du -h dirname
du -sh dirname                  # Total only
du -sh *                        # Each item

# Delete directories
rmdir empty_dir                 # Empty only
rm -r dir_with_files            # Remove with contents
rm -rf dir_with_files           # Force remove (careful!)
```

### File Globbing Patterns

```bash
# Wildcards
*                               # Any characters
?                               # Single character
[abc]                           # a, b, or c
[a-z]                           # Lowercase letters
[0-9]                           # Digits
[^abc]                          # Not a, b, or c

# Examples
ls *.txt                        # All .txt files
ls file?.txt                    # file1.txt, fileA.txt, etc.
ls [0-9]*.txt                   # Start with digit
cp *.log /backup/               # Copy all logs
rm *~                           # Delete backup files
mv [A-Z]* /uppercase/           # Move files starting with uppercase

# Extended globbing (requires shopt -s extglob)
!(*.txt)                        # Everything except .txt
?(pattern)                      # Zero or one match
*(pattern)                      # Zero or more matches
+(pattern)                      # One or more matches
@(pat1|pat2|pat3)               # Exactly one of patterns
```

### Special Directories

```bash
# Important system paths
/                               # Root filesystem
/home                           # User home directories
/root                           # Root user home
/etc                            # Configuration files
/bin                            # Essential user binaries
/sbin                           # Essential system binaries
/usr/bin                        # User programs
/usr/local/bin                  # Locally installed programs
/opt                            # Optional software
/var                            # Variable data
/var/log                        # System logs
/var/tmp                        # Temporary files (preserved)
/tmp                            # Temporary files (cleared on reboot)
/dev                            # Device files
/proc                           # Process information
/sys                            # System information
/lib                            # System libraries

# Special references
.                               # Current directory
..                              # Parent directory
~                               # Home directory
~username                       # Another user's home
-                               # Previous directory (with cd)
```

### Path Handling

```bash
# Absolute paths (start with /)
/etc/passwd
/home/user/documents

# Relative paths (start from current)
documents/file.txt
../parent_dir/file.txt
./current/file.txt

# Expanding paths
echo ~/projects                 # Expands to /home/user/projects
echo $HOME/documents            # Uses HOME variable
cd /path/to/dir && ls           # After cd, relative to new dir

# Finding files
find . -name "*.txt"            # Find txt files recursively
find /home -name "document*"    # Search from /home
locate filename                 # Search database (requires updatedb)
which command                   # Full path to executable
whereis command                 # Binary, source, man locations
```

---

## Links (Hard & Soft)

Links are references to files. Understanding them is crucial for RHCSA.

### Soft Links (Symbolic Links)

```bash
# Create soft link
ln -s /path/to/original /path/to/link
ln -s /etc/hosts ~/hosts_link
ln -s /usr/bin/python3 python

# Create relative soft link
ln -s ../original ./link
cd subdir
ln -s ../file.txt link_to_file

# Show soft links
ls -l                           # Shows -> points to
file linkname                   # Identify link type
readlink linkname               # Show link target
readlink -f linkname            # Follow to final target

# Find all soft links
find . -type l                  # All symlinks
find . -type l -exec ls -l {} \;  # Show details

# Update soft link
rm old_link
ln -s /new/path new_link

# Remove soft link
rm linkname                     # Just removes link, not original
unlink linkname                 # Alternative

# Soft link characteristics
# - Can point to files or directories
# - Can be broken (if target deleted)
# - Can cross filesystems
# - Can cross boundaries
# - Contain path to target (not inode)
```

### Hard Links

```bash
# Create hard link
ln original hardlink            # Same filesystem only
ln /home/file.txt /home/backup/file.txt

# Hard link characteristics
# - Points to same inode as original
# - Cannot link directories
# - Cannot cross filesystems
# - Deleting one doesn't affect others
# - All have equal status

# View inode
ls -i file.txt hardlink.txt     # Same inode = hard link

# Verify hard link
stat file.txt
stat hardlink.txt               # Same inode number

# All changes visible in both
echo "edit" >> file.txt
cat hardlink.txt                # Shows edit

# Deleting one
rm file.txt
cat hardlink.txt                # Still works, data intact

# Count hard links
ls -l                           # Second column shows count
# If count is 2 or more, hard links exist
```

### Link Verification

```bash
# Check link type
file linkname                   # Shows "symbolic link" or file type
ls -l linkname                  # Shows -> for symlink
readlink linkname               # Only works for symlinks

# Verify target
readlink -f linkname            # Full path to target
realpath linkname               # Absolute path to target

# Check if broken
test -L linkname && test ! -e linkname && echo "Broken"

# Find broken links
find . -type l ! -exec test -e {} \; -print

# Get link count
ls -l                           # Second column
# If > 1, has hard links
```

### Practical Link Examples

```bash
# Create links for convenience
cd ~
ln -s /etc/hosts hosts_config
ln -s /var/log logs
ln -s ~/projects proj

# Compatibility link
ln -s /usr/bin/python3 /usr/bin/python

# Backup via hard link
ln important_file backup_file   # Same filesystem

# Multiple links to same file
ln original link1
ln original link2
ln original link3
# All point to same data

# Remove link
rm link1                        # Original untouched

# Symlink for application
ln -s /opt/app/latest /opt/app/current
# Update to new version:
rm /opt/app/current
ln -s /opt/app/v2.0 /opt/app/current
```

---

## File Permissions (ugo/rwx)

File permissions are critical for security and access control. The RHCSA exam heavily emphasizes permission management.

### Understanding Permissions

```bash
# Permission display
drwxr-xr-x  username  groupname  file.txt

# Breakdown:
d           # File type (- for file, d for directory, l for link)
rwx         # User permissions (read, write, execute)
r-x         # Group permissions (read, no-write, execute)
r-x         # Other permissions (read, no-write, execute)
username    # Owner
groupname   # Group
```

### Permission Values

```bash
# Octal values
r (read) = 4
w (write) = 2
x (execute) = 1

# Combinations
7 = 4+2+1 = rwx (full)
6 = 4+2   = rw- (read and write)
5 = 4+1   = r-x (read and execute)
4 = 4     = r-- (read only)
3 = 2+1   = -wx (write and execute)
2 = 2     = -w- (write only)
1 = 1     = --x (execute only)
0 =       = --- (none)
```

### Viewing Permissions

```bash
# Long format listing
ls -l file.txt
# -rw-r--r-- 1 user group 1234 date file.txt

# Numeric display
stat file.txt                   # Shows octal permissions
ls -n file.txt                  # Show UIDs/GIDs

# Detailed breakdown
stat file.txt | grep Access     # Show permissions and octal
```

### Changing Permissions (Symbolic)

```bash
# Basic syntax: chmod [u/g/o/a][+/-/=][r/w/x] file

# User (u) operations
chmod u+x script.sh             # Add execute for user
chmod u-w file.txt              # Remove write from user
chmod u=r file.txt              # Set to read only

# Group (g) operations
chmod g+w file.txt              # Add write for group
chmod g-x file.txt              # Remove execute for group
chmod g= file.txt               # Remove all for group

# Other (o) operations
chmod o+r file.txt              # Add read for others
chmod o-w file.txt              # Remove write from others
chmod o= file.txt               # Remove all for others

# All (a) operations (default if not specified)
chmod a+x file.txt              # Add execute for all
chmod a-w file.txt              # Remove write from all
chmod a= file.txt               # Remove all permissions

# Combined operations
chmod u+rwx,g+rx,o+r file.txt   # Multiple operations
chmod u+x,g-w,o-w script.sh     # Different operations
chmod go-w file.txt             # Remove write from group and other
chmod -x *.txt                  # Remove execute from all .txt files

# Apply recursively
chmod -R 755 directory/         # All files and subdirs
chmod -R u+w directory/         # Add write recursively
chmod -R g-w directory/         # Remove group write recursively
```

### Changing Permissions (Numeric)

```bash
# Three-digit format: uuu gg oo

# Common permissions
chmod 755 script.sh             # rwxr-xr-x (scripts, executables)
chmod 644 file.txt              # rw-r--r-- (files, documents)
chmod 600 secret.txt            # rw------- (private files)
chmod 700 private_dir           # rwx------ (private directory)
chmod 777 public_dir            # rwxrwxrwx (everyone full access)
chmod 640 config.conf           # rw-r----- (read for group)
chmod 660 shared.txt            # rw-rw---- (group writable)
chmod 444 readonly.txt          # r--r--r-- (read only)
chmod 000 blocked.txt           # --------- (no access)

# Application
chmod 755 /usr/bin/program      # Executable for all
chmod 600 /etc/password         # Private password file
chmod 700 /root                 # Root home directory
chmod 777 /tmp                  # Temporary directory
```

### Default Permissions (umask)

umask controls default permissions for new files/directories.

```bash
# View current umask
umask                           # Usually 0022

# How umask works
# Default file: 666 - umask = permissions
# Default dir: 777 - umask = permissions

# With umask 0022:
# New file: 666 - 022 = 644 (rw-r--r--)
# New dir: 777 - 022 = 755 (rwxr-xr-x)

# Set umask
umask 022                       # Set to 022
umask 077                       # More restrictive (600 for files, 700 for dirs)
umask 002                       # Less restrictive (664 for files, 775 for dirs)

# Make permanent (add to ~/.bashrc)
echo "umask 022" >> ~/.bashrc
source ~/.bashrc

# Verify
umask
touch testfile
ls -l testfile
```

### File Ownership

```bash
# View ownership
ls -l file.txt                  # Shows user and group
stat file.txt                   # Detailed info
id                              # Current user info

# Change owner (requires sudo or own the file)
sudo chown newuser file.txt     # Change user
sudo chown :newgroup file.txt   # Change group only
sudo chown newuser:newgroup file.txt  # Both

# Change with numeric UID/GID
sudo chown 1000:1000 file.txt

# Recursive change
sudo chown -R newuser:newgroup directory/
sudo chown -R 1000:1000 /home/user

# Follow symlinks
sudo chown -R -H newuser directory/  # Don't follow links
sudo chown -R -L newuser directory/  # Follow links

# Change group only
sudo chgrp groupname file.txt
sudo chgrp -R groupname directory/
```

### Special Permissions

#### Setuid (Set User ID)

```bash
# Setuid on executable - runs as owner, not executor

# View setuid (shows s instead of x for user)
-rwsr-xr-x  file.txt            # User execute position shows 's'

# Set setuid
chmod 4755 file.txt             # Setuid + rwxr-xr-x
chmod u+s file.txt              # Add setuid

# Remove setuid
chmod 4755 file.txt             # Remove the 4
chmod u-s file.txt              # Remove setuid bit

# Examples of setuid
passwd                          # Changes root-owned /etc/shadow
sudo                            # Runs as root
```

#### Setgid (Set Group ID)

```bash
# Setgid on executable - runs as group
# Setgid on directory - new files inherit group

# View setgid (shows s instead of x for group)
-rwxr-sr-x  file.txt            # Group execute shows 's'
drwxr-sr-x  directory/          # Directory with setgid

# Set setgid
chmod 2755 file.txt             # Setgid + rwxr-xr-x
chmod g+s file.txt              # Add setgid
chmod 2755 directory/           # Directory setgid

# Remove setgid
chmod g-s file.txt              # Remove setgid

# Practical use
# In shared directory:
chmod 2770 shared_dir           # Files inherit group
chmod 2775 shared_dir           # Or with other permissions
```

#### Sticky Bit

```bash
# Sticky bit on directory - only owner can delete files
# Useful for /tmp and shared directories

# View sticky bit (shows t instead of x for other)
drwxrwxrwt  /tmp                # Other execute shows 't'

# Set sticky bit
chmod 1777 directory/           # Sticky + rwxrwxrwx
chmod o+t directory/            # Add sticky bit

# Remove sticky bit
chmod -t directory/             # Remove sticky bit

# Example: shared temp directory
chmod 1777 /home/temp           # Everyone can use, only owner deletes
chmod 1750 /home/shared         # Group can write/delete, others read

# Without sticky bit
rm other_users_file.txt         # Could delete anyone's file!

# With sticky bit
rm other_users_file.txt         # Permission denied!
```

### Finding Files with Specific Permissions

```bash
# Find files with setuid
find / -perm -4000             # All setuid files

# Find files with setgid
find / -perm -2000             # All setgid files

# Find files with sticky bit
find / -perm -1000             # All sticky files

# Find world-writable files
find / -perm -002              # Everyone can write

# Find specific permission
find . -perm 755               # Exactly 755
find . -perm -755              # At least 755 (superset)
find . -type f -perm 644       # Files with 644

# Files without read for user
find . ! -perm -400            # User can't read
```

---

## System Documentation

Linux provides extensive documentation. Knowing where to find it is crucial for the RHCSA exam.

### man - Manual Pages

```bash
# View manual page
man command
man ls                          # Documentation for ls
man grep                        # Documentation for grep

# Manual sections
man 1 ls                        # User commands
man 5 passwd                    # File formats
man 8 sshd                      # System administration

# Search by keyword
man -k keyword                  # Search for keyword
man -k password                 # Find password-related commands
man -k file                     # Search for "file"

# One-line description
man -f command                  # Short description
whatis command                  # Same as man -f

# Exact match
man -e command                  # Exact match only

# Navigation in man (uses less)
Space                           # Page down
b                               # Page up
/pattern                        # Search forward
?pattern                        # Search backward
n                               # Next match
N                               # Previous match
g                               # Go to start
G                               # Go to end
q                               # Quit

# Common man sections
# 1: General user commands
# 2: System calls
# 3: Library functions
# 4: Device files
# 5: File formats and conventions
# 6: Games
# 7: Miscellaneous
# 8: System administration

# View specific section
man 5 /etc/passwd               # File format for passwd
man 1 passwd                    # User command passwd
man 8 passwd                    # System password utility
```

### info - GNU Info Documentation

```bash
# View info documentation
info command
info coreutils                  # GNU core utilities
info bash                       # Bash shell

# Navigation
Space                           # Page down
Backspace                       # Page up
Tab                             # Next link
Enter                           # Follow link
l                               # Last visited
n                               # Next chapter
p                               # Previous chapter
u                               # Up (parent)
d                               # Directory (top)
t                               # Table of contents
q                               # Quit

# Searching
/pattern                        # Search

# View in specific format
info --vi-keys command          # vi-style navigation
info --emacs-keys command       # Emacs-style
```

### whatis and whereis

```bash
# One-line command description
whatis ls                       # Brief description
whatis grep
whatis tar

# Pattern matching
whatis -w 'file*'               # Pattern match

# Find command locations
whereis ls                      # Show binary, source, man
whereis -b bash                 # Binary only
whereis -s bash                 # Source only
whereis -m bash                 # Manual only

# Full path to executable
which ls                        # /bin/ls
which python                    # /usr/bin/python
which grep                      # /bin/grep

# Show all matches
which -a python                 # All python executables

# Command type
type ls                         # Builtin, alias, or external
type cd                         # Show if builtin
```

### help - Built-in Command Help

```bash
# List available built-ins
help                            # Show all built-ins

# Help for specific built-in
help cd
help echo
help set

# Bash help
bash -c "help set"             # Run in subshell
```

### /usr/share/doc - System Documentation

```bash
# Browse documentation directory
ls /usr/share/doc/              # Available documentation

# Package documentation
ls /usr/share/doc/bash/         # Bash documentation
ls /usr/share/doc/openssh-clients/  # SSH documentation
ls /usr/share/doc/vim/          # Vim documentation

# Read documentation files
cat /usr/share/doc/bash/README
less /usr/share/doc/bash/README

# Common files
README                          # Overview
CHANGELOG                       # Version history
LICENSE                         # License information
AUTHORS                         # Contributors
INSTALL                         # Installation instructions
NEWS                            # News/announcements
THANKS                          # Thanks/credits
```

### Practical Documentation Searching

```bash
# Find documentation for specific topic
man -k ssh                      # All SSH-related docs
man -k password                 # Password-related
man -k network                  # Networking

# Search file content
grep -r "pattern" /usr/share/doc/

# Use multiple documentation sources
man command                     # Manual page
info command                    # Info page
command --help                  # Quick help
whatis command                  # Brief description
whereis command                 # Location

# Documentation workflow
# 1. Try: command --help
# 2. Try: man command
# 3. Search: man -k keyword
# 4. Try: info command
# 5. Check: /usr/share/doc/
# 6. Search: online
```

---

## Lab Exercises & Practice

### Exercise 1: Shell Basics & Navigation

#### Objectives
- Navigate filesystem confidently
- Execute commands with correct syntax
- Use history effectively

#### Tasks

```bash
# 1.1 - Determine current location and navigate
pwd                             # Show current directory
cd /                            # Go to root
pwd
cd /etc
pwd
cd /home
pwd
cd -                            # Previous directory
pwd

# 1.2 - Create directory structure for labs
cd ~
mkdir -p rhcsa_labs/shell_basics
mkdir -p rhcsa_labs/io_redirection
mkdir -p rhcsa_labs/grep_practice
mkdir -p rhcsa_labs/archives
cd rhcsa_labs
ls -la

# 1.3 - Use help resources
ls --help | head -20
grep --help | head -15
man ls                          # Press 'q' to exit
whatis ls
whereis bash
which ls

# 1.4 - Navigate with shortcuts
cd ~
pwd
cd /tmp
pwd
cd ~/rhcsa_labs
pwd
cd -
pwd

# 1.5 - Create files and explore
touch file1.txt file2.txt
ls -la
cd shell_basics
touch test.txt
ls -la ../
pwd
cd ..
pwd
```

#### Verification
```bash
# Check directory structure
tree rhcsa_labs 2>/dev/null || find rhcsa_labs -type d

# Verify current location
pwd
```

---

### Exercise 2: I/O Redirection

#### Objectives
- Master output redirection
- Use pipes effectively
- Combine stdout and stderr

#### Tasks

```bash
cd ~/rhcsa_labs/io_redirection

# 2.1 - Output redirection
ls /etc > directory_listing.txt
head -10 directory_listing.txt
wc -l directory_listing.txt

# 2.2 - Append to file
echo "System kernel:" >> directory_listing.txt
uname -r >> directory_listing.txt
tail -5 directory_listing.txt

# 2.3 - Error redirection
ls /nonexistent 2> errors.txt
cat errors.txt

# 2.4 - Redirect both
find / -name "test" &> full_output.txt 2>&1
head errors.txt 2>/dev/null || head full_output.txt

# 2.5 - Pipes
ls /usr/bin | wc -l            # Count executables
ps aux | grep "bash"           # Find bash processes
cat directory_listing.txt | sort | head -5

# 2.6 - Complex pipes
find /etc -type f -name "*.conf" 2>/dev/null | wc -l

# 2.7 - Using tee
ls | tee files_list.txt
cat files_list.txt
```

#### Verification
```bash
ls -la *.txt
cat directory_listing.txt | head -3
wc -l *.txt
```

---

### Exercise 3: grep & Regular Expressions

#### Objectives
- Use grep with various options
- Write and test regular expressions
- Search system files

#### Tasks

```bash
cd ~/rhcsa_labs/grep_practice

# 3.1 - Basic grep
grep "root" /etc/passwd
grep -c "bin" /etc/passwd
grep -n "bash" /etc/passwd | head -5

# 3.2 - Case-insensitive
grep -i "ROOT" /etc/passwd
grep -i "bash" /etc/passwd | head -3

# 3.3 - Invert match
grep -v "nologin" /etc/passwd
grep -v "^#" /etc/ssh/sshd_config 2>/dev/null | head -10

# 3.4 - Context
grep -A 2 "^root" /etc/passwd
grep -B 1 "^daemon" /etc/passwd

# 3.5 - Regular expressions
grep "^[a-z]" /etc/passwd        # Start with lowercase
grep "[0-9]" /etc/passwd         # Contains digit
grep "bash$" /etc/passwd         # Ending with bash

# 3.6 - File patterns
grep -E "^(root|admin)" /etc/passwd 2>/dev/null
grep -E "error|warning" /var/log/messages 2>/dev/null

# 3.7 - Create test file
cat > test_data.txt << 'EOF'
User1:100:admin
User2:200:user
Admin1:50:admin
Admin2:60:admin
guest:1000:visitor
EOF

# 3.8 - Practice searches
grep "admin" test_data.txt
grep -i "ADMIN" test_data.txt
grep "^[A-Z]" test_data.txt
grep "[0-9][0-9][0-9]" test_data.txt
```

#### Verification
```bash
# Test all searches work
grep -c "admin" test_data.txt
grep -v "admin" test_data.txt
```

---

### Exercise 4: File Operations & Permissions

#### Objectives
- Manage files and directories
- Change permissions correctly
- Understand permission implications

#### Tasks

```bash
cd ~/rhcsa_labs

# 4.1 - File operations
mkdir files_exercise
cd files_exercise
touch file1.txt file2.txt file3.txt
mkdir subdir1 subdir2

# 4.2 - Copy operations
cp file1.txt file1_backup.txt
cp -r subdir1 subdir1_copy
ls -la

# 4.3 - Move/Rename
mv file2.txt file2_renamed.txt
mv file3.txt subdir1/
ls -la
ls subdir1/

# 4.4 - Delete
rm file1_backup.txt
rm -i file2_renamed.txt  # Say yes

# 4.5 - Permissions (symbolic)
touch script.sh
chmod u+x script.sh
ls -l script.sh

chmod u-w script.sh
chmod g+r script.sh
chmod o-r script.sh
ls -l script.sh

# 4.6 - Permissions (numeric)
chmod 755 script.sh
ls -l script.sh

chmod 644 file1.txt
chmod 600 secret.txt
chmod 700 subdir1
ls -la

# 4.7 - Recursive permissions
chmod -R 755 subdir1_copy
find subdir1_copy -type f -exec ls -l {} \;

# 4.8 - Directory permissions
mkdir project
chmod 750 project
ls -ld project

# 4.9 - Understanding umask
umask
touch new_file.txt
ls -l new_file.txt
```

#### Verification
```bash
# Check permissions set correctly
ls -la script.sh
ls -la secret.txt
ls -ld project
```

---

### Exercise 5: Archives & Compression

#### Objectives
- Create and extract archives
- Choose compression methods
- Verify archive integrity

#### Tasks

```bash
cd ~/rhcsa_labs/archives

# Create test directory structure
mkdir -p test_project/src
mkdir -p test_project/docs
mkdir -p test_project/config
echo "#!/bin/bash" > test_project/src/script.sh
echo "# Configuration" > test_project/config/app.conf
echo "# Documentation" > test_project/docs/README.txt

# 5.1 - Create uncompressed tar
tar -cf test_project.tar test_project/
ls -lh test_project.tar

# 5.2 - List tar contents
tar -tf test_project.tar
tar -tvf test_project.tar | head

# 5.3 - Extract tar
mkdir extract1
tar -xf test_project.tar -C extract1
ls -R extract1

# 5.4 - Create compressed archives
tar -czf test_project.tar.gz test_project/
tar -cjf test_project.tar.bz2 test_project/
tar -cJf test_project.tar.xz test_project/

# 5.5 - Compare sizes
ls -lh test_project.tar*

# 5.6 - Extract compressed
mkdir extract2
tar -xzf test_project.tar.gz -C extract2
diff -r extract1 extract2

# 5.7 - Verify archive
tar -tzf test_project.tar.gz > /dev/null && echo "Good" || echo "Corrupt"

# 5.8 - Extract specific file
mkdir extract3
tar -xzf test_project.tar.gz test_project/config/app.conf -C extract3
ls -R extract3

# 5.9 - Create with exclusions
tar -czf project_no_config.tar.gz --exclude='config' test_project/
tar -tzf project_no_config.tar.gz | grep config  # Should be empty
```

#### Verification
```bash
# Verify extractions match
ls -R extract1/
ls -R extract2/
```

---

## Summary of Critical Commands

### Most Important for RHCSA Exam

```bash
# Navigation
pwd, cd, ls

# Redirection
> (output), >> (append), 2> (error), | (pipe)

# Text Processing
grep, sed, cut, sort, uniq

# File Management
cp, mv, rm, touch, mkdir

# Permissions
chmod, chown, chgrp

# Archives
tar, gzip, gunzip

# SSH
ssh, scp, ssh-keygen

# Users
su, sudo, whoami, id

# Documentation
man, whatis, info

# Other Essential
cat, less, find, sort, uniq, wc
```

---

## Exam Tips & Study Recommendations

### Before the Exam

1. **Practice every command** covered in these notes
2. **Time yourself** - become fast at typing
3. **Read man pages** - get comfortable with documentation
4. **Understand WHY** - not just WHAT
5. **Practice combinations** - real tasks use multiple skills
6. **Get comfortable with vim** - you'll use it
7. **Know directory structure** - /etc, /home, /root, /var, etc.
8. **Test your knowledge** - create your own exercises

### During the Exam

1. **Read questions completely** - understand all requirements
2. **Use man pages** - they're your friend
3. **Work systematically** - don't rush
4. **Verify your work** - test that changes work
5. **Use sudo wisely** - understand what needs root
6. **Save important files** - backup before major changes
7. **Manage time** - move on if stuck
8. **Double-check permissions** - critical for success

### Key Areas to Master

- **I/O Redirection**: Pipes, redirects, stderr/stdout
- **grep & regex**: Essential for all text searches
- **Permissions**: chmod, chown, special bits
- **SSH**: Keys, connections, file transfer
- **tar/gzip**: Creating and extracting archives
- **User management**: Switching, sudo, sudoers
- **Text editing**: vim, nano, sed
- **File operations**: Copy, move, delete, links

---

## Additional Resources

### Practice Scenarios

1. Create a backup script that archives files with timestamp
2. Search log files for specific patterns
3. Set up SSH key-based authentication
4. Create users with specific permissions
5. Extract specific files from compressed archives
6. Change file permissions for security
7. Create symbolic and hard links for shortcuts
8. Use sed to edit configuration files
9. Chain commands with pipes for complex tasks
10. Troubleshoot permission issues

### Real-World Applications

- **System backups**: tar + gzip + cron
- **Log analysis**: grep, sed, regular expressions
- **User administration**: useradd, userdel, usermod
- **Security**: File permissions, SSH keys, sudoers
- **Development**: Text editing, file organization, version control
- **Troubleshooting**: grep logs, find files, check permissions

---

Good luck with your RHCSA exam preparation!

Remember: **Understanding is more important than memorization. Practice actively, not passively.**

Practice these commands daily until they become second nature. The exam will test your practical skills, not your memory.

---

## Quick Command Reference Table

| Task | Command |
|------|---------|
| List files | `ls -la` |
| Change directory | `cd path` |
| Print location | `pwd` |
| Create file | `touch file.txt` |
| Create directory | `mkdir dir` |
| Copy file | `cp src dest` |
| Move file | `mv src dest` |
| Delete file | `rm file` |
| Search text | `grep pattern file` |
| Redirect output | `cmd > file.txt` |
| Pipe commands | `cmd1 \| cmd2` |
| Archive files | `tar -czf archive.tar.gz files` |
| Extract archive | `tar -xzf archive.tar.gz` |
| Connect SSH | `ssh user@host` |
| Copy via SSH | `scp file user@host:path` |
| Switch user | `su username` |
| Privilege escalation | `sudo command` |
| View permissions | `ls -l` |
| Change permissions | `chmod 755 file` |
| Change owner | `chown user:group file` |
| View documentation | `man command` |
| Create symlink | `ln -s original link` |
| Create hard link | `ln original link` |

---

**End of RHCSA Essential Tools Lab Notes**
