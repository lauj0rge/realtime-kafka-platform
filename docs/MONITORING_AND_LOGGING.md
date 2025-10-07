# 📊 Monitoring & Logging Guide

## 🧠 Overview

This platform uses **Prometheus** for metrics collection and **kubectl logs** for centralized log observation.
Both work together:

* **Logs** show *what happened* (context & errors).
* **Metrics** show *how the system behaves* over time.

Prometheus provides **time-series data** for Kafka, PostgreSQL, Python apps, and Kubernetes.
It pulls data from exporters running as sidecars or services inside the cluster.

---

## ⚙️ Prometheus Stack Components

| Component               | Image                                                            | Purpose                                |
| ----------------------- | ---------------------------------------------------------------- | -------------------------------------- |
| **Prometheus Server**   | `quay.io/prometheus/prometheus:v2.50.1`                          | Core metrics storage & query engine    |
| **Alertmanager**        | `quay.io/prometheus/alertmanager:v0.27.0`                        | Handles alert notifications            |
| **Pushgateway**         | `quay.io/prometheus/pushgateway:v1.7.0`                          | Receives ad-hoc push metrics           |
| **Node Exporter**       | `quay.io/prometheus/node-exporter:v1.7.0`                        | Collects node-level CPU/memory metrics |
| **Kafka Exporter**      | `danielqsj/kafka-exporter:v1.7.0`                                | Tracks consumer lag & broker metrics   |
| **JMX Exporter**        | `docker.io/bitnamilegacy/jmx-exporter:1.2.0-debian-12-r1`        | Scrapes Kafka JMX stats                |
| **PostgreSQL Exporter** | included in Bitnami image                                        | Database-level metrics                 |
| **Kube State Metrics**  | `registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.10.1`  | Kubernetes object metrics              |
| **Config Reloader**     | `quay.io/prometheus-operator/prometheus-config-reloader:v0.71.2` | Reloads Prometheus config when updated |

---

## 🔭 Access Prometheus Dashboard

Forward Prometheus to your local machine:

```bash

kubectl port-forward -n monitoring-dev svc/prometheus-dev-server 9090:80
```

