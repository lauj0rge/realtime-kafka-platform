# Data Platform End-to-End Test Results
**Test Date:** Tue Oct  7 13:34:16 CEST 2025
**Environment:** prod
**PostgreSQL Password:** ********
**Timestamp:** 2025-10-07-13.34.16

## 🧪 Test Summary

| Component | Status | Details |
|-----------|--------|---------|
### 2.5.1 Check Prometheus Service
```bash
# Command: kubectl get svc -n monitoring-prod | grep prometheus
prometheus-prod-alertmanager               ClusterIP   10.106.4.74      <none>        9093/TCP   10m
prometheus-prod-alertmanager-headless      ClusterIP   None             <none>        9093/TCP   10m
prometheus-prod-kube-state-metrics         ClusterIP   10.107.122.238   <none>        8080/TCP   10m
prometheus-prod-prometheus-node-exporter   ClusterIP   10.101.129.50    <none>        9100/TCP   10m
prometheus-prod-prometheus-pushgateway     ClusterIP   10.96.152.204    <none>        9091/TCP   10m
prometheus-prod-server                     ClusterIP   10.109.53.189    <none>        80/TCP     10m
```

## 1. Cluster Status

### 1.1 All Namespaces
```bash
# Command: kubectl get namespaces
NAME                 STATUS   AGE
data-platform-prod   Active   22m
default              Active   62m
kafka-prod           Active   24m
kube-node-lease      Active   62m
kube-public          Active   62m
kube-system          Active   62m
monitoring-prod      Active   22m
postgresql-prod      Active   26m
```

### 1.2 Data Platform Pods
```bash
# Command: kubectl get pods -n data-platform-prod -o wide
NAME                               READY   STATUS    RESTARTS   AGE   IP            NODE       NOMINATED NODE   READINESS GATES
batch-consumer-74dd88cd86-ghg5s    1/1     Running   0          22m   10.244.0.32   minikube   <none>           <none>
event-producer-65687c5d98-xsrxf    1/1     Running   0          22m   10.244.0.30   minikube   <none>           <none>
stream-consumer-696ccb6c6c-kq4wv   1/1     Running   0          22m   10.244.0.31   minikube   <none>           <none>
```

### 1.3 Kafka Pods
```bash
# Command: kubectl get pods -n kafka-prod -o wide
NAME                                                             READY   STATUS    RESTARTS   AGE   IP            NODE       NOMINATED NODE   READINESS GATES
kafka-exporter-prod-prometheus-kafka-exporter-55d7d5d974-p6rd6   1/1     Running   0          23m   10.244.0.29   minikube   <none>           <none>
kafka-prod-controller-0                                          2/2     Running   0          24m   10.244.0.26   minikube   <none>           <none>
kafka-prod-controller-1                                          2/2     Running   0          24m   10.244.0.27   minikube   <none>           <none>
kafka-prod-controller-2                                          2/2     Running   0          24m   10.244.0.28   minikube   <none>           <none>
```

### 1.4 PostgreSQL Pods
```bash
# Command: kubectl get pods -n postgresql-prod -o wide
NAME                READY   STATUS    RESTARTS   AGE   IP            NODE       NOMINATED NODE   READINESS GATES
postgresql-prod-0   1/1     Running   0          25m   10.244.0.25   minikube   <none>           <none>
```

### 1.5 Monitoring Pods
```bash
# Command: kubectl get pods -n monitoring-prod -o wide
NAME                                                      READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
prometheus-prod-alertmanager-0                            1/1     Running   0          10m   10.244.0.44    minikube   <none>           <none>
prometheus-prod-kube-state-metrics-54bc659449-m4nvl       1/1     Running   0          10m   10.244.0.42    minikube   <none>           <none>
prometheus-prod-prometheus-node-exporter-76dhr            1/1     Running   0          10m   192.168.49.2   minikube   <none>           <none>
prometheus-prod-prometheus-pushgateway-65d957b76f-n7h5t   1/1     Running   0          10m   10.244.0.43    minikube   <none>           <none>
prometheus-prod-server-d5bcdcbbf-4s6tm                    2/2     Running   0          10m   10.244.0.41    minikube   <none>           <none>
```

## 2. Application Logs

