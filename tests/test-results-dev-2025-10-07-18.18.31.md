# Data Platform End-to-End Test Results
**Test Date:** Tue Oct  7 18:18:31 CEST 2025
**Environment:** dev
**PostgreSQL Password:** ********
**Timestamp:** 2025-10-07-18.18.31

## 🧪 Test Summary

| Component | Status | Details |
|-----------|--------|---------|
### 2.5.1 Check Prometheus Service
```bash
# Command: kubectl get svc -n monitoring-dev | grep prometheus
prometheus-dev-alertmanager               ClusterIP   10.101.248.197   <none>        9093/TCP   76m
prometheus-dev-alertmanager-headless      ClusterIP   None             <none>        9093/TCP   76m
prometheus-dev-kube-state-metrics         ClusterIP   10.110.249.154   <none>        8080/TCP   76m
prometheus-dev-prometheus-node-exporter   ClusterIP   10.110.166.133   <none>        9100/TCP   76m
prometheus-dev-prometheus-pushgateway     ClusterIP   10.108.48.154    <none>        9091/TCP   76m
prometheus-dev-server                     ClusterIP   10.108.247.12    <none>        80/TCP     76m
```

## 1. Cluster Status

### 1.1 All Namespaces
```bash
# Command: kubectl get namespaces
NAME                STATUS   AGE
data-platform-dev   Active   76m
default             Active   5h46m
kafka-dev           Active   78m
kube-node-lease     Active   5h46m
kube-public         Active   5h46m
kube-system         Active   5h46m
monitoring-dev      Active   76m
postgresql-dev      Active   79m
```

### 1.2 Data Platform Pods
```bash
# Command: kubectl get pods -n data-platform-dev -o wide
NAME                               READY   STATUS    RESTARTS   AGE   IP            NODE       NOMINATED NODE   READINESS GATES
batch-consumer-75694c5664-8q297    1/1     Running   0          76m   10.244.0.52   minikube   <none>           <none>
event-producer-554cfb88f8-t6blm    1/1     Running   0          76m   10.244.0.50   minikube   <none>           <none>
stream-consumer-56ddcd7f49-b5zsv   1/1     Running   0          76m   10.244.0.51   minikube   <none>           <none>
```

### 1.3 Kafka Pods
```bash
# Command: kubectl get pods -n kafka-dev -o wide
NAME                                                            READY   STATUS    RESTARTS   AGE   IP            NODE       NOMINATED NODE   READINESS GATES
kafka-dev-controller-0                                          2/2     Running   0          78m   10.244.0.48   minikube   <none>           <none>
kafka-dev-controller-1                                          2/2     Running   0          78m   10.244.0.47   minikube   <none>           <none>
kafka-dev-controller-2                                          2/2     Running   0          78m   10.244.0.46   minikube   <none>           <none>
kafka-exporter-dev-prometheus-kafka-exporter-765c498c99-x5g8p   1/1     Running   0          76m   10.244.0.49   minikube   <none>           <none>
```

### 1.4 PostgreSQL Pods
```bash
# Command: kubectl get pods -n postgresql-dev -o wide
NAME               READY   STATUS    RESTARTS   AGE   IP            NODE       NOMINATED NODE   READINESS GATES
postgresql-dev-0   1/1     Running   0          79m   10.244.0.45   minikube   <none>           <none>
```

### 1.5 Monitoring Pods
```bash
# Command: kubectl get pods -n monitoring-dev -o wide
NAME                                                     READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
prometheus-dev-alertmanager-0                            1/1     Running   0          76m   10.244.0.54    minikube   <none>           <none>
prometheus-dev-kube-state-metrics-77744d6dff-8rpls       1/1     Running   0          76m   10.244.0.53    minikube   <none>           <none>
prometheus-dev-prometheus-node-exporter-qsx2v            1/1     Running   0          76m   192.168.49.2   minikube   <none>           <none>
prometheus-dev-prometheus-pushgateway-746f57fd75-zfdpq   1/1     Running   0          76m   10.244.0.56    minikube   <none>           <none>
prometheus-dev-server-c95bff4c7-t9285                    2/2     Running   0          76m   10.244.0.55    minikube   <none>           <none>
```

## 2. Application Logs

