#!/bin/bash

# Start the server in the background
./server /tmp/socket &
SERVER_PID=$!

# Give the server a moment to start up
sleep 1

# Run the client command
./client /tmp/socket VERSION

# another delay
sleep 1

# Run again
./client /tmp/socket TEST

# Wait for the server to finish
wait $SERVER_PID
