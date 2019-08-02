#!/usr/bin/env bash
set -e


#############################
# Default Values

# node
: "${PRESTO_NODE_ENVIRONMENT:=docker}"
: "${PRESTO_NODE_ID:=$(uuidgen)}"

# config
: "${PRESTO_CONF_COORDINATOR:=true}"
: "${PRESTO_CONF_INCLUDE_COORDINATOR:=true}"
: "${PRESTO_CONF_HTTP_PORT:=8080}"
: "${PRESTO_CONF_DISCOVERY_SERVER_ENABLED:=true}"
: "${PRESTO_CONF_DISCOVERY_URI:=http://localhost:8080}"
: "${PRESTO_CONF_QUERY_MAX_MEMORY:=5GB}"
: "${PRESTO_CONF_QUERY_MAX_MEMORY_PER_NODE:=1GB}"
: "${PRESTO_CONF_QUERY_MAX_TOTAL_MEMORY_PER_NODE:=2GB}"


# catalogs
# jmx
: "${PRESTO_CATALOG_JMX:=true}"
: "${PRESTO_CATALOG_JMX_NAME:=jmx}"

# hive
: "${PRESTO_CATALOG_HIVE:=false}"
: "${PRESTO_CATALOG_HIVE_NAME:=hive}"
: "${PRESTO_CATALOG_HIVE_METASTORE_URI:=file}"
: "${PRESTO_CATALOG_HIVE_RECURSIVE_DIRECTORIES:=true}"
: "${PRESTO_CATALOG_HIVE_ALLOW_DROP_TABLE:=true}"
: "${PRESTO_CATALOG_HIVE_USE_S3:=false}"
: "${PRESTO_CATALOG_HIVE_S3_AWS_ACCESS_KEY:=}"
: "${PRESTO_CATALOG_HIVE_S3_AWS_SECRET_KEY:=}"
: "${PRESTO_CATALOG_HIVE_S3_ENDPOINT:=}"
: "${PRESTO_CATALOG_HIVE_S3_USE_INSTANCE_CREDENTIALS:=false}"
: "${PRESTO_CATALOG_HIVE_S3_SELECT_PUSHDOWN_ENABLED:=true}"


#############################
# node.properties

echo "node.environment=${PRESTO_NODE_ENVIRONMENT}" >> /etc/presto/node.properties
echo "node.id=${PRESTO_NODE_ID}" >> /etc/presto/node.properties
echo "catalog.config-dir=/etc/presto/catalog" >> /etc/presto/node.properties
echo "plugin.dir=/usr/lib/presto/lib/plugin" >> /etc/presto/node.properties


#############################
# config.properties

echo "coordinator=${PRESTO_CONF_COORDINATOR}" >> /etc/presto/config.properties
echo "node-scheduler.include-coordinator=${PRESTO_CONF_INCLUDE_COORDINATOR}" >> /etc/presto/config.properties
echo "http-server.http.port=${PRESTO_CONF_HTTP_PORT}" >> /etc/presto/config.properties
echo "discovery-server.enabled=${PRESTO_CONF_DISCOVERY_SERVER_ENABLED}" >> /etc/presto/config.properties
echo "discovery.uri=${PRESTO_CONF_DISCOVERY_URI}" >> /etc/presto/config.properties
echo "query.max-memory=${PRESTO_CONF_QUERY_MAX_MEMORY}" >> /etc/presto/config.properties
echo "query.max-memory-per-node=${PRESTO_CONF_QUERY_MAX_MEMORY_PER_NODE}" >> /etc/presto/config.properties
echo "query.max-total-memory-per-node=${PRESTO_CONF_QUERY_MAX_TOTAL_MEMORY_PER_NODE}" >> /etc/presto/config.properties


#############################
# catalogs

# jmx
if $PRESTO_CATALOG_JMX; then
    echo "connector.name=jmx" >> "/etc/presto/catalog/${PRESTO_CATALOG_JMX_NAME}.properties"
fi

# hive
if $PRESTO_CATALOG_HIVE; then
    echo "connector.name=hive-hadoop2" >> "/etc/presto/catalog/${PRESTO_CATALOG_HIVE_NAME}.properties"
    echo "hive.recursive-directories=${PRESTO_CATALOG_HIVE_RECURSIVE_DIRECTORIES}" >> "/etc/presto/catalog/${PRESTO_CATALOG_HIVE_NAME}.properties"
    echo "hive.allow-drop-table=${PRESTO_CATALOG_HIVE_ALLOW_DROP_TABLE}" >> "/etc/presto/catalog/${PRESTO_CATALOG_HIVE_NAME}.properties"

    # use a real metastore, or a file-based metastore
    if [ $PRESTO_CATALOG_HIVE_METASTORE_URI == "file" ]; then
        echo "hive.metastore=file" >> "/etc/presto/catalog/${PRESTO_CATALOG_HIVE_NAME}.properties"
        echo "hive.metastore.catalog.dir=file:///tmp/hive_catalog" >> "/etc/presto/catalog/${PRESTO_CATALOG_HIVE_NAME}.properties"
        echo "hive.metastore.user=presto" >> "/etc/presto/catalog/${PRESTO_CATALOG_HIVE_NAME}.properties"
    else
        echo "hive.metastore.uri=${PRESTO_CATALOG_HIVE_METASTORE_URI}" >> "/etc/presto/catalog/${PRESTO_CATALOG_HIVE_NAME}.properties"
    fi

    # s3 on hive    
    if $PRESTO_CATALOG_HIVE_USE_S3; then
        echo "hive.s3.aws-access-key=${PRESTO_CATALOG_HIVE_S3_AWS_ACCESS_KEY}" >> "/etc/presto/catalog/${PRESTO_CATALOG_HIVE_NAME}.properties"
        echo "hive.s3.aws-secret-key=${PRESTO_CATALOG_HIVE_S3_AWS_SECRET_KEY}" >> "/etc/presto/catalog/${PRESTO_CATALOG_HIVE_NAME}.properties"
        echo "hive.s3.endpoint=${PRESTO_CATALOG_HIVE_S3_ENDPOINT}" >> "/etc/presto/catalog/${PRESTO_CATALOG_HIVE_NAME}.properties"
        echo "hive.s3.use-instance-credentials=${PRESTO_CATALOG_HIVE_S3_USE_INSTANCE_CREDENTIALS}" >> "/etc/presto/catalog/${PRESTO_CATALOG_HIVE_NAME}.properties"
        echo "hive.s3select-pushdown.enabled=${PRESTO_CATALOG_HIVE_S3_SELECT_PUSHDOWN_ENABLED}" >> "/etc/presto/catalog/${PRESTO_CATALOG_HIVE_NAME}.properties"
    fi
fi


#############################
# execute

echo "Executing: $@"
exec "$@"