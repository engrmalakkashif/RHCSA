# RHCSA Lab Exercises - Hands-On Practice

## Overview
These exercises are designed to help you practice the essential tools covered in the RHCSA exam. Work through each section, execute all commands, and verify your understanding.

---

## Lab 1: Shell Navigation & Command Basics

### Objectives
- Navigate the filesystem
- Execute commands with correct syntax
- View command help and documentation

### Exercises

```bash
# 1.1 - Determine current location
pwd
# Expected output: Your current directory path

# 1.2 - Navigate to different directories
cd /tmp
pwd
cd /etc
pwd
cd ~
pwd
cd -
pwd  # Should show /etc (previous directory)

# 1.3 - List directory contents with different options
ls
ls -l
ls -la
ls -lh                        # Human-readable sizes
ls -lS                        # Sort by size
ls -lt                        # Sort by modification time
ls -ltr                       # Reverse time sort (oldest first)

# 1.4 - Create directory structure
cd ~
mkdir rhcsa_practice
mkdir -p rhcsa_practice/configs
mkdir -p rhcsa_practice/logs
mkdir -p rhcsa_practice/backups

# 1.5 - Verify structure
tree rhcsa_practice           # If tree is installed
ls -R rhcsa_practice          # Recursive listing

# 1.6 - Get command help
ls --help | head -20
grep --help | head -15
man ls                        # Press 'q' to exit

# 1.7 - Find command information
whatis ls
whatis grep
whatis tar
whereis bash
which cp
which sudo
```

### Expected Results
- Successfully navigate between directories
- Understand directory listing options
- Know how to access documentation

---

## Lab 2: Input-Output Redirection

### Objectives
- Master output redirection (>, >>)
- Master error redirection (2>)
- Combine stdout and stderr
- Use pipes to chain commands

### Exercises

```bash
# Setup
cd ~/rhcsa_practice
mkdir -p io_redirection
cd io_redirection

# 2.1 - Basic output redirection
ls /etc > directory_listing.txt
cat directory_listing.txt
wc -l directory_listing.txt

# 2.2 - Append to file
echo "Additional line 1" >> directory_listing.txt
echo "Additional line 2" >> directory_listing.txt
tail -3 directory_listing.txt

# 2.3 - Error redirection
ls /nonexistent 2> error.log
cat error.log                 # Shows "No such file or directory"

# 2.4 - Redirect both stdout and stderr
find / -name "test.txt" > find_output.txt 2> find_errors.txt 2>&1
# Alternative: find / -name "test.txt" &> find_all.txt

# 2.5 - Input redirection
sort < directory_listing.txt > sorted_listing.txt
head -5 sorted_listing.txt

# 2.6 - Here document
cat > sample_config.txt << 'EOF'
# This is a configuration file
# Created for RHCSA lab exercise
SERVER_NAME=rhcsa-lab
PORT=8080
DEBUG=true
EOF
cat sample_config.txt

# 2.7 - Pipes - Chain commands
# Count number of files
ls /etc | wc -l

# Find txt files and count them
find /etc -name "*.txt" | wc -l

# Search for pattern in file
grep "^[0-9]" directory_listing.txt | wc -l

# 2.8 - Complex piping
# Get sorted list of unique extensions
ls /etc | grep "\." | sed 's/.*\.//' | sort | uniq

# 2.9 - Using tee to save and display
ls /usr/bin | head -10 | tee user_binaries.txt
cat user_binaries.txt

# 2.10 - Discard output
ls /nonexistent > /dev/null 2>&1
# No output displayed, no error shown
```

### Verification Tasks
```bash
# Verify created files
ls -la *.txt
cat directory_listing.txt | head -5
wc -l *.txt
```

### Expected Results
- Multiple text files created with output
- Error log contains actual error message
- Pipes correctly filter and process data
- Sorted and unique data produced

---

## Lab 3: grep & Regular Expressions

### Objectives
- Use grep with various options
- Understand and apply regular expressions
- Search system files

### Exercises

