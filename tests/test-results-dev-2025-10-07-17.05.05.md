# Data Platform End-to-End Test Results
**Test Date:** Tue Oct  7 17:05:05 CEST 2025
**Environment:** dev
**PostgreSQL Password:** ********
**Timestamp:** 2025-10-07-17.05.05

## 🧪 Test Summary

| Component | Status | Details |
|-----------|--------|---------|
### 2.5.1 Check Prometheus Service
```bash
# Command: kubectl get svc -n monitoring-dev | grep prometheus
prometheus-dev-alertmanager               ClusterIP   10.101.248.197   <none>        9093/TCP   2m46s
prometheus-dev-alertmanager-headless      ClusterIP   None             <none>        9093/TCP   2m46s
prometheus-dev-kube-state-metrics         ClusterIP   10.110.249.154   <none>        8080/TCP   2m46s
prometheus-dev-prometheus-node-exporter   ClusterIP   10.110.166.133   <none>        9100/TCP   2m46s
prometheus-dev-prometheus-pushgateway     ClusterIP   10.108.48.154    <none>        9091/TCP   2m46s
prometheus-dev-server                     ClusterIP   10.108.247.12    <none>        80/TCP     2m46s
```

## 1. Cluster Status

### 1.1 All Namespaces
```bash
# Command: kubectl get namespaces
NAME                STATUS   AGE
data-platform-dev   Active   3m13s
default             Active   4h33m
kafka-dev           Active   5m20s
kube-node-lease     Active   4h33m
kube-public         Active   4h33m
kube-system         Active   4h33m
monitoring-dev      Active   3m13s
postgresql-dev      Active   6m25s
```

### 1.2 Data Platform Pods
```bash
# Command: kubectl get pods -n data-platform-dev -o wide
NAME                               READY   STATUS    RESTARTS   AGE     IP            NODE       NOMINATED NODE   READINESS GATES
batch-consumer-75694c5664-8q297    1/1     Running   0          3m5s    10.244.0.52   minikube   <none>           <none>
event-producer-554cfb88f8-t6blm    1/1     Running   0          3m14s   10.244.0.50   minikube   <none>           <none>
stream-consumer-56ddcd7f49-b5zsv   1/1     Running   0          3m6s    10.244.0.51   minikube   <none>           <none>
```

### 1.3 Kafka Pods
```bash
# Command: kubectl get pods -n kafka-dev -o wide
NAME                                                            READY   STATUS    RESTARTS   AGE     IP            NODE       NOMINATED NODE   READINESS GATES
kafka-dev-controller-0                                          2/2     Running   0          4m56s   10.244.0.48   minikube   <none>           <none>
kafka-dev-controller-1                                          2/2     Running   0          4m56s   10.244.0.47   minikube   <none>           <none>
kafka-dev-controller-2                                          2/2     Running   0          4m56s   10.244.0.46   minikube   <none>           <none>
kafka-exporter-dev-prometheus-kafka-exporter-765c498c99-x5g8p   1/1     Running   0          3m21s   10.244.0.49   minikube   <none>           <none>
```

### 1.4 PostgreSQL Pods
```bash
# Command: kubectl get pods -n postgresql-dev -o wide
NAME               READY   STATUS    RESTARTS   AGE     IP            NODE       NOMINATED NODE   READINESS GATES
postgresql-dev-0   1/1     Running   0          5m44s   10.244.0.45   minikube   <none>           <none>
```

### 1.5 Monitoring Pods
```bash
# Command: kubectl get pods -n monitoring-dev -o wide
NAME                                                     READY   STATUS    RESTARTS   AGE     IP             NODE       NOMINATED NODE   READINESS GATES
prometheus-dev-alertmanager-0                            1/1     Running   0          2m49s   10.244.0.54    minikube   <none>           <none>
prometheus-dev-kube-state-metrics-77744d6dff-8rpls       1/1     Running   0          2m49s   10.244.0.53    minikube   <none>           <none>
prometheus-dev-prometheus-node-exporter-qsx2v            1/1     Running   0          2m49s   192.168.49.2   minikube   <none>           <none>
prometheus-dev-prometheus-pushgateway-746f57fd75-zfdpq   1/1     Running   0          2m49s   10.244.0.56    minikube   <none>           <none>
prometheus-dev-server-c95bff4c7-t9285                    2/2     Running   0          2m49s   10.244.0.55    minikube   <none>           <none>
```

## 2. Application Logs

