# 🧪 PostgreSQL Validation Guide

## 🧠 Purpose

This guide verifies that PostgreSQL is healthy, reachable, and correctly populated by your Kafka consumers.
It checks:

* Database connectivity
* Schema integrity
* Data ingestion from real-time and batch consumers
* Performance and exporter metrics

---

## ⚙️ Access PostgreSQL Pod

List database pods:

```bash

kubectl get pods -n postgresql-dev
```

Connect to the primary instance:

```bash

kubectl exec -it -n postgresql-dev postgresql-dev-0 -- psql -U postgres
```

---

## ✅ Connection & Cluster Info

```sql
-- Verify connection
\conninfo

-- List databases
\l

-- List users and roles
\du

-- Show current time, version, and uptime
SELECT NOW(), VERSION();
```

---

## 🧱 Schema Validation

Confirm the tables created by both consumers:

```sql
\c postgres
\dt

-- Should list:
-- events_realtime
-- events_batch
```

Check columns:

```sql
\d+ events_realtime
\d+ events_batch
```

---

## 📊 Data Validation

### Count of records per table

```sql
SELECT 'Real-time events:' AS table, COUNT(*) FROM events_realtime
UNION ALL
SELECT 'Batch events:', COUNT(*) FROM events_batch;
```

### Sample recent events

```sql
SELECT * FROM events_realtime ORDER BY timestamp DESC LIMIT 10;
SELECT * FROM events_batch ORDER BY timestamp DESC LIMIT 10;
```

### Ensure event freshness

```sql
SELECT MAX(timestamp) AS latest_event, NOW() - MAX(timestamp) AS delay
FROM events_realtime;
```

---

## 🩺 Health & Performance Checks

### Database size and connections

```sql
SELECT pg_size_pretty(pg_database_size('postgres')) AS db_size;
SELECT COUNT(*) AS active_connections FROM pg_stat_activity;
```

### Transaction metrics

```sql
SELECT SUM(xact_commit) AS commits, SUM(xact_rollback) AS rollbacks
FROM pg_stat_database;
```

### Locks and potential contention

```sql
SELECT locktype, relation::regclass, mode, COUNT(*)
FROM pg_locks
WHERE NOT granted
GROUP BY locktype, relation, mode;
```

---

## 🔍 Metrics Validation (Exporter)

Verify Prometheus is scraping the PostgreSQL exporter:

```bash
kubectl get svc -n postgresql-dev
kubectl get servicemonitors -A | grep postgres
```

Query the metric directly:

```bash
kubectl exec -it -n monitoring-dev deploy/prometheus-dev-server -c prometheus-server -- /bin/sh
# inside container:
promtool query instant http://localhost:9090 'pg_up'
promtool query instant http://localhost:9090 'pg_stat_activity_count'
```

---

## 🧰 Troubleshooting

| Symptom                             | Possible Cause                   | Command                                                                  |                |
| ----------------------------------- | -------------------------------- | ------------------------------------------------------------------------ | -------------- |
| `psql: could not connect to server` | Service not exposed or pod crash | `kubectl describe pod -n postgresql-dev postgresql-dev-0`                |                |
| Table missing                       | Consumer not writing             | `kubectl logs -n data-platform-dev -l app=batch-consumer`                |                |
| Empty tables                        | Kafka topic empty or lagging     | `promtool query instant http://localhost:9090 'kafka_consumergroup_lag'` |                |
| DB exporter missing in Prometheus   | ServiceMonitor not found         | `kubectl get servicemonitor -A                                           | grep postgres` |

---

## 🧾 Full Validation Script

To automate checks:

```bash
kubectl exec -it -n postgresql-dev postgresql-dev-0 -- bash -c '
psql -U postgres -d postgres -c "
SELECT NOW();
SELECT COUNT(*) AS realtime FROM events_realtime;
SELECT COUNT(*) AS batch FROM events_batch;
SELECT MAX(timestamp) AS latest_realtime FROM events_realtime;
SELECT pg_size_pretty(pg_database_size('\''postgres'\'')) AS db_size;
"
'
```

---

## ✅ Expected Results

| Check                     | Expected                                |
| ------------------------- | --------------------------------------- |
| Connection                | Successful                              |
| Tables                    | `events_realtime`, `events_batch` exist |
| Data                      | Both contain records                    |
| Delay                     | Under 5 min for real-time               |
| Prometheus Metric `pg_up` | Returns `1`                             |

---

Would you like me to also add a short **Bash test script** (`scripts/test-postgres.sh`) that runs these same checks automatically via `kubectl` and outputs a report?
