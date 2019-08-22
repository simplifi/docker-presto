# docker-presto

This repository contains **Dockerfile** of [Presto](https://prestosql.io/).

## Installation

Pull the image from the Docker repository.
```
docker pull simplifi/docker-presto:latest
```

## Build
```
docker build --rm -t simplifi/docker-presto:latest .
```

## Usage

### To start a single node Presto cluster
```
docker run -p 8080:8080 simplifi/docker-presto:latest
```


## Configuration

Configuration is handled by setting the environment variables outlined below.


### node.properties

| Property         | Environment Variable    | Default Value                 | Description                                            |
| -----------------| ----------------------- | ----------------------------- | ------------------------------------------------------ |
| node.environment | PRESTO_NODE_ENVIRONMENT | docker                        | The name of the environment.                           |
| node.id          | PRESTO_NODE_ID          | (uuid generated by `uuidgen`) | The unique identifier for this installation of Presto. |


### config.properties

| Property                           | Environment Variable                        | Default Value         | Description                                                                                                       |
| ---------------------------------- | ------------------------------------------- | --------------------- | ----------------------------------------------------------------------------------------------------------------- |
| coordinator                        | PRESTO_CONF_COORDINATOR                     | true                  | Allow this Presto instance to function as a coordinator (accept queries from clients and manage query execution). |
| node-scheduler.include-coordinator | PRESTO_CONF_INCLUDE_COORDINATOR             | true                  | Allow scheduling work on the coordinator.                                                                         |
| http-server.http.port              | PRESTO_CONF_HTTP_PORT                       | 8080                  | Specifies the port for the HTTP server. Presto uses HTTP for all communication, internal and external.            |
| discovery-server.enabled           | PRESTO_CONF_DISCOVERY_SERVER_ENABLED        | true                  | Run an embedded version of the Discovery service.                                                                 |
| discovery.uri                      | PRESTO_CONF_DISCOVERY_URI                   | http://localhost:8080 | The URI to the Discovery server.                                                                                  |
| query.max-memory                   | PRESTO_CONF_QUERY_MAX_MEMORY                | 5GB                   | The maximum amount of distributed memory that a query may use.                                                    |
| query.max-memory-per-node          | PRESTO_CONF_QUERY_MAX_MEMORY_PER_NODE       | 1GB                   | The maximum amount of user memory that a query may use on any one machine.                                        |
| query.max-total-memory-per-node    | PRESTO_CONF_QUERY_MAX_TOTAL_MEMORY_PER_NODE | 2GB                   | The maximum amount of user and system memory that a query may use on any one machine.                             |


### Catalogs

#### JMX

| Property | Environment Variable     | Default Value | Description                          |
| -------- | ------------------------ | ------------- | ------------------------------------ |
| N/A      | PRESTO_CATALOG_JMX       | true          | Should this catalog be enabled?      |
| N/A      | PRESTO_CATALOG_JMX_NAME  | jmx           | Name to use for the catalog          |


#### Hive

| Property                         | Environment Variable                            | Default Value         | Description                                                                                                                                |
| -------------------------------- | ----------------------------------------------- | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| N/A                              | PRESTO_CATALOG_HIVE                             | false                 | Should this catalog be enabled?                                                                                                            |
| N/A                              | PRESTO_CATALOG_HIVE_NAME                        | hive                  | Name to use for the catalog                                                                                                                |
| hive.recursive-directories       | PRESTO_CATALOG_HIVE_RECURSIVE_DIRECTORIES       | true                  | Enable reading data from subdirectories of table or partition locations.                                                                   |
| hive.allow-drop-table            | PRESTO_CATALOG_HIVE_ALLOW_DROP_TABLE            | true                  | Enable the ability to drop tables.                                                                                                         |
| hive.metastore.uri               | PRESTO_CATALOG_HIVE_METASTORE_URI               | file                  | The URI(s) of the Hive metastore to connect to using the Thrift protocol. If set to `file`, it will use a local file-based hive metastore. |
| N/A                              | PRESTO_CATALOG_HIVE_USE_S3                      | false                 | Should we configure hive to connect to s3?                                                                                                 |
| hive.s3.aws-access-key           | PRESTO_CATALOG_HIVE_S3_AWS_ACCESS_KEY           |                       | AWS access key to use.                                                                                                                     |
| hive.s3.aws-secret-key           | PRESTO_CATALOG_HIVE_S3_AWS_SECRET_KEY           |                       | AWS secret key to use.                                                                                                                     |
| hive.s3.endpoint                 | PRESTO_CATALOG_HIVE_S3_ENDPOINT                 |                       | The S3 storage endpoint server.                                                                                                            |
| hive.s3.use-instance-credentials | PRESTO_CATALOG_HIVE_S3_USE_INSTANCE_CREDENTIALS | false                 | Use the EC2 metadata service to retrieve API credentials (defaults to true). This works with IAM roles in EC2.                             |
| hive.s3select-pushdown.enabled   | PRESTO_CATALOG_HIVE_S3_SELECT_PUSHDOWN_ENABLED  | true                  | Enable query pushdown to AWS S3 Select service.                                                                                            |


Example:
```
docker run -e PRESTO_CATALOG_HIVE=true -it simplifi/docker-presto
```


## How to contribute

This project has some clear Contribution Guidelines and expectations that you can read here ([CONTRIBUTING](CONTRIBUTING.md)).

The contribution guidelines outline the process that you'll need to follow to get a patch merged.

