CREATE SOURCE CONNECTOR IF NOT EXISTS "mysql"  WITH (
    "connector.class"= 'io.debezium.connector.mysql.MySqlConnector',
    "tasks.max"= '1',

    "database.hostname"= 'mysql',
    "database.port"= '3306',
    "database.user"= 'root', --- permiso root?
    "database.password"= 'mypassword',
    --"database.sslmode"= 'SSL_MODE',
    
    --"database.server.id"= '1',
    --"database.server.name"= 'mysql_server',
    "database.include.list"= 'inventory',
    "table.include.list"= 'inventory.customers',
    -- "table.exclude.list'=''"
    "topic.prefix"= 'SENSORS_METADATA_',
    --"database.whitelist"= 'temp_db',
    --"table.whitelist"= 'sensors_table',

    "snapshot.mode"= 'initial',
    "snapshot.locking.mode": "none",
    "include.schema.changes": "false",
    
    --"key.converter": "io.confluent.connect.avro.AvroConverter",
    --"key.converter.basic.auth.credentials.source": "USER_INFO",
    --"key.converter.schema.registry.basic.auth.user.info": "SCHEMA_REGISTRY_USER:SCHEMA_REGISTRY_PASSWORD",
    --"key.converter.schema.registry.url": "https://APACHE_KAFKA_HOST:SCHEMA_REGISTRY_PORT",
    --"value.converter"= 'io.confluent.connect.avro.AvroConverter',
    --"value.converter"= 'io.confluent.connect.json.JsonConverter',
    "value.converter"='org.apache.kafka.connect.json.JsonConverter',
    "value.converter.schemas.enable"='false',
    --"value.converter.schemas.enable"='false',
    --"value.converter.basic.auth.credentials.source": "USER_INFO",
    --"value.converter.schema.registry.basic.auth.user.info": "SCHEMA_REGISTRY_USER:SCHEMA_REGISTRY_PASSWORD",
    --"value.converter.schema.registry.url": "https://APACHE_KAFKA_HOST:SCHEMA_REGISTRY_PORT",
    
    "schema.history.internal.kafka.topic"= 'schema-changes.inventory',
    "schema.history.internal.kafka.bootstrap.servers"= 'kafka:9092',
    "decimal.handling.mode"='double',
    
    "transform" ='unwrap',
    --"transforms.unwrap.type"= 'io.debezium.transforms.ExtractNewRecordState',
    "transforms.unwrap.drop.tombstones"='false',
    --"transforms.unwrap.delete.handling.mode"='rewrite'
    );

