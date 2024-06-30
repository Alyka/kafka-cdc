# Architecture

1. Debezium CDC: Debezium captures changes from the transactional PostgreSQL database and sends them to Kafka topics.
2. Kafka Topics: Changes are written to Kafka topics.
3. Kafka Consumers: Consumers read messages from Kafka topics.
4. Data Enrichment Service:
    - Queries PostgreSQL read replicas for related data.
    - Combines the change event data with related data from the read replicas.
    - Transforms the data into the target format for MongoDB.
5. MongoDB: The enriched data is written to MongoDB.
