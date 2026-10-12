#!/bin/bash
# ============================================================
# Script: vote.sh
# Purpose: Ask the user for their age and tell them whether
#          they can vote (age >= 18).
# Features:
#   - Keeps asking until a valid number is entered
#   - Allows the user to quit by typing 'q' or 'Q'
#   - Rejects ages greater than 100 as invalid input
# ============================================================

# ------------------------------------------------------------
# Start an infinite loop.
# We will only leave this loop in two ways:
#   1. The user types 'q' or 'Q'      -> exit the script
#   2. The user enters a valid age    -> break out and check it
# ------------------------------------------------------------
while true; do

    # --------------------------------------------------------
    # Prompt the user and read their input into the variable
    # "input".
    #   -p    -> prints the prompt on the same line as the cursor
    #   input -> name of the variable that stores what they type
    # --------------------------------------------------------
    read -p "Enter your age (or type 'q' to quit): " input

    # --------------------------------------------------------
    # Check if the user wants to quit.
    #   "$input" = "q"  ||  "$input" = "Q"
    # Accepts either lowercase or uppercase Q.
    # --------------------------------------------------------
    if [ "$input" = "q" ] || [ "$input" = "Q" ]; then
        echo "Goodbye!"
        exit 0
    fi

    # --------------------------------------------------------
    # Validate that the input is a pure number.
    #   ^[0-9]+$  -> whole string must be one or more digits
    #   !         -> negate: "if NOT a number, then..."
    # --------------------------------------------------------
    if ! [[ "$input" =~ ^[0-9]+$ ]]; then
        echo "Invalid input: '$input' is not a valid age."
        echo
        continue
    fi

    # --------------------------------------------------------
    # Reject ages above 100.
    #   -gt  -> greater than
    # Message is printed without any "try again" wording.
    # --------------------------------------------------------
    if [ "$input" -gt 100 ]; then
        echo "Above 100 is not allowed to Cast Vote."
        echo
        continue
    fi

    # --------------------------------------------------------
    # All checks passed -> save the value and leave the loop.
    # --------------------------------------------------------
    age="$input"
    break
done

# ------------------------------------------------------------
# Voting check
#   -ge  -> greater than or equal to
# ------------------------------------------------------------
if [ "$age" -ge 18 ]; then
    echo "You can vote"
else
    echo "You cannot vote"
fi