### 2.1 Producer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-dev deployment/event-producer --tail=10
INFO:__main__:Sent 4440 events. Last event: {'event_type': 'purchase', 'user_id': 2548, 'timestamp': '2025-10-07T16:17:01.458707Z'}
INFO:__main__:Sent 4450 events. Last event: {'event_type': 'click', 'user_id': 5400, 'timestamp': '2025-10-07T16:17:11.554202Z'}
INFO:__main__:Sent 4460 events. Last event: {'event_type': 'user_signup', 'user_id': 437, 'timestamp': '2025-10-07T16:17:21.602348Z'}
INFO:__main__:Sent 4470 events. Last event: {'event_type': 'purchase', 'user_id': 9201, 'timestamp': '2025-10-07T16:17:31.680765Z'}
INFO:__main__:Sent 4480 events. Last event: {'event_type': 'user_signup', 'user_id': 7451, 'timestamp': '2025-10-07T16:17:41.704337Z'}
INFO:__main__:Sent 4490 events. Last event: {'event_type': 'click', 'user_id': 6273, 'timestamp': '2025-10-07T16:17:51.758093Z'}
INFO:__main__:Sent 4500 events. Last event: {'event_type': 'click', 'user_id': 7613, 'timestamp': '2025-10-07T16:18:02.593355Z'}
INFO:__main__:Sent 4510 events. Last event: {'event_type': 'view', 'user_id': 6302, 'timestamp': '2025-10-07T16:18:12.651683Z'}
INFO:__main__:Sent 4520 events. Last event: {'event_type': 'click', 'user_id': 4220, 'timestamp': '2025-10-07T16:18:22.760754Z'}
INFO:__main__:Sent 4530 events. Last event: {'event_type': 'click', 'user_id': 8492, 'timestamp': '2025-10-07T16:18:33.481871Z'}
```

### 2.2 Real-time Consumer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-dev deployment/stream-consumer --tail=10
2025-10-07 16:18:26,833 - INFO - Processed event: user_id=8419, type=user_signup
2025-10-07 16:18:28,804 - INFO - Processed event: user_id=4155, type=purchase
2025-10-07 16:18:29,499 - INFO - Processed event: user_id=2921, type=purchase
2025-10-07 16:18:30,514 - INFO - Processed event: user_id=9591, type=view
2025-10-07 16:18:31,513 - INFO - Processed event: user_id=204, type=user_signup
2025-10-07 16:18:32,549 - INFO - Processed event: user_id=5698, type=click
2025-10-07 16:18:33,734 - INFO - Processed event: user_id=8492, type=click
2025-10-07 16:18:33,779 - INFO - Processed 4530 events total
2025-10-07 16:18:34,691 - INFO - Processed event: user_id=2705, type=user_signup
2025-10-07 16:18:35,706 - INFO - Processed event: user_id=9314, type=user_signup
```

### 2.3 Batch Consumer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-dev deployment/batch-consumer --tail=10
2025-10-07 16:18:23,944 - INFO - <BrokerConnection node_id=0 host=kafka-dev-controller-0.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connecting> [IPv4 ('10.244.0.48', 9092)]>: connecting to kafka-dev-controller-0.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 [('10.244.0.48', 9092) IPv4]
2025-10-07 16:18:23,947 - INFO - <BrokerConnection node_id=0 host=kafka-dev-controller-0.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connecting> [IPv4 ('10.244.0.48', 9092)]>: Connection complete.
2025-10-07 16:18:23,973 - INFO - Successfully joined group batch-consumer-group with generation 31
2025-10-07 16:18:23,974 - INFO - Updated partition assignment: [TopicPartition(topic='domain-events', partition=0)]
2025-10-07 16:18:23,974 - INFO - Setting newly assigned partitions {TopicPartition(topic='domain-events', partition=0)} for group batch-consumer-group
2025-10-07 16:18:26,243 - INFO - Batch processing completed: 298 events processed in 5.45 seconds
2025-10-07 16:18:26,261 - INFO - Stopping heartbeat thread
2025-10-07 16:18:26,262 - INFO - Leaving consumer group (batch-consumer-group).
2025-10-07 16:18:26,277 - INFO - <BrokerConnection node_id=coordinator-0 host=kafka-dev-controller-0.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.48', 9092)]>: Closing connection. 
2025-10-07 16:18:26,280 - INFO - <BrokerConnection node_id=0 host=kafka-dev-controller-0.kafka-dev-controller-headless.kafka-dev.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.48', 9092)]>: Closing connection. 
```

## 4. Database Verification

### 4.1 Table Row Counts
```bash
# Command: SELECT 'Real-time events count:', COUNT(*) FROM events_realtime; SELECT 'Batch events count:', COUNT(*) FROM events_batch;
        ?column?         | count 
-------------------------+-------
 Real-time events count: |  4535
(1 row)

      ?column?       | count 
---------------------+-------
 Batch events count: |  4521
(1 row)

```

### 4.2 Recent Events Sample
```bash
# Command: SELECT 'Latest 5 real-time events:', event_type, user_id, TO_CHAR(timestamp, 'YYYY-MM-DD HH24:MI:SS'), consumed_at_ts FROM events_realtime ORDER BY id DESC LIMIT 5; SELECT 'Latest 5 batch events:', event_type, user_id, TO_CHAR(timestamp, 'YYYY-MM-DD HH24:MI:SS'), consumed_at_ts FROM events_batch ORDER BY id DESC LIMIT 5;
          ?column?          | event_type  | user_id |       to_char       | consumed_at_ts 
