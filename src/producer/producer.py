import random
import time
import json
import os
from datetime import datetime, timezone
from kafka import KafkaProducer
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def generate_random_event():
    """Generate event matching the required format"""
    event_types = ["user_signup", "click", "view", "purchase"]
    event = {
        "event_type": random.choice(event_types),
        "user_id": random.randint(1, 10000),  # Wider range
        "timestamp": datetime.now(timezone.utc).isoformat().replace('+00:00', 'Z')
    }
    return event  # Return dict, not JSON string


def create_kafka_producer():
    """Create Kafka producer with proper configuration"""
    kafka_broker = os.getenv('KAFKA_BROKER', 'kafka-service:9092')

    return KafkaProducer(
        bootstrap_servers=[kafka_broker],
        value_serializer=lambda v: json.dumps(v).encode('utf-8'),
        retries=5,
        acks='all',
        batch_size=16384,
        linger_ms=10
    )


def main():
    logger.info("Starting Kafka Event Producer")

    producer = create_kafka_producer()
    topic = os.getenv('KAFKA_TOPIC', 'events')

    event_count = 0

    try:
        while True:
            event = generate_random_event()
            try:
                future = producer.send(topic, value=event)
                event_count += 1
                if event_count % 10 == 0:  # Log every 10 events to avoid spam
                    logger.info(f"Sent {event_count} events. Last event: {event}")
                else:
                    logger.debug(f"Sent event: {event}")

            except Exception as e:
                logger.error(f"Failed to send event: {e}")
            time.sleep(1)

    except KeyboardInterrupt:
        logger.info("Shutting down producer...")
    finally:
        producer.flush()
        producer.close()
        logger.info(f"Producer shut down. Total events sent: {event_count}")


if __name__ == '__main__':
    main()