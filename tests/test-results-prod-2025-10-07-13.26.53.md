# Data Platform End-to-End Test Results
**Test Date:** Tue Oct  7 13:26:53 CEST 2025
**Environment:** prod
**PostgreSQL Password:** ********
**Timestamp:** 2025-10-07-13.26.53

## 🧪 Test Summary

| Component | Status | Details |
|-----------|--------|---------|
### 2.5.1 Check Prometheus Service
```bash
# Command: kubectl get svc -n monitoring-prod | grep prometheus
prometheus-prod-alertmanager               ClusterIP   10.106.4.74      <none>        9093/TCP   2m44s
prometheus-prod-alertmanager-headless      ClusterIP   None             <none>        9093/TCP   2m44s
prometheus-prod-kube-state-metrics         ClusterIP   10.107.122.238   <none>        8080/TCP   2m45s
prometheus-prod-prometheus-node-exporter   ClusterIP   10.101.129.50    <none>        9100/TCP   2m44s
prometheus-prod-prometheus-pushgateway     ClusterIP   10.96.152.204    <none>        9091/TCP   2m45s
prometheus-prod-server                     ClusterIP   10.109.53.189    <none>        80/TCP     2m44s
```

## 1. Cluster Status

### 1.1 All Namespaces
```bash
# Command: kubectl get namespaces
NAME                 STATUS   AGE
data-platform-prod   Active   15m
default              Active   54m
kafka-prod           Active   17m
kube-node-lease      Active   54m
kube-public          Active   54m
kube-system          Active   54m
monitoring-prod      Active   15m
postgresql-prod      Active   18m
```

### 1.2 Data Platform Pods
```bash
# Command: kubectl get pods -n data-platform-prod -o wide
NAME                               READY   STATUS    RESTARTS   AGE   IP            NODE       NOMINATED NODE   READINESS GATES
batch-consumer-74dd88cd86-ghg5s    1/1     Running   0          15m   10.244.0.32   minikube   <none>           <none>
event-producer-65687c5d98-xsrxf    1/1     Running   0          15m   10.244.0.30   minikube   <none>           <none>
stream-consumer-696ccb6c6c-kq4wv   1/1     Running   0          15m   10.244.0.31   minikube   <none>           <none>
```

### 1.3 Kafka Pods
```bash
# Command: kubectl get pods -n kafka-prod -o wide
NAME                                                             READY   STATUS    RESTARTS   AGE   IP            NODE       NOMINATED NODE   READINESS GATES
kafka-exporter-prod-prometheus-kafka-exporter-55d7d5d974-p6rd6   1/1     Running   0          15m   10.244.0.29   minikube   <none>           <none>
kafka-prod-controller-0                                          2/2     Running   0          17m   10.244.0.26   minikube   <none>           <none>
kafka-prod-controller-1                                          2/2     Running   0          17m   10.244.0.27   minikube   <none>           <none>
kafka-prod-controller-2                                          2/2     Running   0          17m   10.244.0.28   minikube   <none>           <none>
```

### 1.4 PostgreSQL Pods
```bash
# Command: kubectl get pods -n postgresql-prod -o wide
NAME                READY   STATUS    RESTARTS   AGE   IP            NODE       NOMINATED NODE   READINESS GATES
postgresql-prod-0   1/1     Running   0          17m   10.244.0.25   minikube   <none>           <none>
```

### 1.5 Monitoring Pods
```bash
# Command: kubectl get pods -n monitoring-prod -o wide
NAME                                                      READY   STATUS    RESTARTS   AGE     IP             NODE       NOMINATED NODE   READINESS GATES
prometheus-prod-alertmanager-0                            1/1     Running   0          2m45s   10.244.0.44    minikube   <none>           <none>
prometheus-prod-kube-state-metrics-54bc659449-m4nvl       1/1     Running   0          2m45s   10.244.0.42    minikube   <none>           <none>
prometheus-prod-prometheus-node-exporter-76dhr            1/1     Running   0          2m45s   192.168.49.2   minikube   <none>           <none>
prometheus-prod-prometheus-pushgateway-65d957b76f-n7h5t   1/1     Running   0          2m45s   10.244.0.43    minikube   <none>           <none>
prometheus-prod-server-d5bcdcbbf-4s6tm                    2/2     Running   0          2m45s   10.244.0.41    minikube   <none>           <none>
```

## 2. Application Logs