```bash
# Setup
cd ~/rhcsa_practice
mkdir -p grep_practice
cd grep_practice

# 3.1 - Basic grep searches
grep "root" /etc/passwd
# Shows: root:x:0:0:...

# 3.2 - Count matches
grep -c "bin" /etc/passwd
# Shows number of lines with "bin"

# 3.3 - Display line numbers
grep -n "nologin" /etc/passwd | head -5

# 3.4 - Case-insensitive search
grep -i "ROOT" /etc/passwd

# 3.5 - Invert match (show non-matching)
grep -v "nologin" /etc/passwd | head -5
# Shows users with real shells

# 3.6 - Show context
grep -A 2 "^root:" /etc/passwd        # 2 lines after
grep -B 2 "^root:" /etc/passwd        # 2 lines before
grep -C 1 "^root:" /etc/passwd        # 1 line before and after

# 3.7 - Search files and show names
grep -l "bash" /etc/passwd /etc/group /etc/hosts
# Shows which files contain "bash"

# 3.8 - Show only matching part
echo "root:x:0:0:root:/root:/bin/bash" | grep -o "/bin/bash"

# 3.9 - Word boundaries
grep -w "bin" /etc/passwd
# Matches whole word "bin", not "bin" in "binary"

# 3.10 - Regular expression patterns

# Start of line
grep "^root" /etc/passwd

# End of line
grep "bash$" /etc/passwd

# Character class
grep "[aeiou]" /etc/hostname

# Exclude pattern
grep "^[^#]" /etc/ssh/sshd_config
# Show non-comment lines

# Digit pattern
grep "[0-9]" /etc/passwd

# Email-like pattern
echo "user@example.com" | grep -E "[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+"

# 3.11 - Extended regex with -E flag
grep -E "^(root|bin|daemon)" /etc/passwd
# Lines starting with root, bin, or daemon

# 3.12 - Multiple patterns
grep -E "error|warning|critical" /var/log/messages 2>/dev/null
# Show lines with any of these words

# 3.13 - Recursive search
grep -r "TODO" ~/rhcsa_practice/ 2>/dev/null
# Search all files in directory

# 3.14 - Create test file and practice
cat > test_data.txt << 'EOF'
User1:100:admin
User2:200:user
Admin1:50:admin
Admin2:60:admin
guest:1000:visitor
EOF

# Find admin users
grep "admin" test_data.txt

# Find IDs over 500
grep "[5-9][0-9][0-9]" test_data.txt

# Find lines starting with capital A
grep "^[A-Z]" test_data.txt
# or
grep "^A" test_data.txt
```

### Verification Tasks
```bash
# Verify all searches return expected results
grep -c "root" /etc/passwd
grep "^[0-9]" test_data.txt
grep -E "User|Admin" test_data.txt
```

### Expected Results
- Basic searches work correctly
- Regular expression patterns match appropriately
- Recursive searches find files
- Pattern matching is accurate

---

## Lab 4: SSH Key-Based Authentication

### Objectives
- Generate SSH key pair
- Configure password-less authentication
- Use SSH for remote execution
- Transfer files securely

### Exercises

```bash
# 4.1 - Generate SSH key pair
cd ~
ssh-keygen -t rsa -b 4096 -f ~/.ssh/rhcsa_key -N ""
# Creates: rhcsa_key (private) and rhcsa_key.pub (public)

# 4.2 - Verify key generation
ls -la ~/.ssh/rhcsa_key*
# Private key should be 600: -rw-------
# Public key should be 644: -rw-r--r--

# 4.3 - View public key
cat ~/.ssh/rhcsa_key.pub

# 4.4 - View private key (don't share!)
head ~/.ssh/rhcsa_key
# Starts with: -----BEGIN RSA PRIVATE KEY-----

# 4.5 - Set proper permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/rhcsa_key
chmod 644 ~/.ssh/rhcsa_key.pub
chmod 644 ~/.ssh/authorized_keys
# Verify
ls -la ~/.ssh/

# 4.6 - SSH config for key usage
cat > ~/.ssh/config << 'EOF'
Host localhost
    User $(whoami)
    IdentityFile ~/.ssh/rhcsa_key
    StrictHostKeyChecking no
EOF

chmod 600 ~/.ssh/config

# 4.7 - Test SSH locally (if SSH server is running)
# First enable SSH locally:
sudo systemctl start sshd 2>/dev/null || echo "SSH not available"

# Test connection
ssh -i ~/.ssh/rhcsa_key localhost "whoami" 2>/dev/null || \
    echo "Note: SSH server may not be running"

# 4.8 - Copy public key to authorized_keys (for local access)
cat ~/.ssh/rhcsa_key.pub >> ~/.ssh/authorized_keys

# 4.9 - Practice SCP syntax (even if remote host not available)
# Copy local to remote syntax
# scp -i ~/.ssh/rhcsa_key local_file user@host:/remote/path/

# Copy remote to local syntax
# scp -i ~/.ssh/rhcsa_key user@host:/remote/path/file ./local/path/

# 4.10 - Test with different ports
# ssh -p 2222 -i ~/.ssh/rhcsa_key user@host "command"
```

