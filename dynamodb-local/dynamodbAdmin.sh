#! /bin/bash
if [ ! -z "$DYNAMODB_ADMIN_ENABLED" ]
then
  echo "Starting DynamoDB Admin"
  dynamodb-admin
else
  echo "DynamoDB Admin disabled. Not starting DynamoDB Admin"
fi