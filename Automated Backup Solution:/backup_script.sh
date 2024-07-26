#!/bin/bash

# Configuration
LOCAL_DIR="/path/to/local/directory"
BACKUP_TYPE="s3"  # Choose "remote" or "s3"
REMOTE_SERVER="user@remote_server:/path/to/remote/directory"
S3_BUCKET="your_bucket_name"
S3_DIRECTORY="your_s3_directory"
LOG_FILE="backup_report.log"

# AWS Credentials (Make sure to set up your AWS CLI or export AWS credentials)
AWS_PROFILE="your_aws_profile"  # or leave empty if using default profile

# Function to log messages
log_message() {
    local message=$1
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" | tee -a $LOG_FILE
}

# Backup to Remote Server
backup_remote() {
    log_message "Starting backup to remote server..."
    rsync -avz --delete "$LOCAL_DIR" "$REMOTE_SERVER"
    if [ $? -eq 0 ]; then
        log_message "Backup to remote server completed successfully."
    else
        log_message "Backup to remote server failed."
    fi
}

# Backup to AWS S3
backup_s3() {
    log_message "Starting backup to AWS S3..."
    # Sync local directory to S3 bucket
    aws s3 sync "$LOCAL_DIR" "s3://$S3_BUCKET/$S3_DIRECTORY" --profile $AWS_PROFILE
    if [ $? -eq 0 ]; then
        log_message "Backup to S3 completed successfully."
    else
        log_message "Backup to S3 failed."
    fi
}

# Main script logic
case "$BACKUP_TYPE" in
    "remote")
        backup_remote
        ;;
    "s3")
        backup_s3
        ;;
    *)
        log_message "Invalid BACKUP_TYPE. Use 'remote' or 's3'."
        exit 1
        ;;
esac

# Save the script to a file : backup_script.sh.
# Make the script executable : chmod +x backup_script.sh
# Run the script: ./backup_script.sh
