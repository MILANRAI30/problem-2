#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
PROCESS_THRESHOLD=200

# Log file
LOG_FILE="/var/log/system_health.log"

# Function to check CPU usage
check_cpu() {
  CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
  if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "ALERT: High CPU usage detected: $CPU_USAGE%" >> $LOG_FILE
  fi
}

# Function to check memory usage
check_memory() {
  MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
  if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
    echo "ALERT: High memory usage detected: $MEMORY_USAGE%" >> $LOG_FILE
  fi
}

# Function to check disk space usage
check_disk() {
  DISK_USAGE=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
  if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "ALERT: High disk usage detected: $DISK_USAGE%" >> $LOG_FILE
  fi
}

# Function to check number of running processes
check_processes() {
  PROCESS_COUNT=$(ps aux | wc -l)
  if [ "$PROCESS_COUNT" -gt "$PROCESS_THRESHOLD" ]; then
    echo "ALERT: High number of processes detected: $PROCESS_COUNT" >> $LOG_FILE
  fi
}

# Run checks
check_cpu
check_memory
check_disk
check_processes

# Save the script to a file : system_health.sh.
# Make the script executable :  chmod +x system_health.sh
# Run the script manually or set up a cron job to run it periodically