### Key Points to Remember
```bash
# Private key permissions: 600
# Public key permissions: 644
# SSH directory permissions: 700

# Key file should have meaningful content, not be empty
wc -c ~/.ssh/rhcsa_key
```

### Expected Results
- SSH key pair generated successfully
- Proper permissions set on all SSH files
- SSH directory structure correct
- Public key added to authorized_keys

---

## Lab 5: User Management

### Objectives
- View user information
- Switch users safely
- Use sudo effectively
- Understand user and group structure

### Exercises

```bash
# 5.1 - View current user
whoami
id
id -u                        # Just UID
id -g                        # Just GID
id -G                        # All groups

# 5.2 - View groups
groups
groups $(whoami)
cat /etc/group | grep "^sudo"

# 5.3 - Switch to another user (requires password unless sudo configured)
# su - testuser
# su -c "whoami"
# su - -c "pwd"

# 5.4 - Check sudo access
sudo -l
# Lists what you can run with sudo

# 5.5 - Practice sudo commands (if user has sudo access)
sudo whoami                  # Should show: root
sudo id                      # Root's id

# 5.6 - View sudoers file (read-only)
sudo cat /etc/sudoers | head -20
# Shows sudo configuration

# 5.7 - View sudoers.d directory
sudo ls -la /etc/sudoers.d/

# 5.8 - View all logged-in users
who
# Shows: username, terminal, login time, hostname

# 5.9 - More detailed user info
w
# Shows: who is logged in and what they're doing

# 5.10 - View login history
last
# Shows login history

# 5.11 - Check sudoers syntax (without editing)
sudo visudo -c
# Or: sudo /usr/sbin/visudo -c

# 5.12 - View environment as user
printenv | head -10
# Show environment variables

# 5.13 - View shell information
echo $SHELL
echo $HOME
echo $USER
```

### Safety Note
```bash
# NEVER directly edit /etc/sudoers
# ALWAYS use: sudo visudo
# This prevents syntax errors that could lock you out
```

### Expected Results
- User information displayed correctly
- Group membership shown
- Login history available
- Sudo access verified

---

## Lab 6: File Archiving & Compression

### Objectives
- Create tar archives
- Compress with gzip, bzip2, xz
- Extract archives correctly
- Verify archive integrity

### Exercises

```bash
# Setup
cd ~/rhcsa_practice
mkdir -p archive_lab
cd archive_lab

# Create test files
mkdir -p source_dir/subdir1
mkdir -p source_dir/subdir2
for i in {1..5}; do echo "File $i content" > source_dir/file$i.txt; done
for i in {1..3}; do echo "Subdir 1 file $i" > source_dir/subdir1/file$i.txt; done
for i in {1..2}; do echo "Subdir 2 file $i" > source_dir/subdir2/file$i.txt; done

# 6.1 - Create uncompressed tar
tar -cf archive.tar source_dir
ls -lh archive.tar

# 6.2 - Create gzip compressed tar (most common)
tar -czf archive.tar.gz source_dir
ls -lh archive.tar.gz

# 6.3 - Create bzip2 compressed tar (better compression)
tar -cjf archive.tar.bz2 source_dir
ls -lh archive.tar.bz2

# 6.4 - Create xz compressed tar (best compression)
tar -cJf archive.tar.xz source_dir
ls -lh archive.tar.xz

# 6.5 - Compare sizes
ls -lh archive.* | awk '{print $5, $9}'

# 6.6 - Verbose archive creation
tar -cvzf verbose_archive.tar.gz source_dir | head -15

# 6.7 - List archive contents
tar -tf archive.tar | head -10
tar -tzf archive.tar.gz | head -10
tar -tjf archive.tar.bz2 | head -10

# 6.8 - Detailed listing
tar -tvf archive.tar | head -10
tar -tvzf archive.tar.gz | head -10

# 6.9 - Extract archive
mkdir extract_test1
tar -xf archive.tar -C extract_test1
ls -la extract_test1

# 6.10 - Extract compressed archive
mkdir extract_test2
tar -xzf archive.tar.gz -C extract_test2
ls -la extract_test2

# 6.11 - Extract specific file
mkdir extract_test3
tar -xzf archive.tar.gz source_dir/file1.txt -C extract_test3
cat extract_test3/source_dir/file1.txt

# 6.12 - Standalone gzip
cp source_dir/file1.txt test_gzip.txt
gzip test_gzip.txt                      # Creates test_gzip.txt.gz
ls -la test_gzip.txt*                   # Original gone, only .gz remains
gunzip test_gzip.txt.gz                 # Restores original
ls -la test_gzip.txt

# 6.13 - Keep original when compressing
gzip -k source_dir/file1.txt            # Keep source
ls -la source_dir/file1.txt*

# 6.14 - Create dated backup
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
tar -czf backup_$BACKUP_DATE.tar.gz source_dir
ls -lh backup_*.tar.gz

# 6.15 - Verify archive integrity
tar -tzf archive.tar.gz > /dev/null && echo "Archive OK" || echo "Archive corrupt"

# 6.16 - Exclude files from archive
tar -czf archive_no_subdir1.tar.gz --exclude="subdir1" source_dir
tar -tzf archive_no_subdir1.tar.gz | grep subdir1  # Should show nothing

# 6.17 - Compression level with gzip
time gzip -1 -k source_dir/file1.txt   # Level 1 (fastest)
time gzip -9 -k source_dir/file1.txt   # Level 9 (best compression)
ls -lh source_dir/file1.txt*
```