Open [http://localhost:9090](http://localhost:9090)

To confirm Prometheus targets:

```bash
# Show all registered scrape targets
kubectl exec -n monitoring-dev deploy/prometheus-dev-server -- wget -qO- localhost:9090/api/v1/targets | jq '.data.activeTargets[].labels.job'
```

---

## 🧩 Exporter Endpoints and Ports

| Exporter                             | Port   | Path       | Example Query                        |
| ------------------------------------ | ------ | ---------- | ------------------------------------ |
| **Kafka JMX Exporter**               | `5556` | `/metrics` | `curl http://<pod-ip>:5556/metrics`  |
| **Kafka Exporter**                   | `9308` | `/metrics` | `curl http://<pod-ip>:9308/metrics`  |
| **PostgreSQL Exporter**              | `9187` | `/metrics` | `curl http://<pod-ip>:9187/metrics`  |
| **Python Apps (Producer/Consumers)** | `8000` | `/metrics` | `curl http://<pod-ip>:8000/metrics`  |
| **Node Exporter**                    | `9100` | `/metrics` | `curl http://<node-ip>:9100/metrics` |

---

## 📈 CLI Metric Queries

To query Prometheus directly:

```bash

kubectl exec -it -n monitoring-dev deploy/prometheus-dev-server -- /bin/sh
# inside the container
promtool query instant http://localhost:9090 'up'
promtool query range http://localhost:9090 'rate(kafka_consumergroup_lag[5m])' --start=2025-10-07T00:00:00Z --end=2025-10-07T01:00:00Z --step=60s
```

---

## 📊 Key Metrics to Monitor 

### Kafka 

| Metric                                                    | Description                  | PromQL Example                                                      |
| --------------------------------------------------------- | ---------------------------- | ------------------------------------------------------------------- |
| `kafka_server_BrokerTopicMetrics_MessagesInPerSec_count`  | Messages produced per second | `rate(kafka_server_BrokerTopicMetrics_MessagesInPerSec_count[1m])`  |
| `kafka_server_BrokerTopicMetrics_BytesInPerSec_count`     | Incoming bytes               | `rate(kafka_server_BrokerTopicMetrics_BytesInPerSec_count[1m])`     |
| `kafka_server_BrokerTopicMetrics_BytesOutPerSec_count`    | Outgoing bytes               | `rate(kafka_server_BrokerTopicMetrics_BytesOutPerSec_count[1m])`    |
| `kafka_controller_KafkaController_ActiveControllerCount`  | Number of active controllers | `max(kafka_controller_KafkaController_ActiveControllerCount)`       |
| `kafka_server_ReplicaManager_UnderReplicatedPartitions`   | Unreplicated partitions      | `max(kafka_server_ReplicaManager_UnderReplicatedPartitions)`        |
| `kafka_consumergroup_current_offset`                      | Current offset per group     | `kafka_consumergroup_current_offset{group="batch-consumer"}`        |
| `kafka_consumergroup_lag`                                 | Lag per consumer group       | `kafka_consumergroup_lag{group="stream-consumer"}`                  |
| `kafka_topic_partitions`                                  | Partition count per topic    | `kafka_topic_partitions{topic="events"}`                            |
| `kafka_broker_info`                                       | Broker metadata              | `kafka_broker_info`                                                 |
| `kafka_network_RequestMetrics_FailedRequestsPerSec_count` | Request failures             | `rate(kafka_network_RequestMetrics_FailedRequestsPerSec_count[1m])` |

### PostgreSQL (pg_exporter)

| Metric                           | Description              | PromQL Example                               |
| -------------------------------- | ------------------------ | -------------------------------------------- |
| `pg_up`                          | Database up status       | `pg_up`                                      |
| `pg_stat_activity_count`         | Active DB connections    | `pg_stat_activity_count`                     |
| `pg_database_size_bytes`         | Database size            | `pg_database_size_bytes{datname="postgres"}` |
| `pg_xact_commit`                 | Transactions committed   | `rate(pg_xact_commit[1m])`                   |
| `pg_xact_rollback`               | Transactions rolled back | `rate(pg_xact_rollback[1m])`                 |
| `pg_stat_user_tables_n_dead_tup` | Dead tuples              | `pg_stat_user_tables_n_dead_tup`             |
| `pg_locks_count`                 | DB locks count           | `pg_locks_count`                             |

### Python Apps 

| Metric                              | Description                     | PromQL Example                                                                       |
| ----------------------------------- | ------------------------------- | ------------------------------------------------------------------------------------ |
| `events_generated_total`            | Events produced                 | `increase(events_generated_total[5m])`                                               |
| `events_processed_total`            | Events consumed                 | `increase(events_processed_total[5m])`                                               |
| `processing_latency_seconds_bucket` | Processing latency distribution | `histogram_quantile(0.95, sum(rate(processing_latency_seconds_bucket[5m])) by (le))` |
| `events_failed_total`               | Failed events                   | `increase(events_failed_total[5m])`                                                  |
| `app_uptime_seconds`                | Uptime gauge                    | `app_uptime_seconds`                                                                 |

### Kubernetes (kube-state-metrics + node-exporter)

| Metric                                          | Description      | PromQL Example                                                 |
| ----------------------------------------------- | ---------------- | -------------------------------------------------------------- |
| `container_cpu_usage_seconds_total`             | CPU usage        | `rate(container_cpu_usage_seconds_total[1m])`                  |
| `container_memory_usage_bytes`                  | Memory usage     | `container_memory_usage_bytes`                                 |
| `kube_pod_container_status_restarts_total`      | Pod restarts     | `increase(kube_pod_container_status_restarts_total[10m])`      |
| `kube_deployment_status_replicas_unavailable`   | Missing replicas | `sum(kube_deployment_status_replicas_unavailable)`             |
| `kube_node_status_condition{condition="Ready"}` | Node readiness   | `max by (node)(kube_node_status_condition{condition="Ready"})` |

---

## 🧾 Example Prometheus Queries from CLI

To run queries directly inside Prometheus pod:

```bash
kubectl exec -it -n monitoring-dev deploy/prometheus-dev-server -- /bin/sh
# Examples:
promtool query instant http://localhost:9090 'pg_up'
promtool query instant http://localhost:9090 'max(kafka_consumergroup_lag)'
promtool query instant http://localhost:9090 'sum(rate(events_processed_total[1m]))'
promtool query instant http://localhost:9090 'kube_pod_container_status_restarts_total'
```

---

# 🪵 Logging & Cluster Diagnostics

Logs show the *narrative* of what’s happening in your cluster — useful for debugging failures, verifying deployments, and correlating with metrics.

---

## 1️⃣ View All Running Pods and Namespaces

```bash

kubectl get pods -A
kubectl get deployments -A
kubectl get services -A
kubectl get nodes -o wide
```

If something looks unhealthy:

```bash

kubectl describe pod <pod-name> -n <namespace>
kubectl describe deployment <deployment-name> -n <namespace>
```

---

## 2️⃣ View Logs for a Single Pod

Basic log retrieval:

```bash

kubectl logs -n <namespace> <pod-name>
```

To stream live logs (tail mode):

```bash

kubectl logs -f -n <namespace> <pod-name>
```

To view logs from a specific container inside a pod:

```bash

kubectl logs -n <namespace> <pod-name> -c <container-name>
```

To view logs from a *previous crash*:

```bash

kubectl logs -n <namespace> <pod-name> --previous
```

---

## 3️⃣ Retrieve Logs by Label or Deployment

By label:

```bash

kubectl logs -n data-platform-dev -l app=producer
kubectl logs -n data-platform-dev -l app=batch-consumer
```

From an entire deployment:

```bash

kubectl logs -n data-platform-dev deploy/stream-consumer-dev
```

From all pods matching a pattern:

```bash

kubectl logs -n data-platform-dev $(kubectl get pods -n data-platform-dev -l app=producer -o name)
```

---

## 4️⃣ Filter and Search Logs 

Find all error lines:

```bash

kubectl logs -n data-platform-dev -l app=batch-consumer | grep -i "error"
```

Filter for failures, exceptions, or connection issues:

```bash

kubectl logs -n data-platform-dev -l app=stream-consumer | egrep -i "fail|exception|timeout|refused|traceback"
```

Limit log size and tail last lines:

```bash

kubectl logs -n data-platform-dev <pod-name> --tail=100
```

Search only timestamp range:

```bash

kubectl logs -n data-platform-dev <pod-name> | awk '/2025-10-07T12:00/,/2025-10-07T13:00/'
```

---

## 5️⃣ Stream Logs for All Pods in a Namespace

For dynamic debugging:

```bash

kubectl get pods -n data-platform-dev -o name | xargs -I {} kubectl logs -f -n data-platform-dev {}
```

Stream logs from all namespaces (noisy, use carefully):

```bash

kubectl logs -f -l app --all-namespaces
```

---

## 6️⃣ Aggregate Logs from the Entire Cluster

Show last 20 lines of every container in a namespace:

```bash

for pod in $(kubectl get pods -n data-platform-dev -o name); do
  echo "--- Logs for $pod ---"
  kubectl logs -n data-platform-dev $pod --tail=20
done
```

Export logs to file for offline analysis:

```bash

kubectl logs -n monitoring-dev deploy/prometheus-dev-server > prometheus.log
kubectl logs -n data-platform-dev deploy/stream-consumer-dev > stream-consumer.log
```

---

## 7️⃣ Node-Level and System Logs

Inspect node components:

```bash

kubectl get nodes -o wide
kubectl describe node <node-name>
```

Fetch Docker or container runtime logs:

```bash
journalctl -u docker.service -n 100
```

On Minikube:

```bash

minikube logs --follow
```

---

## 8️⃣ Logs for Monitoring Components

Prometheus and Exporters:

```bash
kubectl logs -n monitoring-dev deploy/prometheus-dev-server
kubectl logs -n monitoring-dev deploy/kafka-exporter
kubectl logs -n monitoring-dev deploy/node-exporter
kubectl logs -n monitoring-dev deploy/postgres-exporter
```

Check for failed targets or configuration reloads:

```bash

kubectl logs -n monitoring-dev deploy/prometheus-dev-server | grep -i "error"
kubectl logs -n monitoring-dev deploy/prometheus-dev-server | grep "Reloaded configuration"
```

---

## 9️⃣ Typical Error Patterns to Watch

| Symptom                                | Likely Cause                 | Action                                   |             |
| -------------------------------------- | ---------------------------- | ---------------------------------------- | ----------- |
| `CrashLoopBackOff`                     | App crash or bad env vars    | `kubectl describe pod`, check logs       |             |
| `ErrImagePull`                         | Invalid image or auth issue  | `kubectl get events -A                   | grep Image` |
| `Connection refused`                   | Service port mismatch        | Check `kubectl describe svc`             |             |
| `Back-off restarting failed container` | Fatal exception loop         | `kubectl logs --previous`                |             |
| `Timeout` / `Broken pipe`              | Network issue or pod unready | `kubectl get endpoints`                  |             |
| `permission denied`                    | Missing RBAC permissions     | Inspect `RoleBinding` / `ServiceAccount` |             |

---

## 🔁 Combined Logs and Metrics Workflow

1. **Check pod status**

   ```bash
   
   kubectl get pods -A | grep -v Running
   ```

2. **Inspect logs for errors**

   ```bash
   
   kubectl logs -n data-platform-dev -l app=batch-consumer | grep -i error
   ```

3. **Cross-check metrics**

   ```bash
   
   kubectl exec -it -n monitoring-dev deploy/prometheus-dev-server -- promtool query instant http://localhost:9090 'kafka_consumergroup_lag'
   ```

---
