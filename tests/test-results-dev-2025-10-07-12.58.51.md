# Data Platform End-to-End Test Results
**Test Date:** Tue Oct  7 12:58:51 CEST 2025
**Environment:** dev
**PostgreSQL Password:** ********
**Timestamp:** 2025-10-07-12.58.51

## 🧪 Test Summary

| Component | Status | Details |
|-----------|--------|---------|
### 2.5.1 Check Prometheus Service
```bash
# Command: kubectl get svc -n monitoring-dev | grep prometheus
prometheus-dev-alertmanager               ClusterIP   10.98.122.161    <none>        9093/TCP   2m42s
prometheus-dev-alertmanager-headless      ClusterIP   None             <none>        9093/TCP   2m42s
prometheus-dev-kube-state-metrics         ClusterIP   10.108.1.250     <none>        8080/TCP   2m42s
prometheus-dev-prometheus-node-exporter   ClusterIP   10.110.190.149   <none>        9100/TCP   2m42s
prometheus-dev-prometheus-pushgateway     ClusterIP   10.105.175.37    <none>        9091/TCP   2m42s
prometheus-dev-server                     ClusterIP   10.96.142.161    <none>        80/TCP     2m42s
```

## 1. Cluster Status

### 1.1 All Namespaces
```bash
# Command: kubectl get namespaces
NAME                STATUS   AGE
data-platform-dev   Active   3m9s
default             Active   26m
kafka-dev           Active   5m51s
kube-node-lease     Active   26m
kube-public         Active   26m
kube-system         Active   26m
monitoring-dev      Active   3m9s
postgresql-dev      Active   5m51s
```

### 1.2 Data Platform Pods
```bash
# Command: kubectl get pods -n data-platform-dev -o wide
NAME                               READY   STATUS    RESTARTS   AGE    IP            NODE       NOMINATED NODE   READINESS GATES
batch-consumer-75694c5664-tl5pf    1/1     Running   0          3m1s   10.244.0.20   minikube   <none>           <none>
event-producer-554cfb88f8-8thfb    1/1     Running   0          3m9s   10.244.0.18   minikube   <none>           <none>
stream-consumer-56ddcd7f49-hgkzb   1/1     Running   0          3m1s   10.244.0.19   minikube   <none>           <none>
```

### 1.3 Kafka Pods
```bash
# Command: kubectl get pods -n kafka-dev -o wide
NAME                                                            READY   STATUS    RESTARTS   AGE     IP            NODE       NOMINATED NODE   READINESS GATES
kafka-dev-controller-0                                          2/2     Running   0          5m9s    10.244.0.13   minikube   <none>           <none>
kafka-dev-controller-1                                          2/2     Running   0          5m9s    10.244.0.14   minikube   <none>           <none>
kafka-dev-controller-2                                          2/2     Running   0          5m9s    10.244.0.15   minikube   <none>           <none>
kafka-exporter-dev-prometheus-kafka-exporter-765c498c99-q9dl6   1/1     Running   0          3m14s   10.244.0.17   minikube   <none>           <none>
```

### 1.4 PostgreSQL Pods
```bash
# Command: kubectl get pods -n postgresql-dev -o wide
NAME               READY   STATUS    RESTARTS   AGE     IP            NODE       NOMINATED NODE   READINESS GATES
postgresql-dev-0   1/1     Running   0          4m42s   10.244.0.16   minikube   <none>           <none>
```

### 1.5 Monitoring Pods
```bash
# Command: kubectl get pods -n monitoring-dev -o wide
NAME                                                     READY   STATUS    RESTARTS   AGE     IP             NODE       NOMINATED NODE   READINESS GATES
prometheus-dev-alertmanager-0                            1/1     Running   0          2m43s   10.244.0.23    minikube   <none>           <none>
prometheus-dev-kube-state-metrics-77744d6dff-b5tsq       1/1     Running   0          2m43s   10.244.0.21    minikube   <none>           <none>
prometheus-dev-prometheus-node-exporter-jt5s7            1/1     Running   0          2m43s   192.168.49.2   minikube   <none>           <none>
prometheus-dev-prometheus-pushgateway-746f57fd75-k9d4p   1/1     Running   0          2m43s   10.244.0.22    minikube   <none>           <none>
prometheus-dev-server-c95bff4c7-kwf8g                    2/2     Running   0          2m43s   10.244.0.24    minikube   <none>           <none>
```

## 2. Application Logs

