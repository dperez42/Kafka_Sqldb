/*
CREATE SOURCES
*/


/*
CREATE STREAMS AN D TOPICS
*/
SET 'commit.interval.ms'='2000';
SET 'cache.max.bytes.buffering'='10000000';
SET 'auto.offset.reset' = 'earliest';

CREATE STREAM IF NOT EXISTS STREAM_T1 (id VARCHAR, name VARCHAR) WITH (KAFKA_TOPIC='T1', PARTITIONS=1, REPLICAS=1,VALUE_FORMAT='AVRO');
ASSERT TOPIC T1  TIMEOUT 30 SECONDS;
CREATE STREAM IF NOT EXISTS  STREAM_T2 (id VARCHAR, value INT) WITH (KAFKA_TOPIC='T2', PARTITIONS=1, REPLICAS=1, VALUE_FORMAT='AVRO');
ASSERT TOPIC T2  TIMEOUT 30 SECONDS;

CREATE STREAM IF NOT EXISTS STREAM_T1_T2 WITH (KAFKA_TOPIC='T1_T2', PARTITIONS=1, REPLICAS=1, VALUE_FORMAT='AVRO') 
AS SELECT 
    T1.id,
    T2.id as id,
    T1.name as name,
    T2.value as value
    FROM STREAM_T2 T2
    INNER JOIN  STREAM_T1 T1 WITHIN 3 DAYS
    ON T2.id = T1.id;
ASSERT TOPIC T1_T2  TIMEOUT 30 SECONDS;

/*
Creat SINK CONNECTOR
*/

CREATE SINK CONNECTOR IF NOT EXISTS "mysql-insert-sink"  WITH (
    "task.max"='1',
    "connection.url"= 'jdbc:mysql://mysql:3306/temp_db',
    "connection.user"= 'myuser',
    "connection.password"= 'mypassword',
    "topics"= 'T1_T2',
    "connector.class"= 'io.confluent.connect.jdbc.JdbcSinkConnector',
    "key.converter"='org.apache.kafka.connect.storage.StringConverter',
    "value.converter"='io.confluent.connect.avro.AvroConverter',
    "value.converter.schema.registry.url"='http://schema-registry:8081',
    "table.name.format"= 'kafka_${topic}',
    "auto.create"= 'true',
    "auto.evolve"= 'true',
    "insert.mode"= 'insert',
    -- Añade o quita columnas 
    "transforms"= 'dropSome,addSome',
    "transforms.dropSome.type"='org.apache.kafka.connect.transforms.ReplaceField$Value',
    --"transforms.dropSome.blacklist"= 'COL2',
    "transforms.addSome.type"='org.apache.kafka.connect.transforms.InsertField$Value',
    "transforms.addSome.partition.field"= '_partition',
    "transforms.addSome.timestamp.field"= '_record_TS_UTC'
);