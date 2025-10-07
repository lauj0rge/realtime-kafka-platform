# Data Platform End-to-End Test Results
**Test Date:** Tue Oct  7 11:20:52 CEST 2025
**Environment:** dev
**PostgreSQL Password:** ********
**Timestamp:** 2025-10-07-11.20.52

## 🧪 Test Summary

| Component | Status | Details |
|-----------|--------|---------|
### 2.5.1 Check Prometheus Service
```bash
# Command: kubectl get svc -n monitoring-dev | grep prometheus
prometheus-dev-alertmanager               ClusterIP   10.107.10.1      <none>        9093/TCP   11h
prometheus-dev-alertmanager-headless      ClusterIP   None             <none>        9093/TCP   11h
prometheus-dev-kube-state-metrics         ClusterIP   10.99.107.178    <none>        8080/TCP   11h
prometheus-dev-prometheus-node-exporter   ClusterIP   10.104.161.247   <none>        9100/TCP   11h
prometheus-dev-prometheus-pushgateway     ClusterIP   10.102.140.109   <none>        9091/TCP   11h
prometheus-dev-server                     ClusterIP   10.105.115.196   <none>        80/TCP     11h
```

## 1. Cluster Status

### 1.1 All Namespaces
```bash
# Command: kubectl get namespaces
NAME                STATUS   AGE
data-platform-dev   Active   3h1m
default             Active   12h
kafka-dev           Active   10h
kube-node-lease     Active   12h
kube-public         Active   12h
kube-system         Active   12h
monitoring-dev      Active   11h
postgresql-dev      Active   11h
```

### 1.2 Data Platform Pods
```bash
# Command: kubectl get pods -n data-platform-dev -o wide
NAME                               READY   STATUS    RESTARTS   AGE    IP            NODE       NOMINATED NODE   READINESS GATES
batch-consumer-75694c5664-jsw8r    1/1     Running   0          125m   10.244.0.72   minikube   <none>           <none>
event-producer-554cfb88f8-xjjhv    1/1     Running   0          125m   10.244.0.71   minikube   <none>           <none>
stream-consumer-56ddcd7f49-54zrx   1/1     Running   0          125m   10.244.0.73   minikube   <none>           <none>
```

### 1.3 Kafka Pods
```bash
# Command: kubectl get pods -n kafka-dev -o wide
NAME                                                            READY   STATUS    RESTARTS        AGE     IP            NODE       NOMINATED NODE   READINESS GATES
kafka-dev-controller-0                                          2/2     Running   1 (3h15m ago)   6h58m   10.244.0.41   minikube   <none>           <none>
kafka-dev-controller-1                                          2/2     Running   1 (3h15m ago)   6h59m   10.244.0.40   minikube   <none>           <none>
kafka-dev-controller-2                                          2/2     Running   1 (3h15m ago)   7h1m    10.244.0.39   minikube   <none>           <none>
kafka-exporter-dev-prometheus-kafka-exporter-765c498c99-7rm9x   1/1     Running   4 (7h ago)      7h1m    10.244.0.38   minikube   <none>           <none>
```

### 1.4 PostgreSQL Pods
```bash
# Command: kubectl get pods -n postgresql-dev -o wide
NAME               READY   STATUS    RESTARTS        AGE   IP            NODE       NOMINATED NODE   READINESS GATES
postgresql-dev-0   1/1     Running   1 (3h15m ago)   11h   10.244.0.23   minikube   <none>           <none>
```

