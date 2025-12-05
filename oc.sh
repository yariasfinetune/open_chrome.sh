#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

environment=$1

if [ -z "$environment" ]; then
  echo "Usage: $0 <uat|testing|prod>"
  exit 1
fi

if [ "$environment" != "uat" ] && [ "$environment" != "testing" ] && [ "$environment" != "prod" ]; then
  echo "Environment must be either 'uat' or 'testing' or 'prod'"
  exit 1
fi

# Start the proxy in the background and store its PID
echo "Starting proxy..."
./start_proxy.sh &
PROXY_PID=$!

# Wait a moment to ensure proxy is up
sleep 3

# Check if proxy is actually running
if ! kill -0 $PROXY_PID 2>/dev/null; then
    echo "Error: Proxy failed to start"
    exit 1
fi

# Check if proxy is listening on port 8080
if ! nc -z 127.0.0.1 8080 2>/dev/null; then
    echo "Error: Proxy is not listening on port 8080"
    kill $PROXY_PID 2>/dev/null
    exit 1
fi

echo "Proxy is running successfully on port 8080"

# Open Chrome using proxy in new profile directory for cleanliness
echo "Opening Chrome with proxy..."
./open_chrome.sh "$environment"

# After Chrome is closed (open_chrome.sh ends), stop the proxy
echo "Stopping proxy..."
kill $PROXY_PID 2>/dev/null

