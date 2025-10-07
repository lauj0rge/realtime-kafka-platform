import os
import json
import time
import schedule
from datetime import datetime, timezone
from kafka import KafkaConsumer
import psycopg2
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def create_kafka_consumer():
    """Create Kafka consumer for batch processing"""
    kafka_broker = os.getenv('KAFKA_BROKER', 'kafka-service:9092')
    topic = os.getenv('KAFKA_TOPIC', 'domain-events')
    group_id = os.getenv('KAFKA_GROUP_ID', 'batch-consumer-group')

    return KafkaConsumer(
        topic,
        bootstrap_servers=[kafka_broker],
        auto_offset_reset='earliest',
        enable_auto_commit=True,
        group_id=group_id,
        value_deserializer=lambda m: json.loads(m.decode('utf-8')),
        consumer_timeout_ms=5000  # Timeout after 5 seconds of no messages
    )


def create_db_connection():
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


def process_batch():
    """Process a batch of events every 5 minutes"""
    logger.info("Starting batch processing...")

    consumer = create_kafka_consumer()
    db_conn = create_db_connection()

    processed_count = 0
    batch_start = datetime.now(timezone.utc)

    try:
        # Poll for messages with timeout
        batch_messages = consumer.poll(timeout_ms=10000)  # 10 second poll

        for topic_partition, messages in batch_messages.items():
            for message in messages:
                event = message.value

                # Validate event structure
                if not all(k in event for k in ['event_type', 'user_id', 'timestamp']):
                    logger.warning(f"Invalid event structure: {event}")
                    continue

                # Convert timestamp and get consumption timestamp
                event_timestamp = event['timestamp']
                consumed_at_ts = int(datetime.now(timezone.utc).timestamp())

                # Insert into batch_events table
                try:
                    with db_conn.cursor() as cursor:
                        cursor.execute("""
                            INSERT INTO events_batch 
                            (event_type, user_id, timestamp, consumed_at_ts)
                            VALUES (%s, %s, %s, %s)
                        """, (
                            event['event_type'],
                            event['user_id'],
                            event_timestamp,
                            consumed_at_ts
                        ))
                    processed_count += 1
                    logger.debug(f"Processed batch event: user_id={event['user_id']}, type={event['event_type']}")

                except Exception as e:
                    logger.error(f"Error inserting event {event}: {e}")
                    db_conn.rollback()

        # Commit the offsets after processing batch
        consumer.commit()
        db_conn.commit()

        batch_duration = (datetime.now(timezone.utc) - batch_start).total_seconds()
        logger.info(f"Batch processing completed: {processed_count} events processed in {batch_duration:.2f} seconds")

    except Exception as e:
        logger.error(f"Batch processing error: {e}")
        db_conn.rollback()
    finally:
        consumer.close()
        db_conn.close()


def main():
    logger.info("Starting Batch Kafka Consumer (runs every 5 minutes)")

    schedule.every(5).minutes.do(process_batch)
    process_batch()

    # Keep the script running and execute scheduled jobs
    try:
        while True:
            schedule.run_pending()
            time.sleep(1)
    except KeyboardInterrupt:
        logger.info("Shutting down batch consumer...")


if __name__ == '__main__':
    main()