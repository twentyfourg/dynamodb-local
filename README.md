[![DynamoDB Local](https://flat.badgen.net/github/release/twentyfourg/dynamodb-local/stable)](https://github.com/twentyfourg/dynamodb-local) [![DynamoDB Local](https://flat.badgen.net/github/stars/twentyfourg/dynamodb-local)](https://github.com/twentyfourg/dynamodb-local/stargazers) [![Docker Pulls](https://flat.badgen.net/docker/pulls/twentyfourg/dynamodb-local)](https://hub.docker.com/r/twentyfourg/dynamodb-local)

# DynamoDB Local

Run DynamoDB locally inside a Docker container.

The container comes shipped with [DynamoDB-local](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.UsageNotes.html) and [DynamoDB Admin](https://www.npmjs.com/package/dynamodb-admin) for easy GUI access. You can also set default table(s) to be created on start up.

## Usage

```bash
docker run -d -p 8000:8000 -p 8001:8001 twentyfourg/dynamodb-local
```

## Configuration

You can enable/disable features or change configuration by using environment variables.

| Environment Variable         | Description                                                                                             | Default              |
| ---------------------------- | ------------------------------------------------------------------------------------------------------- | -------------------- |
| `DYNAMODB_ADMIN_ENABLED`     | Enable or disable DynamoDB Admin                                                                        | `true`               |
| `DYNAMODB_CREATE_TABLES`     | Whether to create default DynamoDB tables                                                               | `true`               |
| `DYNAMODB_TABLE_SCHEMA_PATH` | Where the DynamoDB table schema JSON is stored. Only does something if `DYNAMODB_CREATE_TABLES` is set. | `./tableSchema.json` |

## Default Tables

Default tables are created using a [JSON schema](). You can define custom tables to create by mounting a schema file into the container and altering the `DYNAMODB_TABLE_SCHEMA_PATH` environment variable.

The schema file must be a JSON array so even if you have one table, enclose your table in `[]`.

One Table

```json
[
  {
    "TableName": "cache",
    "KeySchema": [{ "AttributeName": "key", "KeyType": "HASH" }],
    "AttributeDefinitions": [{ "AttributeName": "key", "AttributeType": "S" }],
    "BillingMode": "PAY_PER_REQUEST"
  }
]
```

Multiple Tables

```json
[
  {
    "TableName": "cache",
    "KeySchema": [{ "AttributeName": "key", "KeyType": "HASH" }],
    "AttributeDefinitions": [{ "AttributeName": "key", "AttributeType": "S" }],
    "BillingMode": "PAY_PER_REQUEST"
  },
  {
    "TableName": "rate-limit",
    "KeySchema": [{ "AttributeName": "key", "KeyType": "HASH" }],
    "AttributeDefinitions": [{ "AttributeName": "key", "AttributeType": "S" }],
    "BillingMode": "PAY_PER_REQUEST"
  }
]
```