### 1.5 Monitoring Pods
```bash
# Command: kubectl get pods -n monitoring-dev -o wide
NAME                                                     READY   STATUS      RESTARTS        AGE   IP             NODE       NOMINATED NODE   READINESS GATES
prometheus-dev-alertmanager-0                            1/1     Running     1 (3h32m ago)   11h   10.244.0.20    minikube   <none>           <none>
prometheus-dev-kube-state-metrics-77744d6dff-nd28k       1/1     Running     2 (3h14m ago)   11h   10.244.0.21    minikube   <none>           <none>
prometheus-dev-prometheus-node-exporter-hm8q5            1/1     Running     1 (3h32m ago)   11h   192.168.49.2   minikube   <none>           <none>
prometheus-dev-prometheus-pushgateway-746f57fd75-5jmdr   1/1     Running     0               11h   10.244.0.22    minikube   <none>           <none>
prometheus-dev-server-c95bff4c7-pwskq                    2/2     Running     1 (3h15m ago)   11h   10.244.0.19    minikube   <none>           <none>
test-prom                                                0/1     Completed   0               16m   10.244.0.101   minikube   <none>           <none>
```

## 2. Application Logs

### 2.1 Producer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-dev deployment/event-producer --tail=10
INFO:__main__:Sent 7360 events. Last event: {'event_type': 'click', 'user_id': 2452, 'timestamp': '2025-10-07T09:19:19.954389Z'}
INFO:__main__:Sent 7370 events. Last event: {'event_type': 'view', 'user_id': 1529, 'timestamp': '2025-10-07T09:19:29.989122Z'}
INFO:__main__:Sent 7380 events. Last event: {'event_type': 'click', 'user_id': 7906, 'timestamp': '2025-10-07T09:19:40.021582Z'}
INFO:__main__:Sent 7390 events. Last event: {'event_type': 'user_signup', 'user_id': 8549, 'timestamp': '2025-10-07T09:19:50.052468Z'}
INFO:__main__:Sent 7400 events. Last event: {'event_type': 'user_signup', 'user_id': 4995, 'timestamp': '2025-10-07T09:20:00.093831Z'}
INFO:__main__:Sent 7410 events. Last event: {'event_type': 'purchase', 'user_id': 5023, 'timestamp': '2025-10-07T09:20:10.113276Z'}
INFO:__main__:Sent 7420 events. Last event: {'event_type': 'purchase', 'user_id': 5928, 'timestamp': '2025-10-07T09:20:20.151595Z'}
INFO:__main__:Sent 7430 events. Last event: {'event_type': 'click', 'user_id': 9829, 'timestamp': '2025-10-07T09:20:30.193483Z'}
INFO:__main__:Sent 7440 events. Last event: {'event_type': 'purchase', 'user_id': 6648, 'timestamp': '2025-10-07T09:20:40.259416Z'}
INFO:__main__:Sent 7450 events. Last event: {'event_type': 'click', 'user_id': 1556, 'timestamp': '2025-10-07T09:20:50.423159Z'}
```

### 2.2 Real-time Consumer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-dev deployment/stream-consumer --tail=10
2025-10-07 09:20:49,491 - INFO - Processed event: user_id=6879, type=click
2025-10-07 09:20:50,468 - INFO - Processed event: user_id=1556, type=click
2025-10-07 09:20:51,505 - INFO - Processed event: user_id=7505, type=click
2025-10-07 09:20:52,455 - INFO - Processed event: user_id=1822, type=view
2025-10-07 09:20:53,489 - INFO - Processed event: user_id=663, type=view
2025-10-07 09:20:54,599 - INFO - Processed event: user_id=2273, type=purchase
2025-10-07 09:20:55,490 - INFO - Processed event: user_id=1561, type=purchase
2025-10-07 09:20:55,491 - INFO - Processed 7460 events total
2025-10-07 09:20:56,502 - INFO - Processed event: user_id=8361, type=user_signup
2025-10-07 09:20:57,500 - INFO - Processed event: user_id=9046, type=click
```