### Verification Tasks
```bash
# Verify extraction worked
diff -r source_dir extract_test1/source_dir

# Count files in archive
tar -tzf archive.tar.gz | wc -l

# List largest files in archive
tar -tvzf archive.tar.gz | sort -k3 -rn | head -5
```

### Expected Results
- Archives created in all formats
- Compressed sizes different (xz smallest)
- Files extracted correctly
- Archive integrity verified

---

## Lab 7: Text File Creation & Editing

### Objectives
- Create text files with various methods
- Edit with vim and nano
- Use stream editors (sed)

### Exercises

```bash
# Setup
cd ~/rhcsa_practice
mkdir -p text_lab
cd text_lab

# 7.1 - Create file with cat and heredoc
cat > document.txt << 'EOF'
This is my document
It has multiple lines
Line 3: With content
Line 4: Still more content
EOF
cat document.txt

# 7.2 - Create file with echo
echo "Single line file" > single.txt
cat single.txt

# 7.3 - Append with echo
echo "Another line" >> single.txt
echo "Third line" >> single.txt
cat single.txt

# 7.4 - Create with printf
printf "Line 1\nLine 2\nLine 3\n" > printf_file.txt
cat printf_file.txt

# 7.5 - Create empty file
touch empty.txt
ls -la empty.txt

# 7.6 - Create file in vim (automated)
# Note: Automated vim is tricky, here's a method:
echo -e "#!/bin/bash\necho Created with vim" > vim_file.txt

# 7.7 - View files with cat
cat document.txt

# 7.8 - View with line numbers
cat -n document.txt
nl document.txt

# 7.9 - View first/last lines
head -2 document.txt                # First 2 lines
tail -2 document.txt                # Last 2 lines

# 7.10 - View with more/less
# more document.txt
# less document.txt
# (Pagers require interactive terminal)

# 7.11 - Text substitution with sed
echo "old text" > sed_test.txt
sed 's/old/new/' sed_test.txt      # Display with replacement
sed -i 's/old/new/g' sed_test.txt  # In-place edit
cat sed_test.txt

# 7.12 - Delete lines with sed
cat > sed_delete.txt << 'EOF'
# Comment 1
Data 1
# Comment 2
Data 2
Data 3
EOF
sed '/^#/d' sed_delete.txt         # Delete comment lines
sed '2d' sed_delete.txt            # Delete line 2

# 7.13 - Extract lines with sed
sed -n '2,4p' document.txt         # Print lines 2-4

# 7.14 - Create config file
cat > app.conf << 'EOF'
# Application Configuration
SERVER_HOST=localhost
SERVER_PORT=8080
DEBUG=false
LOG_LEVEL=info
EOF
cat app.conf

# 7.15 - Edit config with sed
sed -i 's/DEBUG=false/DEBUG=true/' app.conf
sed -i 's/SERVER_PORT=8080/SERVER_PORT=9090/' app.conf
cat app.conf

# 7.16 - Add lines to file
echo "New line at end" >> document.txt
cat document.txt

# 7.17 - Compare files
cat > file1.txt << 'EOF'
Line A
Line B
Line C
EOF

cat > file2.txt << 'EOF'
Line A
Line B modified
Line D
EOF

diff file1.txt file2.txt
```