### 2.1 Producer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-prod deployment/event-producer --tail=10
INFO:__main__:Sent 1250 events. Last event: {'event_type': 'click', 'user_id': 6526, 'timestamp': '2025-10-07T11:32:40.528049Z'}
INFO:__main__:Sent 1260 events. Last event: {'event_type': 'view', 'user_id': 2526, 'timestamp': '2025-10-07T11:32:51.261123Z'}
INFO:__main__:Sent 1270 events. Last event: {'event_type': 'click', 'user_id': 3731, 'timestamp': '2025-10-07T11:33:01.322737Z'}
INFO:__main__:Sent 1280 events. Last event: {'event_type': 'purchase', 'user_id': 7513, 'timestamp': '2025-10-07T11:33:11.356094Z'}
INFO:__main__:Sent 1290 events. Last event: {'event_type': 'view', 'user_id': 1285, 'timestamp': '2025-10-07T11:33:21.409315Z'}
INFO:__main__:Sent 1300 events. Last event: {'event_type': 'view', 'user_id': 5381, 'timestamp': '2025-10-07T11:33:31.428038Z'}
INFO:__main__:Sent 1310 events. Last event: {'event_type': 'view', 'user_id': 4519, 'timestamp': '2025-10-07T11:33:41.467201Z'}
INFO:__main__:Sent 1320 events. Last event: {'event_type': 'user_signup', 'user_id': 8548, 'timestamp': '2025-10-07T11:33:52.293181Z'}
INFO:__main__:Sent 1330 events. Last event: {'event_type': 'user_signup', 'user_id': 5547, 'timestamp': '2025-10-07T11:34:02.366897Z'}
INFO:__main__:Sent 1340 events. Last event: {'event_type': 'user_signup', 'user_id': 5903, 'timestamp': '2025-10-07T11:34:12.441490Z'}
```

### 2.2 Real-time Consumer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-prod deployment/stream-consumer --tail=10
2025-10-07 11:34:09,453 - INFO - Processed event: user_id=3079, type=view
2025-10-07 11:34:10,469 - INFO - Processed event: user_id=3977, type=view
2025-10-07 11:34:11,466 - INFO - Processed event: user_id=7912, type=view
2025-10-07 11:34:12,476 - INFO - Processed event: user_id=5903, type=user_signup
2025-10-07 11:34:12,476 - INFO - Processed 1340 events total
2025-10-07 11:34:13,527 - INFO - Processed event: user_id=4624, type=view
2025-10-07 11:34:14,541 - INFO - Processed event: user_id=1654, type=click
2025-10-07 11:34:15,571 - INFO - Processed event: user_id=4319, type=purchase
2025-10-07 11:34:16,568 - INFO - Processed event: user_id=5433, type=view
2025-10-07 11:34:17,515 - INFO - Processed event: user_id=6539, type=purchase
```

### 2.3 Batch Consumer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-prod deployment/batch-consumer --tail=10
2025-10-07 11:31:53,788 - INFO - Updated partition assignment: [TopicPartition(topic='domain-events', partition=0)]
2025-10-07 11:31:53,788 - INFO - Setting newly assigned partitions {TopicPartition(topic='domain-events', partition=0)} for group batch-consumer-group
2025-10-07 11:31:53,915 - INFO - <BrokerConnection node_id=0 host=kafka-prod-controller-0.kafka-prod-controller-headless.kafka-prod.svc.cluster.local:9092 <connecting> [IPv4 ('10.244.0.26', 9092)]>: connecting to kafka-prod-controller-0.kafka-prod-controller-headless.kafka-prod.svc.cluster.local:9092 [('10.244.0.26', 9092) IPv4]
2025-10-07 11:31:53,920 - INFO - <BrokerConnection node_id=0 host=kafka-prod-controller-0.kafka-prod-controller-headless.kafka-prod.svc.cluster.local:9092 <connecting> [IPv4 ('10.244.0.26', 9092)]>: Connection complete.
2025-10-07 11:31:55,474 - INFO - Batch processing completed: 298 events processed in 4.91 seconds
2025-10-07 11:31:55,487 - INFO - Stopping heartbeat thread
2025-10-07 11:31:55,488 - INFO - Leaving consumer group (batch-consumer-group).
2025-10-07 11:31:55,509 - INFO - <BrokerConnection node_id=coordinator-2 host=kafka-prod-controller-2.kafka-prod-controller-headless.kafka-prod.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.28', 9092)]>: Closing connection. 
2025-10-07 11:31:55,510 - INFO - <BrokerConnection node_id=1 host=kafka-prod-controller-1.kafka-prod-controller-headless.kafka-prod.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.27', 9092)]>: Closing connection. 
2025-10-07 11:31:55,512 - INFO - <BrokerConnection node_id=0 host=kafka-prod-controller-0.kafka-prod-controller-headless.kafka-prod.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.26', 9092)]>: Closing connection. 
```

## 4. Database Verification

### 4.1 Table Row Counts
```bash
# Command: SELECT 'Real-time events count:', COUNT(*) FROM events_realtime; SELECT 'Batch events count:', COUNT(*) FROM events_batch;
        ?column?         | count 
-------------------------+-------
 Real-time events count: |  1347
(1 row)

      ?column?       | count 
---------------------+-------
 Batch events count: |  1205
(1 row)

```

### 4.2 Recent Events Sample
```bash
# Command: SELECT 'Latest 5 real-time events:', event_type, user_id, TO_CHAR(timestamp, 'YYYY-MM-DD HH24:MI:SS'), consumed_at_ts FROM events_realtime ORDER BY id DESC LIMIT 5; SELECT 'Latest 5 batch events:', event_type, user_id, TO_CHAR(timestamp, 'YYYY-MM-DD HH24:MI:SS'), consumed_at_ts FROM events_batch ORDER BY id DESC LIMIT 5;
          ?column?          | event_type | user_id |       to_char       | consumed_at_ts 