### 2.3 Batch Consumer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-dev deployment/batch-consumer --tail=10
2025-10-07 09:17:28,574 - INFO - Updated partition assignment: [TopicPartition(topic='domain-events', partition=0)]
2025-10-07 09:17:28,574 - INFO - Setting newly assigned partitions {TopicPartition(topic='domain-events', partition=0)} for group batch-consumer-group
2025-10-07 09:17:28,718 - INFO - <BrokerConnection node_id=1 host=kafka-dev-controller-1.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connecting> [IPv4 ('10.244.0.40', 9092)]>: connecting to kafka-dev-controller-1.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 [('10.244.0.40', 9092) IPv4]
2025-10-07 09:17:28,720 - INFO - <BrokerConnection node_id=1 host=kafka-dev-controller-1.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connecting> [IPv4 ('10.244.0.40', 9092)]>: Connection complete.
2025-10-07 09:17:29,654 - INFO - Batch processing completed: 302 events processed in 4.34 seconds
2025-10-07 09:17:29,678 - INFO - Stopping heartbeat thread
2025-10-07 09:17:29,679 - INFO - Leaving consumer group (batch-consumer-group).
2025-10-07 09:17:29,725 - INFO - <BrokerConnection node_id=coordinator-2 host=kafka-dev-controller-2.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.39', 9092)]>: Closing connection. 
2025-10-07 09:17:29,726 - INFO - <BrokerConnection node_id=2 host=kafka-dev-controller-2.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.39', 9092)]>: Closing connection. 
2025-10-07 09:17:29,727 - INFO - <BrokerConnection node_id=1 host=kafka-dev-controller-1.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.40', 9092)]>: Closing connection. 
```

## 4. Database Verification

### 4.1 Table Row Counts
```bash
# Command: SELECT 'Real-time events count:', COUNT(*) FROM events_realtime; SELECT 'Batch events count:', COUNT(*) FROM events_batch;
        ?column?         | count 
-------------------------+-------
 Real-time events count: |  9326
(1 row)

      ?column?       | count 
---------------------+-------
 Batch events count: |  9099
(1 row)

```

### 4.2 Recent Events Sample
```bash
# Command: SELECT 'Latest 5 real-time events:', event_type, user_id, TO_CHAR(timestamp, 'YYYY-MM-DD HH24:MI:SS'), consumed_at_ts FROM events_realtime ORDER BY id DESC LIMIT 5; SELECT 'Latest 5 batch events:', event_type, user_id, TO_CHAR(timestamp, 'YYYY-MM-DD HH24:MI:SS'), consumed_at_ts FROM events_batch ORDER BY id DESC LIMIT 5;
          ?column?          | event_type  | user_id |       to_char       | consumed_at_ts 
----------------------------+-------------+---------+---------------------+----------------
 Latest 5 real-time events: | user_signup |    4793 | 2025-10-07 09:21:06 |     1759828866
 Latest 5 real-time events: | click       |    6949 | 2025-10-07 09:21:05 |     1759828865
 Latest 5 real-time events: | purchase    |    9370 | 2025-10-07 09:21:04 |     1759828864
 Latest 5 real-time events: | view        |    2716 | 2025-10-07 09:21:03 |     1759828863
 Latest 5 real-time events: | user_signup |    7733 | 2025-10-07 09:21:02 |     1759828862
(5 rows)

        ?column?        | event_type  | user_id |       to_char       | consumed_at_ts 
------------------------+-------------+---------+---------------------+----------------
 Latest 5 batch events: | click       |    8276 | 2025-10-07 09:17:28 |     1759828649
 Latest 5 batch events: | user_signup |    6944 | 2025-10-07 09:17:27 |     1759828649
 Latest 5 batch events: | click       |    1453 | 2025-10-07 09:17:26 |     1759828649
 Latest 5 batch events: | click       |    2938 | 2025-10-07 09:17:25 |     1759828649
 Latest 5 batch events: | purchase    |    9802 | 2025-10-07 09:17:24 |     1759828649
(5 rows)

```

### 4.3 Event Type Distribution
```bash
# Command: SELECT 'Real-time event types:', event_type, COUNT(*) FROM events_realtime GROUP BY event_type ORDER BY COUNT(*) DESC; SELECT 'Batch event types:', event_type, COUNT(*) FROM events_batch GROUP BY event_type ORDER BY COUNT(*) DESC;
        ?column?        | event_type  | count 
------------------------+-------------+-------
 Real-time event types: | user_signup |  2399
 Real-time event types: | purchase    |  2343
 Real-time event types: | view        |  2319
 Real-time event types: | click       |  2271
