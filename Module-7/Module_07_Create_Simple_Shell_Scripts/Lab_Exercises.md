# Module 7 Lab Exercises: Create Simple Shell Scripts

Run these labs as a normal user in a disposable environment. The exercises are intentionally harmless and do not change system configuration.

## Lab 1: Create and Execute a Script
1. Create `host-report.sh` with a Bash shebang.
2. Print the hostname and current date using `printf` and command substitution.
3. Run it with `bash host-report.sh`.
4. Add executable permission and run `./host-report.sh`.
5. Validate syntax with `bash -n host-report.sh`.

**Verify:** The output is correct and direct execution works from the current directory.

## Lab 2: Validate Positional Arguments
Write `check-path.sh` to require exactly one argument. On incorrect usage, print `Usage: SCRIPT PATH` to stderr and exit with status 2. For the supplied path, report whether it exists; return 0 if it exists and 1 otherwise.

Test no arguments, too many arguments, an existing path, and a missing path. Check each exit status immediately.

**Verify:** A path containing spaces is handled as one argument.

## Lab 3: Conditions and Tests
Write a script accepting a path and distinguish regular files, directories, symbolic links, and other/missing paths. Use `[[ ... ]]` and quote the expansion. Print the result without modifying the target.

**Verify:** Test each type, including a broken symbolic link (use `-L` before `-e`).

## Lab 4: Loop Over Arguments
Write `count-lines.sh` to loop over every `"$@"`, count lines in regular files, report invalid inputs to stderr, and continue processing later inputs. Test multiple files and a filename with spaces.

**Verify:** No arguments prints a usage line and returns nonzero; valid arguments retain their boundaries.

## Lab 5: Process Command Output
Write `service-report.sh` to capture the hostname with `$(hostname)` and loop over a list of harmless service names such as `sshd` and `chronyd`. Use `systemctl is-active --quiet` in an `if` condition and report each service state. Do not start, stop, or enable services.

**Verify:** Script output includes host and status; service absence is reported without aborting the entire loop.

## Lab 6: Process a Line-Oriented Input File
Create a text file with usernames, blank lines, and a username with leading/trailing spaces. Write a script using `while IFS= read -r` to skip blank lines and check each username with `getent passwd`. Report present/missing users.

**Verify:** Whitespace handling is intentional and no `for item in $(cat file)` parsing is used.

## Lab 7: Integrated Exam-Style Script
Write `account-audit.sh` accepting one or more usernames. Validate that at least one argument was given; capture the local hostname; loop over all arguments; use `getent passwd` and `id` to report account state. Missing users should be reported to stderr. Return nonzero if any user is missing while still processing all arguments.

**Verify:** Test zero, one, multiple, existing, missing, and spaced arguments. Check `bash -n`, executable permission, output streams, and exit status.
