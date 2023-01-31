resource "confluent_connector" "mongodb_sink_customer" {
    environment {
        id = confluent_environment.env.id 
    }
    kafka_cluster {
        id = confluent_kafka_cluster.basic.id
    }
    status = "RUNNING"
    config_sensitive = {
        "connection.password" : "Demo2023"
        "connection.user": "mongouser"
        "connection.host": "cluster0.m3edxzh.mongodb.net"
    }
    config_nonsensitive = {
        "connector.class" : "MongoDbAtlasSink"
        "collection" : "orders"
        "topics": "postgres.products.orders"
        "database": "cluster0"
        "name": "MongoDB_sink"
        "output.data.format": "JSON"
        "input.data.format": "JSON_SR"
        "tasks.max": "1"
        "kafka.auth.mode": "SERVICE_ACCOUNT"
        "kafka.service.account.id" = "${confluent_service_account.connectors.id}"
    }
    depends_on = [
        confluent_kafka_acl.connectors_source_acl_create_topic,
        confluent_kafka_acl.connectors_source_acl_write,
        confluent_api_key.connector_keys,
        aws_instance.postgres_customers,
        aws_eip.postgres_customers_eip
    ]
}