### 2.1 Producer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-dev deployment/event-producer --tail=10
INFO:__main__:Sent 90 events. Last event: {'event_type': 'view', 'user_id': 7158, 'timestamp': '2025-10-07T15:03:31.269104Z'}
INFO:__main__:Sent 100 events. Last event: {'event_type': 'user_signup', 'user_id': 7541, 'timestamp': '2025-10-07T15:03:41.417040Z'}
INFO:__main__:Sent 110 events. Last event: {'event_type': 'user_signup', 'user_id': 2052, 'timestamp': '2025-10-07T15:03:51.492454Z'}
INFO:__main__:Sent 120 events. Last event: {'event_type': 'user_signup', 'user_id': 2605, 'timestamp': '2025-10-07T15:04:01.919568Z'}
INFO:__main__:Sent 130 events. Last event: {'event_type': 'click', 'user_id': 8185, 'timestamp': '2025-10-07T15:04:12.061344Z'}
INFO:__main__:Sent 140 events. Last event: {'event_type': 'click', 'user_id': 9098, 'timestamp': '2025-10-07T15:04:22.090379Z'}
INFO:__main__:Sent 150 events. Last event: {'event_type': 'click', 'user_id': 2683, 'timestamp': '2025-10-07T15:04:32.307008Z'}
INFO:__main__:Sent 160 events. Last event: {'event_type': 'user_signup', 'user_id': 6482, 'timestamp': '2025-10-07T15:04:42.332488Z'}
INFO:__main__:Sent 170 events. Last event: {'event_type': 'purchase', 'user_id': 2870, 'timestamp': '2025-10-07T15:04:52.367020Z'}
INFO:__main__:Sent 180 events. Last event: {'event_type': 'user_signup', 'user_id': 6086, 'timestamp': '2025-10-07T15:05:02.458901Z'}
```

### 2.2 Real-time Consumer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-dev deployment/stream-consumer --tail=10
2025-10-07 15:05:01,602 - INFO - Processed event: user_id=9539, type=purchase
2025-10-07 15:05:02,821 - INFO - Processed event: user_id=6086, type=user_signup
2025-10-07 15:05:02,821 - INFO - Processed 180 events total
2025-10-07 15:05:03,705 - INFO - Processed event: user_id=6782, type=click
2025-10-07 15:05:04,642 - INFO - Processed event: user_id=9679, type=user_signup
2025-10-07 15:05:05,543 - INFO - Processed event: user_id=6253, type=user_signup
2025-10-07 15:05:06,759 - INFO - Processed event: user_id=4886, type=purchase
2025-10-07 15:05:07,580 - INFO - Processed event: user_id=7638, type=user_signup
2025-10-07 15:05:08,754 - INFO - Processed event: user_id=6609, type=purchase
2025-10-07 15:05:09,636 - INFO - Processed event: user_id=7549, type=view
```

### 2.3 Batch Consumer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-dev deployment/batch-consumer --tail=10
2025-10-07 15:02:17,962 - INFO - Updated partition assignment: [TopicPartition(topic='domain-events', partition=0)]
2025-10-07 15:02:17,965 - INFO - Setting newly assigned partitions {TopicPartition(topic='domain-events', partition=0)} for group batch-consumer-group
2025-10-07 15:02:18,085 - INFO - <BrokerConnection node_id=0 host=kafka-dev-controller-0.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connecting> [IPv4 ('10.244.0.48', 9092)]>: connecting to kafka-dev-controller-0.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 [('10.244.0.48', 9092) IPv4]
2025-10-07 15:02:18,086 - INFO - <BrokerConnection node_id=0 host=kafka-dev-controller-0.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connecting> [IPv4 ('10.244.0.48', 9092)]>: Connection complete.
2025-10-07 15:02:18,777 - INFO - Batch processing completed: 18 events processed in 10.43 seconds
2025-10-07 15:02:18,921 - INFO - Stopping heartbeat thread
2025-10-07 15:02:19,029 - INFO - Leaving consumer group (batch-consumer-group).
2025-10-07 15:02:19,084 - INFO - <BrokerConnection node_id=1 host=kafka-dev-controller-1.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.47', 9092)]>: Closing connection. 
2025-10-07 15:02:19,087 - INFO - <BrokerConnection node_id=coordinator-0 host=kafka-dev-controller-0.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.48', 9092)]>: Closing connection. 
2025-10-07 15:02:19,088 - INFO - <BrokerConnection node_id=0 host=kafka-dev-controller-0.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.48', 9092)]>: Closing connection. 
```

## 4. Database Verification

### 4.1 Table Row Counts
```bash
# Command: SELECT 'Real-time events count:', COUNT(*) FROM events_realtime; SELECT 'Batch events count:', COUNT(*) FROM events_batch;
        ?column?         | count 
-------------------------+-------
 Real-time events count: |   192
(1 row)

      ?column?       | count 
---------------------+-------
 Batch events count: |    18
(1 row)

```

### 4.2 Recent Events Sample
```bash
# Command: SELECT 'Latest 5 real-time events:', event_type, user_id, TO_CHAR(timestamp, 'YYYY-MM-DD HH24:MI:SS'), consumed_at_ts FROM events_realtime ORDER BY id DESC LIMIT 5; SELECT 'Latest 5 batch events:', event_type, user_id, TO_CHAR(timestamp, 'YYYY-MM-DD HH24:MI:SS'), consumed_at_ts FROM events_batch ORDER BY id DESC LIMIT 5;
          ?column?          | event_type | user_id |       to_char       | consumed_at_ts 