### Practical vim Usage
```bash
# Create file with vim (manual in exam):
# vim filename.txt
# Then in vim:
# i                    (enter insert mode)
# Type your content
# ESC                  (exit insert mode)
# :wq                  (save and quit)

# For practice, use a script:
cat > create_vim_file.sh << 'EOF'
#!/bin/bash
vim -c "%s/.*/Initial content/" -c "wq" vim_test.txt
EOF
bash create_vim_file.sh
cat vim_test.txt
```

### Expected Results
- Multiple text files created with different methods
- Files edited and modified successfully
- sed commands work on files
- Config files created and updated

---

## Lab 8: File & Directory Operations

### Objectives
- Copy, move, delete files and directories
- Use file globbing patterns
- Manage file attributes

### Exercises

```bash
# Setup
cd ~/rhcsa_practice
mkdir -p file_ops_lab
cd file_ops_lab

# Create test files
mkdir -p source_files
touch source_files/file1.txt source_files/file2.txt
touch source_files/document.pdf source_files/script.sh
mkdir -p source_files/subdir
touch source_files/subdir/nested.txt

# 8.1 - List files with globbing
ls source_files/*.txt                   # All .txt files
ls source_files/file[12].txt            # file1 or file2
ls source_files/*.{txt,pdf}             # .txt or .pdf
ls source_files/[^s]*.txt               # Not starting with 's'

# 8.2 - Copy single file
cp source_files/file1.txt copied_file.txt
ls -la copied_file.txt

# 8.3 - Copy multiple files
cp source_files/*.txt ./
ls -la *.txt

# 8.4 - Copy with options
cp -v source_files/file1.txt verbose_copy.txt  # Verbose
cp -i source_files/file1.txt interactive_copy.txt  # Interactive
cp -p source_files/file1.txt preserve_copy.txt # Preserve perms
ls -la preserve_copy.txt

# 8.5 - Copy directory
cp -r source_files copied_directory
ls -la copied_directory/
ls -R copied_directory/

# 8.6 - Archive copy (preserves everything)
cp -a source_files archive_copy
diff -r source_files archive_copy

# 8.7 - Move/Rename file
mv copied_file.txt renamed_file.txt
ls -la renamed_file.txt
# Original gone, file renamed

# 8.8 - Move file to directory
mv verbose_copy.txt copied_directory/
ls -la copied_directory/
ls -la verbose_copy.txt 2>/dev/null || echo "File moved"

# 8.9 - Delete files
rm interactive_copy.txt
rm renamed_file.txt
rm preserve_copy.txt
ls *.txt 2>/dev/null || echo "All .txt copies deleted"

# 8.10 - Delete directory
rm -r copied_directory
ls -la copied_directory 2>/dev/null || echo "Directory deleted"

# 8.11 - Delete with confirmation
echo "test" > test_delete.txt
rm -i test_delete.txt
# Choose 'n' to cancel or 'y' to confirm

# 8.12 - Find and delete
find . -name "*.txt" -type f
find . -name "*.txt" -type f -delete

# 8.13 - Touch to update timestamps
touch source_files/file1.txt
stat source_files/file1.txt | grep Modify

# 8.14 - File type detection
file source_files/file1.txt
file source_files/script.sh
file source_files/document.pdf

# 8.15 - Get file info
stat source_files/file1.txt
wc source_files/file1.txt
du -h source_files/file1.txt
```

### Path Handling
```bash
# 8.16 - Absolute vs relative paths
pwd                                     # Absolute current
ls -la ./source_files                   # Relative current
ls -la ~/rhcsa_practice/file_ops_lab    # Absolute home
ls -la /home/$(whoami)/rhcsa_practice   # Absolute full

# 8.17 - Navigate with cd
cd source_files
pwd
cd ..
pwd
cd -
pwd  # Previous directory
```

### Expected Results
- Files copied and moved correctly
- Directories created and copied
- Globbing patterns work
- File operations complete successfully

---

## Lab 9: Hard & Soft Links

### Objectives
- Create symbolic (soft) links
- Create hard links
- Understand link differences
- Verify link integrity

### Exercises