### 2.1 Producer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-dev deployment/event-producer --tail=10
INFO:__main__:Sent 90 events. Last event: {'event_type': 'purchase', 'user_id': 1409, 'timestamp': '2025-10-07T10:57:20.528789Z'}
INFO:__main__:Sent 100 events. Last event: {'event_type': 'user_signup', 'user_id': 9119, 'timestamp': '2025-10-07T10:57:30.833834Z'}
INFO:__main__:Sent 110 events. Last event: {'event_type': 'purchase', 'user_id': 1154, 'timestamp': '2025-10-07T10:57:41.100419Z'}
INFO:__main__:Sent 120 events. Last event: {'event_type': 'click', 'user_id': 2684, 'timestamp': '2025-10-07T10:57:51.220910Z'}
INFO:__main__:Sent 130 events. Last event: {'event_type': 'click', 'user_id': 9831, 'timestamp': '2025-10-07T10:58:01.343431Z'}
INFO:__main__:Sent 140 events. Last event: {'event_type': 'purchase', 'user_id': 985, 'timestamp': '2025-10-07T10:58:11.800395Z'}
INFO:__main__:Sent 150 events. Last event: {'event_type': 'view', 'user_id': 7035, 'timestamp': '2025-10-07T10:58:21.976823Z'}
INFO:__main__:Sent 160 events. Last event: {'event_type': 'view', 'user_id': 1781, 'timestamp': '2025-10-07T10:58:32.030228Z'}
INFO:__main__:Sent 170 events. Last event: {'event_type': 'view', 'user_id': 7653, 'timestamp': '2025-10-07T10:58:42.144558Z'}
INFO:__main__:Sent 180 events. Last event: {'event_type': 'user_signup', 'user_id': 5604, 'timestamp': '2025-10-07T10:58:52.190773Z'}
```

### 2.2 Real-time Consumer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-dev deployment/stream-consumer --tail=10
2025-10-07 10:58:45,190 - INFO - Processed event: user_id=8728, type=view
2025-10-07 10:58:46,251 - INFO - Processed event: user_id=3687, type=user_signup
2025-10-07 10:58:47,215 - INFO - Processed event: user_id=8931, type=user_signup
2025-10-07 10:58:48,197 - INFO - Processed event: user_id=9036, type=user_signup
2025-10-07 10:58:49,224 - INFO - Processed event: user_id=9580, type=view
2025-10-07 10:58:50,232 - INFO - Processed event: user_id=7289, type=user_signup
2025-10-07 10:58:51,234 - INFO - Processed event: user_id=8340, type=view
2025-10-07 10:58:52,219 - INFO - Processed event: user_id=5604, type=user_signup
2025-10-07 10:58:52,219 - INFO - Processed 180 events total
2025-10-07 10:58:53,221 - INFO - Processed event: user_id=2971, type=purchase
```

### 2.3 Batch Consumer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-dev deployment/batch-consumer --tail=10
2025-10-07 10:56:04,693 - INFO - (Re-)joining group batch-consumer-group
2025-10-07 10:56:07,891 - INFO - Elected group leader -- performing partition assignments using range
2025-10-07 10:56:08,035 - INFO - Successfully joined group batch-consumer-group with generation 1
2025-10-07 10:56:08,037 - INFO - Updated partition assignment: [TopicPartition(topic='domain-events', partition=0)]
2025-10-07 10:56:08,095 - INFO - Setting newly assigned partitions {TopicPartition(topic='domain-events', partition=0)} for group batch-consumer-group
2025-10-07 10:56:08,489 - INFO - Batch processing completed: 18 events processed in 10.73 seconds
2025-10-07 10:56:08,564 - INFO - Stopping heartbeat thread
2025-10-07 10:56:08,570 - INFO - Leaving consumer group (batch-consumer-group).
2025-10-07 10:56:08,699 - INFO - <BrokerConnection node_id=1 host=kafka-dev-controller-1.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.14', 9092)]>: Closing connection. 
2025-10-07 10:56:08,713 - INFO - <BrokerConnection node_id=coordinator-2 host=kafka-dev-controller-2.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.15', 9092)]>: Closing connection. 
```

## 4. Database Verification

### 4.1 Table Row Counts
```bash
# Command: SELECT 'Real-time events count:', COUNT(*) FROM events_realtime; SELECT 'Batch events count:', COUNT(*) FROM events_batch;
        ?column?         | count 
-------------------------+-------
 Real-time events count: |   183
(1 row)

      ?column?       | count 
---------------------+-------
 Batch events count: |    18
(1 row)

```

### 4.2 Recent Events Sample
```bash
# Command: SELECT 'Latest 5 real-time events:', event_type, user_id, TO_CHAR(timestamp, 'YYYY-MM-DD HH24:MI:SS'), consumed_at_ts FROM events_realtime ORDER BY id DESC LIMIT 5; SELECT 'Latest 5 batch events:', event_type, user_id, TO_CHAR(timestamp, 'YYYY-MM-DD HH24:MI:SS'), consumed_at_ts FROM events_batch ORDER BY id DESC LIMIT 5;
          ?column?          | event_type  | user_id |       to_char       | consumed_at_ts 