----------------------------+-------------+---------+---------------------+----------------
 Latest 5 real-time events: | user_signup |    9851 | 2025-10-07 16:18:41 |     1759853921
 Latest 5 real-time events: | click       |    6906 | 2025-10-07 16:18:40 |     1759853920
 Latest 5 real-time events: | view        |      84 | 2025-10-07 16:18:39 |     1759853919
 Latest 5 real-time events: | view        |    8285 | 2025-10-07 16:18:38 |     1759853918
 Latest 5 real-time events: | view        |     215 | 2025-10-07 16:18:37 |     1759853917
(5 rows)

        ?column?        | event_type | user_id |       to_char       | consumed_at_ts 
------------------------+------------+---------+---------------------+----------------
 Latest 5 batch events: | view       |    6639 | 2025-10-07 16:18:23 |     1759853906
 Latest 5 batch events: | click      |    4220 | 2025-10-07 16:18:22 |     1759853906
 Latest 5 batch events: | purchase   |    3511 | 2025-10-07 16:18:21 |     1759853906
 Latest 5 batch events: | click      |    4283 | 2025-10-07 16:18:20 |     1759853906
 Latest 5 batch events: | view       |     439 | 2025-10-07 16:18:19 |     1759853906
(5 rows)

```

### 4.3 Event Type Distribution
```bash
# Command: SELECT 'Real-time event types:', event_type, COUNT(*) FROM events_realtime GROUP BY event_type ORDER BY COUNT(*) DESC; SELECT 'Batch event types:', event_type, COUNT(*) FROM events_batch GROUP BY event_type ORDER BY COUNT(*) DESC;
        ?column?        | event_type  | count 
------------------------+-------------+-------
 Real-time event types: | click       |  1149
 Real-time event types: | user_signup |  1148
 Real-time event types: | purchase    |  1132
 Real-time event types: | view        |  1113
(4 rows)

      ?column?      | event_type  | count 
--------------------+-------------+-------
 Batch event types: | user_signup |  1143
 Batch event types: | click       |  1143
 Batch event types: | purchase    |  1129
 Batch event types: | view        |  1106
(4 rows)

```

## 5. Data Flow Verification

### 5.1 Events in Last 10 Minutes
```bash
# Command: SELECT 'Real-time events (last 10 min):', COUNT(*) FROM events_realtime WHERE consumed_at_ts > EXTRACT(EPOCH FROM NOW()) - 600; SELECT 'Batch events (last 10 min):', COUNT(*) FROM events_batch WHERE consumed_at_ts > EXTRACT(EPOCH FROM NOW()) - 600;
            ?column?             | count 
---------------------------------+-------
 Real-time events (last 10 min): |   589
(1 row)

          ?column?           | count 
-----------------------------+-------
 Batch events (last 10 min): |   598
(1 row)

```

## 6. Service Connectivity

### 6.1 Service Discovery
```bash
# Command: kubectl get svc -A | grep -E '(kafka|postgresql|prometheus)'
kafka-dev        kafka-dev                                      ClusterIP   10.105.184.160   <none>        9092/TCP                     78m
kafka-dev        kafka-dev-controller-headless                  ClusterIP   None             <none>        9094/TCP,9092/TCP,9093/TCP   78m
kafka-dev        kafka-dev-jmx-metrics                          ClusterIP   10.96.163.134    <none>        5556/TCP                     78m
kafka-dev        kafka-exporter-dev-prometheus-kafka-exporter   ClusterIP   10.108.151.26    <none>        9308/TCP                     77m
monitoring-dev   prometheus-dev-alertmanager                    ClusterIP   10.101.248.197   <none>        9093/TCP                     76m
monitoring-dev   prometheus-dev-alertmanager-headless           ClusterIP   None             <none>        9093/TCP                     76m
monitoring-dev   prometheus-dev-kube-state-metrics              ClusterIP   10.110.249.154   <none>        8080/TCP                     76m
monitoring-dev   prometheus-dev-prometheus-node-exporter        ClusterIP   10.110.166.133   <none>        9100/TCP                     76m
monitoring-dev   prometheus-dev-prometheus-pushgateway          ClusterIP   10.108.48.154    <none>        9091/TCP                     76m
monitoring-dev   prometheus-dev-server                          ClusterIP   10.108.247.12    <none>        80/TCP                       76m
postgresql-dev   postgresql-dev                                 ClusterIP   10.100.184.144   <none>        5432/TCP                     79m
postgresql-dev   postgresql-dev-hl                              ClusterIP   None             <none>        5432/TCP                     79m
```

## 📊 Test Summary

### Component Status

| Component | Test | Status |
|-----------|------|--------|
| Producer | Pod Running | ✅ PASS |
| Real-time Consumer | Pod Running | ✅ PASS |
| Batch Consumer | Pod Running | ✅ PASS |
| Real-time Table | Has Data (4547 rows) | ✅ PASS |
| Batch Table | Has Data (4521 rows) | ✅ PASS |
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