```bash
# Setup
cd ~/rhcsa_practice
mkdir -p links_lab
cd links_lab

# Create test file
echo "Original content" > original_file.txt

# 9.1 - Create symbolic link
ln -s original_file.txt symbolic_link.txt
ls -la symbolic_link.txt
# Shows: symbolic_link.txt -> original_file.txt

# 9.2 - View symbolic link content
cat symbolic_link.txt
# Same as original

# 9.3 - Remove symbolic link (doesn't affect original)
rm symbolic_link.txt
ls -la original_file.txt    # Still exists
cat original_file.txt       # Still readable

# 9.4 - Create hard link
ln original_file.txt hard_link.txt
ls -la original_file.txt hard_link.txt
# Shows same inode number

# 9.5 - Check inode numbers
ls -i original_file.txt hard_link.txt
# Same inode = hard link

# 9.6 - Verify hard link contents
cat hard_link.txt
# Same as original

# 9.7 - Edit through hard link
echo "Modified content" >> hard_link.txt
cat original_file.txt       # Shows modification!

# 9.8 - Delete hard link
rm original_file.txt
ls -la hard_link.txt        # Still exists with data
cat hard_link.txt           # Still readable

# 9.9 - Delete hard link
rm hard_link.txt
ls -la original_file.txt 2>/dev/null || echo "File completely gone"

# 9.10 - Soft link to directory
mkdir test_directory
ln -s test_directory link_to_dir
ls -la link_to_dir
cd link_to_dir
pwd
cd ..

# 9.11 - Broken soft link
ln -s /nonexistent/path broken_link
ls -la broken_link
# Shows: broken_link -> /nonexistent/path (in red, usually)
cat broken_link 2>&1
# Error: No such file or directory

# 9.12 - Readlink to show target
readlink symbolic_link 2>/dev/null || echo "Link not current"
# When link exists
ln -s original_file.txt sym_link
readlink sym_link

# 9.13 - Multiple links to same file
ln -s test_directory link1
ln -s test_directory link2
ls -la link1 link2

# 9.14 - Chain of symbolic links
ln -s sym_link chain_link
readlink chain_link
readlink -f chain_link  # Follow all links to final target

# 9.15 - Practical use case
# Create link for convenience
ln -s /etc/ssh/sshd_config sshd_config
cat sshd_config | head -5

# Create link for compatibility
ln -s /usr/bin/python3 python
./python --version 2>/dev/null || echo "Python link would work on system with Python"
```

### Link Comparison
```bash
# 9.16 - Compare link types
echo "Test file" > compare_file.txt
ln compare_file.txt hard.txt
ln -s compare_file.txt soft.txt

# Show all details
ls -li compare_file.txt hard.txt soft.txt

# Edit and verify
echo "Added line" >> soft.txt
cat compare_file.txt  # Changed!

echo "Added to hard" >> hard.txt
cat compare_file.txt  # Also changed!

# Delete original
rm compare_file.txt
ls -la hard.txt       # Still works! Data intact
ls -la soft.txt       # Broken link, can't read
```

### Expected Results
- Symbolic links created and work
- Hard links created with same inode
- Broken links identified
- Hard link data persists after original deleted

---

## Lab 10: File Permissions

### Objectives
- Understand ugo/rwx permissions
- Change permissions symbolically
- Change permissions numerically
- Understand special bits

### Exercises

