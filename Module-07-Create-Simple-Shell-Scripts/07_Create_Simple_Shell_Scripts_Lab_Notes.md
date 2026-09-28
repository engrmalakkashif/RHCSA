# RHCSA Module 7: Create Simple Shell Scripts
## Comprehensive Lab Notes & Reference Guide

This module focuses only on the scripting objectives: create and execute simple scripts, use conditionals and tests, loop over files or arguments, accept positional input, and process command output. Examples use Bash. Practice scripts should be safe and repeatable.

## Contents
1. Script files and execution
2. Variables, quoting, and exit statuses
3. Conditions and tests
4. Positional parameters
5. Loops over arguments and files
6. Processing command output
7. Input streams and line processing
8. Debugging and exam verification

## 1. Script Files and Execution

A script is a text file containing commands. The shebang selects an interpreter when executing the file directly. On RHEL, `/usr/bin/bash` is a predictable Bash path.

```bash
#!/usr/bin/bash

printf 'Hello from %s\n' "$(hostname)"
```

Run through Bash without an executable bit, or make the file executable and invoke its path:

```bash
bash hello.sh
chmod u+x hello.sh
./hello.sh
```

The current directory is usually not in `PATH`, so use `./script.sh` to run from the current directory. Use LF line endings and ensure the shebang is the first line.

## 2. Variables, Quoting, and Exit Statuses

Assignments contain no spaces around `=`. Expand variables with `$name` or `${name}`. Quote expansions, especially paths and arguments, to prevent word splitting and wildcard expansion.

```bash
report_file="/tmp/system report.txt"
printf 'Host: %s\n' "$(hostname)" > "$report_file"
```

A command returns an exit status: zero typically means success, nonzero signals failure. `$?` contains the most recent command's status; test it immediately or use a command directly in an `if` condition.

```bash
if id "$user" >/dev/null 2>&1; then
    printf 'User exists: %s\n' "$user"
else
    printf 'User not found: %s\n' "$user" >&2
fi
```

Use `exit 0` for success and a nonzero value for usage errors or failures. Send diagnostics to stderr with `>&2`.

## 3. Conditions and Tests

Bash's `[[ ... ]]` supports string comparisons, integer comparisons, and file tests. POSIX `test` and `[ ... ]` are also common; the spaces after `[` and before `]` are required.

```bash
if [[ -L "$path" ]]; then
    printf 'Symbolic link\n'
elif [[ -e "$path" ]]; then
    printf 'Path exists\n'
else
    printf 'Path does not exist\n'
fi
```

Common file tests: `-e` exists, `-f` regular file, `-d` directory, `-L` symbolic link, `-r` readable, `-w` writable, `-x` executable. String examples: `[[ -n "$value" ]]`, `[[ "$a" == "$b" ]]`. Integer examples: `[[ $count -ge 1 ]]`, `[[ $count -eq 0 ]]`.

Use arithmetic contexts for counters:

```bash
if (( count > 0 )); then
    printf 'Positive count: %d\n' "$count"
fi
```

Validate required input before using it. Test syntax with `bash -n script.sh` before executing.

## 4. Positional Parameters

`$0` is the script name; `$1`, `$2`, and so on are positional arguments. `$#` is the argument count. `"$@"` expands to each argument as a separate word and should generally be quoted in loops. `"$*"` joins arguments into one string and is rarely appropriate for preserving argument boundaries.

```bash
if [[ $# -ne 2 ]]; then
    printf 'Usage: %s SOURCE DESTINATION\n' "$0" >&2
    exit 2
fi
source_path=$1
destination_path=$2
```

Use `shift` to consume arguments in order. Do not use `eval` to interpret user input.

## 5. Loops Over Arguments and Files

A `for` loop can process each command-line argument:

```bash
for path in "$@"; do
    if [[ -f "$path" ]]; then
        printf '%s: ' "$path"
        wc -l < "$path"
    else
        printf 'Not a regular file: %s\n' "$path" >&2
    fi
done
```

A loop can process a fixed set or glob, but handle the no-match case deliberately. To read arbitrary file names or lines, avoid parsing `ls`; use a safe input loop and `find -print0` with `read -d ''` when file names may contain newlines.

```bash
while IFS= read -r line; do
    printf 'Line: %s\n' "$line"
done < "$input_file"
```

`IFS=` prevents trimming leading/trailing whitespace; `read -r` prevents backslash interpretation. Redirecting into the loop keeps it in the current shell, so loop-updated variables remain available afterward.

## 6. Processing Command Output

Command substitution captures standard output:

```bash
current_host=$(hostname)
printf 'Host is %s\n' "$current_host"
```

It removes trailing newline characters and can be quoted safely when stored in a variable. For output containing many lines, use a pipeline or redirection rather than storing the entire stream in one scalar.

```bash
if getent passwd "$user" >/dev/null; then
    printf '%s\n' "$(id "$user")"
fi

for service in sshd chronyd; do
    if systemctl is-active --quiet "$service"; then
        printf '%s is active\n' "$service"
    else
        printf '%s is not active\n' "$service"
    fi
done
```

Use `$(...)`, not legacy backticks. Distinguish stdout data from stderr diagnostics and check command status.

## 7. Input Streams and Line Processing

A script can receive input from a file, pipeline, or standard input. Avoid `for x in $(command)` for line-oriented output: whitespace in values will split data.

```bash
while IFS= read -r username; do
    [[ -z "$username" ]] && continue
    if getent passwd "$username" >/dev/null; then
        printf 'present: %s\n' "$username"
    else
        printf 'missing: %s\n' "$username"
    fi
done < users.txt
```

When consuming a pipeline, `while` may execute in a subshell in Bash; variables assigned inside may not survive after the loop. Prefer input redirection from a file or process substitution when subsequent code needs those variables.

## 8. Debugging and Exam Verification

Use syntax and trace checks:

```bash
bash -n script.sh
bash -x script.sh ARG
```

Before finalizing, verify: interpreter line, executable permissions if direct execution is required, argument count/validation, correct quoting, success/failure exit codes, stderr for errors, and safe behavior with spaces and missing input. Run the script with valid, invalid, empty, and multi-argument cases. Avoid `set -e` as a substitute for understanding and checking command failures.
