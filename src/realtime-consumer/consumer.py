import os
import json
import time
from datetime import datetime, timezone
from kafka import KafkaConsumer
import psycopg2
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def create_kafka_consumer():
    """Create Kafka consumer for real-time processing"""
    kafka_broker = os.getenv('KAFKA_BROKER', 'kafka-service:9092')
    topic = os.getenv('KAFKA_TOPIC', 'domain-events')
    group_id = os.getenv('KAFKA_GROUP_ID', 'realtime-consumer-group')

    return KafkaConsumer(
        topic,
        bootstrap_servers=[kafka_broker],
        auto_offset_reset='earliest',
        enable_auto_commit=True,
        group_id=group_id,
        value_deserializer=lambda m: json.loads(m.decode('utf-8'))
    )


def create_db_connection():
    """Create PostgreSQL connection"""
    db_host = os.getenv('DB_HOST', 'postgresql-dev')
    db_port = os.getenv('DB_PORT', '5432')
    db_name = os.getenv('DB_NAME', 'postgres')
    db_user = os.getenv('DB_USER', 'postgres')
    db_password = os.getenv('DB_PASSWORD', 'password')

    return psycopg2.connect(
        host=db_host,
        port=db_port,
        dbname=db_name,
        user=db_user,
        password=db_password
    )


def process_event(event, db_conn):
    """Process a single event and store in PostgreSQL"""
    try:
        if not all(k in event for k in ['event_type', 'user_id', 'timestamp']):
            logger.warning(f"Invalid event structure: {event}")
            return

        event_timestamp = event['timestamp']
        consumed_at_ts = int(datetime.now(timezone.utc).timestamp())
        with db_conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO events_realtime 
                (event_type, user_id, timestamp, consumed_at_ts)
                VALUES (%s, %s, %s, %s)
            """, (
                event['event_type'],
                event['user_id'],
                event_timestamp,
                consumed_at_ts
            ))
            db_conn.commit()

        logger.info(f"Processed event: user_id={event['user_id']}, type={event['event_type']}")

    except Exception as e:
        logger.error(f"Error processing event {event}: {e}")
        db_conn.rollback()


def main():
    logger.info("Starting Real-time Kafka Consumer")
    consumer = create_kafka_consumer()
    db_conn = create_db_connection()

    try:
        with db_conn.cursor() as cursor:
            cursor.execute("SELECT 1")
        logger.info("Database connection successful")
    except Exception as e:
        logger.error(f"Database connection failed: {e}")
        return

    processed_count = 0

    try:
        for message in consumer:
            event = message.value
            logger.debug(f"Received event: {event}")

            process_event(event, db_conn)
            processed_count += 1

            if processed_count % 10 == 0:
                logger.info(f"Processed {processed_count} events total")

    except KeyboardInterrupt:
        logger.info("Shutting down real-time consumer...")
    except Exception as e:
        logger.error(f"Consumer error: {e}")
    finally:
        consumer.close()
        db_conn.close()
        logger.info(f"Real-time consumer shut down. Total events processed: {processed_count}")


if __name__ == '__main__':
    main()