(4 rows)

      ?column?      | event_type  | count 
--------------------+-------------+-------
 Batch event types: | user_signup |  2339
 Batch event types: | purchase    |  2290
 Batch event types: | view        |  2258
 Batch event types: | click       |  2212
(4 rows)

```

## 5. Data Flow Verification

### 5.1 Events in Last 10 Minutes
```bash
# Command: SELECT 'Real-time events (last 10 min):', COUNT(*) FROM events_realtime WHERE consumed_at_ts > EXTRACT(EPOCH FROM NOW()) - 600; SELECT 'Batch events (last 10 min):', COUNT(*) FROM events_batch WHERE consumed_at_ts > EXTRACT(EPOCH FROM NOW()) - 600;
            ?column?             | count 
---------------------------------+-------
 Real-time events (last 10 min): |   594
(1 row)

          ?column?           | count 
-----------------------------+-------
 Batch events (last 10 min): |   605
(1 row)

```

## 6. Service Connectivity

### 6.1 Service Discovery
```bash
# Command: kubectl get svc -A | grep -E '(kafka|postgresql|prometheus)'
kafka-dev        kafka-dev                                      ClusterIP   10.98.155.181    <none>        9092/TCP                     10h
kafka-dev        kafka-dev-controller-headless                  ClusterIP   None             <none>        9094/TCP,9092/TCP,9093/TCP   10h
kafka-dev        kafka-dev-jmx-metrics                          ClusterIP   10.110.198.111   <none>        5556/TCP                     7h51m
kafka-dev        kafka-exporter-dev-prometheus-kafka-exporter   ClusterIP   10.109.183.80    <none>        9308/TCP                     7h1m
monitoring-dev   prometheus-dev-alertmanager                    ClusterIP   10.107.10.1      <none>        9093/TCP                     11h
monitoring-dev   prometheus-dev-alertmanager-headless           ClusterIP   None             <none>        9093/TCP                     11h
monitoring-dev   prometheus-dev-kube-state-metrics              ClusterIP   10.99.107.178    <none>        8080/TCP                     11h
monitoring-dev   prometheus-dev-prometheus-node-exporter        ClusterIP   10.104.161.247   <none>        9100/TCP                     11h
monitoring-dev   prometheus-dev-prometheus-pushgateway          ClusterIP   10.102.140.109   <none>        9091/TCP                     11h
monitoring-dev   prometheus-dev-server                          ClusterIP   10.105.115.196   <none>        80/TCP                       11h
postgresql-dev   postgresql-dev                                 ClusterIP   10.102.149.210   <none>        5432/TCP                     11h
postgresql-dev   postgresql-dev-hl                              ClusterIP   None             <none>        5432/TCP                     11h
```

## 📊 Test Summary

### Component Status

| Component | Test | Status |
|-----------|------|--------|
| Producer | Pod Running | ✅ PASS |
| Real-time Consumer | Pod Running | ✅ PASS |
| Batch Consumer | Pod Running | ✅ PASS |
| Real-time Table | Has Data (9338 rows) | ✅ PASS |
| Batch Table | Has Data (9099 rows) | ✅ PASS |
| Kafka | Producer Can Send | ✅ PASS |
| Prometheus | Running | ✅ PASS |
| Kafka Exporter | Running | ✅ PASS |

### 🎯 Test Conclusions

- Data pipeline is operational: Producer → Kafka → Consumers → PostgreSQL
- Real-time processing: Immediate event consumption
- Batch processing: Scheduled processing every 5 minutes
- Data persistence: Events stored in PostgreSQL
- Monitoring: Prometheus and Kafka Exporter collecting metrics
- All components healthy
- **Consumer Lag**: Real-time: 0 (✅), Batch: 69 (✅ expected)
- **Throughput**: ~1 event/second matching producer rate
- **System Health**: All components operational
- **Data Flow**: Producer → Kafka → Consumers → PostgreSQL ✅

**Overall System Status: ✅ OPERATIONAL & HEALTHY**
