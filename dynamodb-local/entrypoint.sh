#! /bin/bash

# https://docs.docker.com/config/containers/multi-service_container/
 
# turn on bash's job control
set -m
set -e
  
# Start the primary dynamoDB process in the background
./dynamodb.sh &
  
# Try to start dynamodb-admin
./dynamodbAdmin.sh &
  
# Try to create tables in DynamoDB
./createTables.sh 
  
# now we bring the primary process back into the foreground
# and leave it there
fg %1