----------------------------+------------+---------+---------------------+----------------
 Latest 5 real-time events: | view       |    9516 | 2025-10-07 11:34:21 |     1759836861
 Latest 5 real-time events: | purchase   |    2675 | 2025-10-07 11:34:20 |     1759836860
 Latest 5 real-time events: | purchase   |    8368 | 2025-10-07 11:34:19 |     1759836859
 Latest 5 real-time events: | click      |    5151 | 2025-10-07 11:34:18 |     1759836858
 Latest 5 real-time events: | purchase   |    6539 | 2025-10-07 11:34:17 |     1759836857
(5 rows)

        ?column?        | event_type  | user_id |       to_char       | consumed_at_ts 
------------------------+-------------+---------+---------------------+----------------
 Latest 5 batch events: | user_signup |    2480 | 2025-10-07 11:31:53 |     1759836715
 Latest 5 batch events: | view        |    9642 | 2025-10-07 11:31:52 |     1759836715
 Latest 5 batch events: | user_signup |    9843 | 2025-10-07 11:31:51 |     1759836715
 Latest 5 batch events: | user_signup |    8609 | 2025-10-07 11:31:50 |     1759836715
 Latest 5 batch events: | click       |    1341 | 2025-10-07 11:31:49 |     1759836715
(5 rows)

```

### 4.3 Event Type Distribution
```bash
# Command: SELECT 'Real-time event types:', event_type, COUNT(*) FROM events_realtime GROUP BY event_type ORDER BY COUNT(*) DESC; SELECT 'Batch event types:', event_type, COUNT(*) FROM events_batch GROUP BY event_type ORDER BY COUNT(*) DESC;
        ?column?        | event_type  | count 
------------------------+-------------+-------
 Real-time event types: | view        |   345
 Real-time event types: | user_signup |   340
 Real-time event types: | purchase    |   339
 Real-time event types: | click       |   327
(4 rows)

      ?column?      | event_type  | count 
--------------------+-------------+-------
 Batch event types: | user_signup |   307
 Batch event types: | view        |   303
 Batch event types: | purchase    |   303
 Batch event types: | click       |   292
(4 rows)

```

## 5. Data Flow Verification

### 5.1 Events in Last 10 Minutes
```bash
# Command: SELECT 'Real-time events (last 10 min):', COUNT(*) FROM events_realtime WHERE consumed_at_ts > EXTRACT(EPOCH FROM NOW()) - 600; SELECT 'Batch events (last 10 min):', COUNT(*) FROM events_batch WHERE consumed_at_ts > EXTRACT(EPOCH FROM NOW()) - 600;
            ?column?             | count 
---------------------------------+-------
 Real-time events (last 10 min): |   586
(1 row)

          ?column?           | count 
-----------------------------+-------
 Batch events (last 10 min): |   596
(1 row)

```

## 6. Service Connectivity

### 6.1 Service Discovery
```bash
# Command: kubectl get svc -A | grep -E '(kafka|postgresql|prometheus)'
kafka-prod        kafka-exporter-prod-prometheus-kafka-exporter   ClusterIP   10.109.183.103   <none>        9308/TCP                     23m
kafka-prod        kafka-prod                                      ClusterIP   10.110.222.215   <none>        9092/TCP                     24m
kafka-prod        kafka-prod-controller-headless                  ClusterIP   None             <none>        9094/TCP,9092/TCP,9093/TCP   24m
kafka-prod        kafka-prod-jmx-metrics                          ClusterIP   10.107.35.159    <none>        5556/TCP                     24m
monitoring-prod   prometheus-prod-alertmanager                    ClusterIP   10.106.4.74      <none>        9093/TCP                     10m
monitoring-prod   prometheus-prod-alertmanager-headless           ClusterIP   None             <none>        9093/TCP                     10m
monitoring-prod   prometheus-prod-kube-state-metrics              ClusterIP   10.107.122.238   <none>        8080/TCP                     10m
monitoring-prod   prometheus-prod-prometheus-node-exporter        ClusterIP   10.101.129.50    <none>        9100/TCP                     10m
monitoring-prod   prometheus-prod-prometheus-pushgateway          ClusterIP   10.96.152.204    <none>        9091/TCP                     10m
monitoring-prod   prometheus-prod-server                          ClusterIP   10.109.53.189    <none>        80/TCP                       10m
postgresql-prod   postgresql-prod                                 ClusterIP   10.108.133.124   <none>        5432/TCP                     25m
postgresql-prod   postgresql-prod-hl                              ClusterIP   None             <none>        5432/TCP                     25m
```

## 📊 Test Summary

### Component Status

| Component | Test | Status |
|-----------|------|--------|
| Producer | Pod Running | ✅ PASS |
| Real-time Consumer | Pod Running | ✅ PASS |
| Batch Consumer | Pod Running | ✅ PASS |
| Real-time Table | Has Data (1355 rows) | ✅ PASS |
| Batch Table | Has Data (1205 rows) | ✅ PASS |
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