----------------------------+------------+---------+---------------------+----------------
 Latest 5 real-time events: | view       |     928 | 2025-10-07 15:05:16 |     1759849516
 Latest 5 real-time events: | view       |     717 | 2025-10-07 15:05:15 |     1759849515
 Latest 5 real-time events: | click      |    9969 | 2025-10-07 15:05:14 |     1759849514
 Latest 5 real-time events: | purchase   |    8580 | 2025-10-07 15:05:13 |     1759849513
 Latest 5 real-time events: | view       |    6019 | 2025-10-07 15:05:12 |     1759849512
(5 rows)

        ?column?        | event_type  | user_id |       to_char       | consumed_at_ts 
------------------------+-------------+---------+---------------------+----------------
 Latest 5 batch events: | user_signup |    2771 | 2025-10-07 15:02:17 |     1759849338
 Latest 5 batch events: | purchase    |    8349 | 2025-10-07 15:02:16 |     1759849338
 Latest 5 batch events: | user_signup |    5698 | 2025-10-07 15:02:15 |     1759849338
 Latest 5 batch events: | purchase    |    1028 | 2025-10-07 15:02:14 |     1759849338
 Latest 5 batch events: | purchase    |    4432 | 2025-10-07 15:02:13 |     1759849338
(5 rows)

```

### 4.3 Event Type Distribution
```bash
# Command: SELECT 'Real-time event types:', event_type, COUNT(*) FROM events_realtime GROUP BY event_type ORDER BY COUNT(*) DESC; SELECT 'Batch event types:', event_type, COUNT(*) FROM events_batch GROUP BY event_type ORDER BY COUNT(*) DESC;
        ?column?        | event_type  | count 
------------------------+-------------+-------
 Real-time event types: | purchase    |    60
 Real-time event types: | user_signup |    53
 Real-time event types: | click       |    45
 Real-time event types: | view        |    38
(4 rows)

      ?column?      | event_type  | count 
--------------------+-------------+-------
 Batch event types: | purchase    |     8
 Batch event types: | click       |     5
 Batch event types: | user_signup |     4
 Batch event types: | view        |     1
(4 rows)

```

## 5. Data Flow Verification

### 5.1 Events in Last 10 Minutes
```bash
# Command: SELECT 'Real-time events (last 10 min):', COUNT(*) FROM events_realtime WHERE consumed_at_ts > EXTRACT(EPOCH FROM NOW()) - 600; SELECT 'Batch events (last 10 min):', COUNT(*) FROM events_batch WHERE consumed_at_ts > EXTRACT(EPOCH FROM NOW()) - 600;
            ?column?             | count 
---------------------------------+-------
 Real-time events (last 10 min): |   198
(1 row)

          ?column?           | count 
-----------------------------+-------
 Batch events (last 10 min): |    18
(1 row)

```

## 6. Service Connectivity

### 6.1 Service Discovery
```bash
# Command: kubectl get svc -A | grep -E '(kafka|postgresql|prometheus)'
kafka-dev        kafka-dev                                      ClusterIP   10.105.184.160   <none>        9092/TCP                     5m11s
kafka-dev        kafka-dev-controller-headless                  ClusterIP   None             <none>        9094/TCP,9092/TCP,9093/TCP   5m11s
kafka-dev        kafka-dev-jmx-metrics                          ClusterIP   10.96.163.134    <none>        5556/TCP                     5m11s
kafka-dev        kafka-exporter-dev-prometheus-kafka-exporter   ClusterIP   10.108.151.26    <none>        9308/TCP                     3m35s
monitoring-dev   prometheus-dev-alertmanager                    ClusterIP   10.101.248.197   <none>        9093/TCP                     3m2s
monitoring-dev   prometheus-dev-alertmanager-headless           ClusterIP   None             <none>        9093/TCP                     3m2s
monitoring-dev   prometheus-dev-kube-state-metrics              ClusterIP   10.110.249.154   <none>        8080/TCP                     3m2s
monitoring-dev   prometheus-dev-prometheus-node-exporter        ClusterIP   10.110.166.133   <none>        9100/TCP                     3m2s
monitoring-dev   prometheus-dev-prometheus-pushgateway          ClusterIP   10.108.48.154    <none>        9091/TCP                     3m2s
monitoring-dev   prometheus-dev-server                          ClusterIP   10.108.247.12    <none>        80/TCP                       3m2s
postgresql-dev   postgresql-dev                                 ClusterIP   10.100.184.144   <none>        5432/TCP                     5m59s
postgresql-dev   postgresql-dev-hl                              ClusterIP   None             <none>        5432/TCP                     5m59s
```

## 📊 Test Summary

### Component Status

| Component | Test | Status |
|-----------|------|--------|
| Producer | Pod Running | ✅ PASS |
| Real-time Consumer | Pod Running | ✅ PASS |
| Batch Consumer | Pod Running | ✅ PASS |
| Real-time Table | Has Data (203 rows) | ✅ PASS |
| Batch Table | Has Data (18 rows) | ✅ PASS |
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