```bash
# Setup
cd ~/rhcsa_practice
mkdir -p perms_lab
cd perms_lab

# Create test files
echo "Test file" > testfile.txt
mkdir testdir

# 10.1 - View permissions
ls -l testfile.txt
ls -ld testdir

# 10.2 - Understand permission display
# drwxr-xr-x = directory, user rwx, group r-x, other r-x
# -rw-r--r-- = file, user rw-, group r--, other r--

# 10.3 - Add permissions (symbolic)
chmod u+x testfile.txt
ls -l testfile.txt
# Now: -rwxr--r--

# 10.4 - Remove permissions
chmod g-r testfile.txt
ls -l testfile.txt
# Now: -rwx---r--

# 10.5 - Set exact permissions
chmod u=rwx,g=rx,o=r testfile.txt
ls -l testfile.txt
# Now: -rwxr-xr--

# 10.6 - Add to group and others
chmod go+w testfile.txt
ls -l testfile.txt
# Now: -rwxrwxrw-

# 10.7 - Remove all execute
chmod a-x testfile.txt
ls -l testfile.txt
# All x bits removed

# 10.8 - Numeric permissions (octal)
# r=4, w=2, x=1
# 7=rwx, 5=r-x, 4=r--, 0=---

# Set to 755 (rwxr-xr-x)
chmod 755 testfile.txt
ls -l testfile.txt

# Set to 644 (rw-r--r--)
chmod 644 testfile.txt
ls -l testfile.txt

# Set to 600 (rw-------)
chmod 600 testfile.txt
ls -l testfile.txt

# Set to 777 (rwxrwxrwx)
chmod 777 testdir
ls -ld testdir

# 10.9 - Directory permissions
# For directories:
# r = list contents
# w = create/delete files in directory
# x = can cd into directory

chmod 755 testdir
ls -ld testdir

# 10.10 - Recursive permissions
mkdir -p recursive_test/dir1/dir2
touch recursive_test/file1.txt
touch recursive_test/dir1/file2.txt

# Change all recursively
chmod -R 755 recursive_test
find recursive_test -type f -exec ls -l {} \;
find recursive_test -type d -exec ls -ld {} \;

# 10.11 - Different permissions for files and dirs
# Files: 644
# Directories: 755
chmod -R u=rwx,g=rx,o=rx recursive_test  # All get rx
find recursive_test -type f -exec chmod 644 {} \;  # Files only

# 10.12 - Change ownership
# Note: Requires sudo or own files
sudo chown root:root testfile.txt 2>/dev/null || echo "Needs sudo"
ls -l testfile.txt

# Change group only
# sudo chgrp group_name testfile.txt

# 10.13 - Change ownership recursively
# sudo chown -R newuser:newgroup directory

# 10.14 - Umask (default permissions)
umask
# Shows current umask (usually 0022)

# Create file and check permissions
touch umask_test.txt
ls -l umask_test.txt
# Shows: -rw-r--r-- (666 - 022 = 644)

# Create directory and check
mkdir umask_dir
ls -ld umask_dir
# Shows: drwxr-xr-x (777 - 022 = 755)

# 10.15 - Special permissions (advanced)

# Setuid (4000) - run as owner
# echo "Content" > setuid_file
# chmod 4755 setuid_file
# ls -l setuid_file
# Shows: -rwsr-xr-x (s = setuid)

# Setgid (2000) - files inherit group
# chmod 2755 testdir
# ls -ld testdir
# Shows: drwxr-sr-x (s = setgid)

# Sticky bit (1000) - only owner can delete
chmod 1777 testdir
ls -ld testdir
# Shows: drwxrwxrwt (t = sticky bit)

# 10.16 - Execute for directories
mkdir execute_test
chmod 744 execute_test
# Can't cd into it (need execute)
cd execute_test 2>&1 || echo "No execute - can't enter"
cd ..
chmod 755 execute_test
# Can cd now
```

### Verification
```bash
# Verify permissions
ls -l testfile.txt
ls -ld testdir

# Verify numeric equivalents
stat testfile.txt | grep Access
```

### Expected Results
- Permissions changed correctly
- Symbolic notation works
- Numeric (octal) notation works
- Directory vs file permissions understood

---

## Lab 11: System Documentation

### Objectives
- Navigate man pages
- Use info pages
- Find system documentation
- Get command help

### Exercises

```bash
# 11.1 - View man page
man ls                      # Press 'q' to quit
# Navigation in less:
#   Space = next page
#   b = previous page
#   / = search
#   n = next match
#   q = quit

# 11.2 - Search man index
man -k permission
man -k directory

# 11.3 - View specific man section
# Section 1 = user commands
# Section 5 = file formats
man 5 passwd                # passwd file format
man 5 crontab              # crontab format
man 8 sshd                 # SSH daemon

# 11.4 - Get one-line description
whatis ls
whatis grep
whatis tar
whatis chmod

# 11.5 - Find location of command
whereis ls
whereis bash
whereis python

# Just show binary
whereis -b bash

# 11.6 - Show path to command
which ls
which python
which python3

# 11.7 - Get command help
ls --help
grep --help
tar --help
# Much shorter than man page

# 11.8 - View info pages
info coreutils              # GNU core utilities
info bash                   # Bash shell
# Navigation:
#   Space = next page
#   Backspace = previous
#   Tab = next link
#   Enter = follow link
#   n = next chapter
#   p = previous chapter
#   u = up
#   q = quit

# 11.9 - Browse documentation directory
ls /usr/share/doc/
ls /usr/share/doc/bash/
ls /usr/share/doc/openssh-clients/ 2>/dev/null

# 11.10 - Read documentation files
ls -la /usr/share/doc/bash/ 2>/dev/null || echo "Check docs directory"

# 11.11 - Search all man pages for keyword
man -k ssh
man -k file
man -k permission

# 11.12 - Determine what a command does
file /bin/ls
file /usr/share/doc/

# 11.13 - Show command type
type ls                    # Shell built-in or external
type cd                    # Shell built-in
type python                # External command

# 11.14 - Get help for shell built-ins
help cd
help echo
help set

# 11.15 - Browse apropos
# apropos "change" 
# Shows commands related to "change"
```

### Key Documentation Files
```bash
# Important RHCSA documentation
man chmod
man chown
man tar
man ssh
man grep
man sed
man awk
man find
man systemctl
man journalctl
man /etc/ssh/sshd_config
```