### 2.1 Producer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-prod deployment/event-producer --tail=10
INFO:__main__:Sent 820 events. Last event: {'event_type': 'user_signup', 'user_id': 4796, 'timestamp': '2025-10-07T11:25:20.224188Z'}
INFO:__main__:Sent 830 events. Last event: {'event_type': 'user_signup', 'user_id': 303, 'timestamp': '2025-10-07T11:25:30.397402Z'}
INFO:__main__:Sent 840 events. Last event: {'event_type': 'view', 'user_id': 248, 'timestamp': '2025-10-07T11:25:40.456573Z'}
INFO:__main__:Sent 850 events. Last event: {'event_type': 'purchase', 'user_id': 7295, 'timestamp': '2025-10-07T11:25:50.500479Z'}
INFO:__main__:Sent 860 events. Last event: {'event_type': 'click', 'user_id': 6019, 'timestamp': '2025-10-07T11:26:00.540660Z'}
INFO:__main__:Sent 870 events. Last event: {'event_type': 'user_signup', 'user_id': 3618, 'timestamp': '2025-10-07T11:26:10.587686Z'}
INFO:__main__:Sent 880 events. Last event: {'event_type': 'click', 'user_id': 7158, 'timestamp': '2025-10-07T11:26:20.624304Z'}
INFO:__main__:Sent 890 events. Last event: {'event_type': 'view', 'user_id': 8412, 'timestamp': '2025-10-07T11:26:30.666107Z'}
INFO:__main__:Sent 900 events. Last event: {'event_type': 'user_signup', 'user_id': 4978, 'timestamp': '2025-10-07T11:26:40.689042Z'}
INFO:__main__:Sent 910 events. Last event: {'event_type': 'purchase', 'user_id': 1051, 'timestamp': '2025-10-07T11:26:52.459857Z'}
```

### 2.2 Real-time Consumer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-prod deployment/stream-consumer --tail=10
2025-10-07 11:26:45,737 - INFO - Processed event: user_id=3027, type=purchase
2025-10-07 11:26:47,520 - INFO - Processed event: user_id=6086, type=purchase
2025-10-07 11:26:48,501 - INFO - Processed event: user_id=8754, type=view
2025-10-07 11:26:49,575 - INFO - Processed event: user_id=2127, type=view
2025-10-07 11:26:51,479 - INFO - Processed event: user_id=3128, type=click
2025-10-07 11:26:52,483 - INFO - Processed event: user_id=1051, type=purchase
2025-10-07 11:26:52,483 - INFO - Processed 910 events total
2025-10-07 11:26:53,677 - INFO - Processed event: user_id=3575, type=user_signup
2025-10-07 11:26:54,526 - INFO - Processed event: user_id=4631, type=click
2025-10-07 11:26:55,523 - INFO - Processed event: user_id=1172, type=purchase
```

### 2.3 Batch Consumer Logs (last 10 lines)
```bash
# Command: kubectl logs -n data-platform-prod deployment/batch-consumer --tail=10
2025-10-07 11:26:49,049 - INFO - Updated partition assignment: [TopicPartition(topic='domain-events', partition=0)]
2025-10-07 11:26:49,050 - INFO - Setting newly assigned partitions {TopicPartition(topic='domain-events', partition=0)} for group batch-consumer-group
2025-10-07 11:26:49,057 - INFO - <BrokerConnection node_id=0 host=kafka-prod-controller-0.kafka-prod-controller-headless.kafka-prod.svc.cluster.local:9092 <connecting> [IPv4 ('10.244.0.26', 9092)]>: connecting to kafka-prod-controller-0.kafka-prod-controller-headless.kafka-prod.svc.cluster.local:9092 [('10.244.0.26', 9092) IPv4]
2025-10-07 11:26:49,058 - INFO - <BrokerConnection node_id=0 host=kafka-prod-controller-0.kafka-prod-controller-headless.kafka-prod.svc.cluster.local:9092 <connecting> [IPv4 ('10.244.0.26', 9092)]>: Connection complete.
2025-10-07 11:26:49,823 - INFO - Batch processing completed: 298 events processed in 3.95 seconds
2025-10-07 11:26:49,882 - INFO - Stopping heartbeat thread
2025-10-07 11:26:49,884 - INFO - Leaving consumer group (batch-consumer-group).
2025-10-07 11:26:49,901 - INFO - <BrokerConnection node_id=coordinator-2 host=kafka-prod-controller-2.kafka-prod-controller-headless.kafka-prod.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.28', 9092)]>: Closing connection. 
2025-10-07 11:26:49,902 - INFO - <BrokerConnection node_id=1 host=kafka-prod-controller-1.kafka-prod-controller-headless.kafka-prod.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.27', 9092)]>: Closing connection. 
2025-10-07 11:26:49,902 - INFO - <BrokerConnection node_id=0 host=kafka-prod-controller-0.kafka-prod-controller-headless.kafka-prod.svc.cluster.local:9092 <connected> [IPv4 ('10.244.0.26', 9092)]>: Closing connection. 
```

## 4. Database Verification

### 4.1 Table Row Counts
```bash
# Command: SELECT 'Real-time events count:', COUNT(*) FROM events_realtime; SELECT 'Batch events count:', COUNT(*) FROM events_batch;
