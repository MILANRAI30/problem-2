#!/bin/bash

# Function to check application status
check_application_status() {
    local url=$1

    # Send a request to the application and get the HTTP status code
    local status_code=$(curl -o /dev/null -s -w "%{http_code}" "$url")

    if [ "$status_code" -eq 200 ]; then
        echo "up"
    else
        echo "down (status code: $status_code)"
    fi
}

# Example usage
if [ $# -eq 0 ]; then
    echo "Usage: $0 <url>"
    exit 1
fi

url=$1
check_application_status "$url"

# Save the script to a file : check_status.sh.
# Make the script executable: chmod +x check_status.sh
# Run the script with the URL of your application: ./check_status.sh http://your-application-url.com