### Expected Results
- Man pages navigated successfully
- Commands found with which/whereis
- Documentation located
- Help retrieved for commands

---

## Comprehensive Integration Lab

### Multi-skill Exercise

This lab combines multiple skills from previous exercises.

```bash
#!/bin/bash
# Integration Lab - Complete scenario

# Setup
BASE_DIR="$HOME/rhcsa_practice/integration_lab"
mkdir -p "$BASE_DIR"
cd "$BASE_DIR"

echo "=== RHCSA Integration Lab ==="
echo

# 1. Create directory structure
echo "Step 1: Creating directory structure..."
mkdir -p project/{src,backup,logs,config}
cd project

# 2. Create sample files
echo "Step 2: Creating sample files..."
cat > config/app.conf << 'EOF'
# Application Configuration
APP_NAME=RHCSA_App
VERSION=1.0
DEBUG=true
LOG_LEVEL=debug
DATABASE=localhost:5432
EOF

cat > src/main.sh << 'EOF'
#!/bin/bash
echo "Application started"
echo "Running in $(pwd)"
EOF

chmod +x src/main.sh

# Create more files for archiving
for i in {1..5}; do
    echo "Data file $i" > src/data_$i.txt
done

# 3. Use grep to search files
echo "Step 3: Searching files with grep..."
grep -r "APP_NAME" config/
grep -r "data" src/

# 4. Redirect operations
echo "Step 4: Demonstrating I/O redirection..."
ls src/ > logs/file_list.txt
find . -name "*.txt" >> logs/file_list.txt
cat logs/file_list.txt

# 5. Create archives
echo "Step 5: Creating archives..."
tar -czf backup/project_$(date +%Y%m%d).tar.gz src/ config/
ls -lh backup/

# 6. Create links
echo "Step 6: Creating links..."
ln -s config/app.conf latest_config
ln -s backup/project_*.tar.gz latest_backup
ls -la latest_*

# 7. Set permissions
echo "Step 7: Setting permissions..."
chmod 755 src/
chmod 644 src/*.sh
chmod 600 config/app.conf
ls -la config/app.conf
ls -la src/

# 8. Extract archive
echo "Step 8: Extracting archive..."
mkdir -p backup/extract_test
tar -xzf backup/project_*.tar.gz -C backup/extract_test
ls -la backup/extract_test/

# 9. User operations
echo "Step 9: User information..."
echo "Current user: $(whoami)"
echo "User ID: $(id -u)"
echo "Groups: $(groups)"

# 10. Documentation
echo "Step 10: Getting help..."
man -w tar 2>/dev/null || echo "tar manual available"
whatis tar
which tar

# 11. Final verification
echo
echo "=== Lab Completion Summary ==="
echo "Files created: $(find . -type f | wc -l)"
echo "Directories: $(find . -type d | wc -l)"
echo "Archive size: $(du -sh backup/ | awk '{print $1}')"
echo "Config permissions: $(stat -c '%a' config/app.conf)"

echo
echo "Lab complete!"
```

### Running the Integration Lab

```bash
cd ~/rhcsa_practice
# Copy the script or create it manually
# Then run:
bash integration_lab.sh

# Or run step by step for learning
```

---

## Exam Practice Checklist

- [ ] Master shell commands (ls, cd, pwd, mkdir, rm, cp, mv)
- [ ] Understand I/O redirection (>, >>, 2>, &>, |)
- [ ] Use grep effectively (patterns, options, regular expressions)
- [ ] Configure SSH keys (generation, permissions, setup)
- [ ] Manage users and permissions (chmod, chown, sudoers)
- [ ] Archive files (tar, gzip, bzip2)
- [ ] Edit text files (vim, nano, echo, sed)
- [ ] Create and use links (symbolic, hard)
- [ ] View system documentation (man, info, help)
- [ ] Combine multiple commands for complex tasks

---

## Tips for Exam Success

1. **Read questions carefully** - Understand exactly what's asked
2. **Use man pages** - They're your best resource during exam
3. **Test your commands** - Verify they work before moving on
4. **Backup before changes** - Always create backups of important files
5. **Check permissions** - Many tasks involve correct permissions
6. **Time management** - Don't spend too long on one task
7. **Combine skills** - Most real tasks require multiple skills
8. **Practice regularly** - Repetition builds muscle memory
9. **Understand errors** - Learn from failures
10. **Verify output** - Make sure commands produce expected results

---

Good luck with your RHCSA exam preparation!
