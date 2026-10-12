#!/bin/bash

# ============================================================
# LINUX SERVER HEALTH CHECKER
# Created by: Kashif Khan
# ============================================================
#
# WHAT THIS SCRIPT TEACHES
#
# 1. Shebang
#    #!/bin/bash
#    Tells Linux to execute this script using Bash.
#
# 2. Shell Safety
#    set -euo pipefail
#    -e  Stop when a command fails.
#    -u  Treat unset variables as errors.
#    pipefail  Make a pipeline fail if any command fails.
#
# 3. Variables
#    LIMIT=80
#    Stores the default disk/memory warning threshold.
#
# 4. Command-line Arguments
#    $0  Script name.
#    $1  First argument.
#    $#  Number of arguments.
#
# 5. Parameter Expansion
#    ${1:-}
#    Uses $1 if available; otherwise uses an empty value.
#
# 6. case
#    Used to handle different command-line options such as
#    -h, --help and unknown options.
#
# 7. Functions
#    Functions group related commands into reusable blocks.
#
#    check_disk
#    check_memory
#    check_uptime
#    check_load
#    check_ssh
#
# 8. Conditions
#    if / else
#    Used to determine whether a health check is OK or WARNING.
#
# 9. Regular Expression
#    ^[0-9]+$
#    Ensures the threshold contains only digits.
#
# 10. Command Substitution
#     $(command)
#     Captures command output into a variable.
#
# 11. Pipelines
#     command1 | command2 | command3
#     Passes the output of one command to another command.
#
# 12. Exit Codes
#     exit 0  = successful execution
#     exit 1  = error
#
# 13. Commands Used
#     hostname  → system hostname
#     date      → current date/time
#     df        → disk usage
#     free      → memory usage
#     uptime    → uptime and load average
#     awk       → text processing/calculation
#     cut       → extract fields
#     tr        → modify/delete characters
#     xargs     → remove extra whitespace
#     systemctl → manage/check systemd services
#
# USAGE
#
#     ./server-health.sh
#     ./server-health.sh 70
#     ./server-health.sh -h
#     ./server-health.sh --help
#
# ============================================================


# ------------------------------------------------------------
# SHELL SAFETY
# ------------------------------------------------------------

set -euo pipefail


# ------------------------------------------------------------
# DEFAULT CONFIGURATION
# ------------------------------------------------------------

LIMIT=80
LOAD_LIMIT=2


# ------------------------------------------------------------
# FUNCTIONS
# ------------------------------------------------------------

show_help()
{
    echo "Usage: $0 [THRESHOLD]"
    echo
    echo "Linux Server Health Checker"
    echo
    echo "Description:"
    echo "  Checks disk, memory, system load and SSH service."
    echo
    echo "Arguments:"
    echo "  THRESHOLD    Warning threshold for disk and memory."
    echo "               Default: 80"
    echo
    echo "Options:"
    echo "  -h, --help   Show this help message"
}


check_disk()
{
    echo
    echo "Disk Usage:"

    df -h /

    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

    if [ "$disk_usage" -ge "$LIMIT" ]; then
        echo "Disk Status : WARNING ($disk_usage%)"
    else
        echo "Disk Status : OK ($disk_usage%)"
    fi
}


check_memory()
{
    echo
    echo "Memory Usage:"

    free -h

    memory_usage=$(free | awk '/Mem:/ {printf "%.0f\n", $3/$2 * 100}')

    if [ "$memory_usage" -ge "$LIMIT" ]; then
        echo "Memory Status: WARNING ($memory_usage%)"
    else
        echo "Memory Status: OK ($memory_usage%)"
    fi
}


check_uptime()
{
    echo
    echo "System Uptime:"

    uptime
}


check_load()
{
    load=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | xargs)

    if awk "BEGIN {exit !($load >= $LOAD_LIMIT)}"; then
        echo "Load Status : WARNING ($load)"
    else
        echo "Load Status : OK ($load)"
    fi
}


check_ssh()
{
    echo
    echo "SSH Service:"

    if systemctl is-active --quiet ssh; then
        echo "SSH Status : OK (RUNNING)"
    else
        echo "SSH Status : CRITICAL (STOPPED)"
    fi
}


# ------------------------------------------------------------
# ARGUMENT VALIDATION
# ------------------------------------------------------------

if [ "$#" -gt 1 ]; then
    echo "ERROR: Too many arguments."
    echo "Usage: $0 [THRESHOLD]"
    exit 1
fi


# ------------------------------------------------------------
# ARGUMENT PARSING
# ------------------------------------------------------------

case "${1:-}" in

    -h|--help)
        show_help
        exit 0
        ;;

    -*)
        echo "ERROR: Unknown option: $1"
        echo "Usage: $0 [THRESHOLD]"
        echo "Use '$0 --help' for more information."
        exit 1
        ;;

    *)
        if [ "$#" -eq 1 ]; then
            LIMIT="$1"
        fi
        ;;
esac


# ------------------------------------------------------------
# THRESHOLD VALIDATION
# ------------------------------------------------------------

if ! [[ "$LIMIT" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Threshold must be a number between 0 and 100."
    exit 1
fi

if [ "$LIMIT" -gt 100 ]; then
    echo "ERROR: Threshold cannot be greater than 100."
    exit 1
fi


# ------------------------------------------------------------
# HEADER
# ------------------------------------------------------------

echo "========================================"
echo "       LINUX SERVER HEALTH CHECK"
echo "========================================"
echo "Script Name : server-health.sh"
echo "Created By  : Kashif Khan"
echo "Maintainer  : DevOps Engineer"
echo "Purpose     : Linux Server Health Monitoring"
echo "Version     : 1.0"
echo "Date        : 05/10/2025"
echo "Description : Checks disk, memory, uptime, and SSH status"
echo "========================================"
echo "Hostname    : $(hostname)"
echo "Date/Time   : $(date)"
echo "Threshold   : ${LIMIT}%"
echo "======================================"
# ------------------------------------------------------------
# RUN HEALTH CHECKS
# ------------------------------------------------------------

check_disk
check_memory
check_uptime
check_load
check_ssh


# ------------------------------------------------------------
# END
# ------------------------------------------------------------

echo
echo "========================================"
echo "          HEALTH CHECK COMPLETE"
echo "========================================"
