#!/bin/bash

# Path to the web server log file
LOG_FILE="/path/to/your/access.log"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found: $LOG_FILE"
    exit 1
fi

# Output file for the summary report
REPORT_FILE="log_summary_report.txt"

# Clear the previous report if it exists
> "$REPORT_FILE"

# Count the number of 404 errors
echo "Number of 404 errors:" >> "$REPORT_FILE"
grep ' 404 ' "$LOG_FILE" | wc -l >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Most requested pages
echo "Most requested pages:" >> "$REPORT_FILE"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10 >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# IP addresses with the most requests
echo "IP addresses with the most requests:" >> "$REPORT_FILE"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10 >> "$REPORT_FILE"

# Notify user of completion
echo "Log analysis complete. Report saved to $REPORT_FILE."

# Save the script content into a file : analyze_logs.sh.
# Make the script executable by running : ./analyze_logs.sh