----------------------------+-------------+---------+---------------------+----------------
 Latest 5 real-time events: | purchase    |     850 | 2025-10-07 10:58:58 |     1759834738
 Latest 5 real-time events: | click       |    6239 | 2025-10-07 10:58:57 |     1759834737
 Latest 5 real-time events: | view        |    2155 | 2025-10-07 10:58:56 |     1759834736
 Latest 5 real-time events: | user_signup |    4981 | 2025-10-07 10:58:55 |     1759834735
 Latest 5 real-time events: | purchase    |    9737 | 2025-10-07 10:58:54 |     1759834734
(5 rows)

        ?column?        | event_type  | user_id |       to_char       | consumed_at_ts 
------------------------+-------------+---------+---------------------+----------------
 Latest 5 batch events: | user_signup |    3705 | 2025-10-07 10:56:07 |     1759834568
 Latest 5 batch events: | click       |    7910 | 2025-10-07 10:56:06 |     1759834568
 Latest 5 batch events: | view        |    4415 | 2025-10-07 10:56:05 |     1759834568
 Latest 5 batch events: | click       |    2904 | 2025-10-07 10:56:04 |     1759834568
 Latest 5 batch events: | click       |    6371 | 2025-10-07 10:56:03 |     1759834568
(5 rows)

```

### 4.3 Event Type Distribution
```bash
# Command: SELECT 'Real-time event types:', event_type, COUNT(*) FROM events_realtime GROUP BY event_type ORDER BY COUNT(*) DESC; SELECT 'Batch event types:', event_type, COUNT(*) FROM events_batch GROUP BY event_type ORDER BY COUNT(*) DESC;
        ?column?        | event_type  | count 
------------------------+-------------+-------
 Real-time event types: | view        |    58
 Real-time event types: | purchase    |    48
 Real-time event types: | click       |    45
 Real-time event types: | user_signup |    36
(4 rows)

      ?column?      | event_type  | count 
--------------------+-------------+-------
 Batch event types: | click       |     8
 Batch event types: | user_signup |     5
 Batch event types: | view        |     3
 Batch event types: | purchase    |     2
(4 rows)

```

## 5. Data Flow Verification

### 5.1 Events in Last 10 Minutes
```bash
# Command: SELECT 'Real-time events (last 10 min):', COUNT(*) FROM events_realtime WHERE consumed_at_ts > EXTRACT(EPOCH FROM NOW()) - 600; SELECT 'Batch events (last 10 min):', COUNT(*) FROM events_batch WHERE consumed_at_ts > EXTRACT(EPOCH FROM NOW()) - 600;
            ?column?             | count 
---------------------------------+-------
 Real-time events (last 10 min): |   188
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
kafka-dev        kafka-dev                                      ClusterIP   10.106.132.163   <none>        9092/TCP                     5m19s
kafka-dev        kafka-dev-controller-headless                  ClusterIP   None             <none>        9094/TCP,9092/TCP,9093/TCP   5m19s
kafka-dev        kafka-dev-jmx-metrics                          ClusterIP   10.101.220.28    <none>        5556/TCP                     5m19s
kafka-dev        kafka-exporter-dev-prometheus-kafka-exporter   ClusterIP   10.104.222.100   <none>        9308/TCP                     3m23s
monitoring-dev   prometheus-dev-alertmanager                    ClusterIP   10.98.122.161    <none>        9093/TCP                     2m52s
monitoring-dev   prometheus-dev-alertmanager-headless           ClusterIP   None             <none>        9093/TCP                     2m52s
monitoring-dev   prometheus-dev-kube-state-metrics              ClusterIP   10.108.1.250     <none>        8080/TCP                     2m52s
monitoring-dev   prometheus-dev-prometheus-node-exporter        ClusterIP   10.110.190.149   <none>        9100/TCP                     2m52s
monitoring-dev   prometheus-dev-prometheus-pushgateway          ClusterIP   10.105.175.37    <none>        9091/TCP                     2m52s
monitoring-dev   prometheus-dev-server                          ClusterIP   10.96.142.161    <none>        80/TCP                       2m52s
postgresql-dev   postgresql-dev                                 ClusterIP   10.102.225.16    <none>        5432/TCP                     4m51s
postgresql-dev   postgresql-dev-hl                              ClusterIP   None             <none>        5432/TCP                     4m51s
```

## 📊 Test Summary

### Component Status

| Component | Test | Status |
|-----------|------|--------|
| Producer | Pod Running | ✅ PASS |
| Real-time Consumer | Pod Running | ✅ PASS |
| Batch Consumer | Pod Running | ✅ PASS |
| Real-time Table | Has Data (192 rows) | ✅ PASS |
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
