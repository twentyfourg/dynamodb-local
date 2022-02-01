#! /bin/bash

if [ ! -z "$DYNAMODB_CREATE_TABLES" ]
then 
  echo "Creating DynamoDB tables."
  if [ -z "$DYNAMODB_TABLE_SCHEMA_PATH" ]
  then
    echo "DYNAMODB_TABLE_SCHEMA_PATH environment variable is empty. Defaulting to ./tableSchema.json."
    export DYNAMODB_TABLE_SCHEMA_PATH="./tableSchema.json"
  fi

  jq -c '.[]' $DYNAMODB_TABLE_SCHEMA_PATH | while read i; do
    TABLE_NAME=$(echo "$i" | jq '.TableName')
    echo "Attempting to create table $TABLE_NAME"
    aws dynamodb create-table --cli-input-json $i --endpoint-url http://localhost:8000 --region us-east-1 1> /dev/null
  done
else
  echo "Not creating DynamoDB tables."
fi