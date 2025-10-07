Here is a full, production-style **`TROUBLESHOOTING.md`** for your repository.
It complements your Prometheus and Logging guides — concise, operational, and command-driven.

---

# 🧰 Troubleshooting Guide

This document lists common failure scenarios across **Minikube**, **Terraform**, **Kubernetes**, **Kafka**, **PostgreSQL**, and **Prometheus**, plus commands to isolate and fix them.

---

## 🧩 General Diagnostics

### Check Cluster Status

```bash
kubectl cluster-info
kubectl get nodes -o wide
kubectl get pods -A --sort-by=.metadata.namespace
kubectl get events -A --sort-by=.lastTimestamp | tail -20
```

### Describe and Inspect

```bash
kubectl describe pod <pod-name> -n <namespace>
kubectl describe svc <service-name> -n <namespace>
kubectl describe deployment <deployment-name> -n <namespace>
```

### Common Quick Fixes

```bash
kubectl rollout restart deployment <name> -n <namespace>
kubectl delete pod <pod-name> -n <namespace>
kubectl delete pod --field-selector=status.phase=Failed -A
```

---

## ⚙️ Terraform Issues

| Problem          | Symptom                          | Resolution                                                    |
| ---------------- | -------------------------------- | ------------------------------------------------------------- |
| Stale state      | Error: “Resource already exists” | Run `terraform refresh` or `terraform state rm <resource>`    |
| Missing provider | Init fails                       | `terraform init -upgrade`                                     |
| Wrong workspace  | Resources deployed to wrong env  | `terraform workspace list` / `terraform workspace select dev` |
| Auth error       | AWS/Azure creds missing          | Check `~/.aws/credentials` or env vars                        |

---

## 🐳 Minikube & Cluster Startup

| Problem                  | Symptom                           | Command / Fix                                                              |
| ------------------------ | --------------------------------- | -------------------------------------------------------------------------- |
| Minikube fails to start  | “Host only network not found”     | `minikube delete && minikube start --driver=docker --memory=4096 --cpus=2` |
| No internet / DNS errors | Pods stuck in `ImagePullBackOff`  | `minikube ssh -- ping -c3 google.com` → if fails, restart Docker daemon    |
| Cluster not reachable    | “Unable to connect to the server” | `kubectl config use-context minikube`                                      |

---

## 🧱 Kubernetes Deployment Failures

### 1️⃣ Pod Pending

```bash
kubectl describe pod <pod> -n <ns> | grep -A5 Events
```

Likely cause: missing resources.
Fix: increase node memory or reduce pod resource limits.

### 2️⃣ Image Pull Errors

```bash
kubectl get events -A | grep -i image
```

Verify repository or credentials.
If using private images, create and apply a Docker secret:

```bash

kubectl create secret docker-registry regcred --docker-username=<user> --docker-password=<pass> --docker-server=<server>
```

### 3️⃣ CrashLoopBackOff

```bash
kubectl logs <pod> -n <ns> --previous
```

Check for:

* Wrong environment variables
* Connection timeouts
* Invalid DB credentials

Restart after fix:

```bash
kubectl rollout restart deployment <deployment> -n <ns>
```

---

## 🧮 Kafka Issues

### 1️⃣ Kafka Broker Not Ready

```bash
kubectl get pods -n kafka-dev
kubectl logs -n kafka-dev -l app.kubernetes.io/component=kafka
```

Look for `Connection refused` or `Zookeeper` errors.

If zookeeper unavailable:

```bash
kubectl get pods -n kafka-dev -l app.kubernetes.io/component=zookeeper
kubectl rollout restart statefulset zookeeper
```

### 2️⃣ Consumer Lag Increasing

```bash
kubectl exec -it -n monitoring-dev deploy/prometheus-dev-server -- promtool query instant http://localhost:9090 'kafka_consumergroup_lag'
```

If lag high:

* Restart consumer
* Scale replicas:

  ```bash
  kubectl scale deployment/stream-consumer --replicas=3 -n data-platform-dev
  ```
* Check for DB latency or full partition

### 3️⃣ Kafka Exporter Down

```bash
kubectl get pods -n monitoring-dev -l app=kafka-exporter
kubectl logs -n monitoring-dev deploy/kafka-exporter | grep -i error
kubectl rollout restart deploy/kafka-exporter -n monitoring-dev
```

---

## 🐘 PostgreSQL Issues

### 1️⃣ Database Unreachable

```bash
kubectl exec -it -n postgresql-dev postgresql-dev-0 -- psql -U postgres -c '\l'
```

If fails → check service endpoint:

```bash
kubectl get svc -n postgresql-dev
```

Restart pod if unresponsive:

```bash
kubectl delete pod -n postgresql-dev postgresql-dev-0
```

### 2️⃣ Connection Refused from Consumers

Verify env vars inside consumer pod:

```bash
kubectl exec -it -n data-platform-dev <consumer-pod> -- printenv | grep POSTGRES
```

If wrong → update Helm values or Terraform vars and redeploy.

---

## 📡 Prometheus & Monitoring Problems

### 1️⃣ Prometheus UI Inaccessible

```bash
kubectl port-forward -n monitoring-dev svc/prometheus-dev-server 9090:80
```

If fails → service not mapped:

```bash
kubectl get svc -n monitoring-dev
kubectl describe svc prometheus-dev-server -n monitoring-dev
```

### 2️⃣ Targets Missing or Down

Open [http://localhost:9090/targets](http://localhost:9090/targets)
If exporter shows *DOWN*:

* Confirm annotations or ServiceMonitor present:

  ```bash
  kubectl get svc -A | grep metrics
  kubectl get servicemonitor -A
  ```
* Restart exporter:

  ```bash
  kubectl rollout restart deploy/kafka-exporter -n monitoring-dev
  ```

### 3️⃣ Query Test

```bash
kubectl exec -it -n monitoring-dev deploy/prometheus-dev-server -- promtool query instant http://localhost:9090 'up'
kubectl exec -it -n monitoring-dev deploy/prometheus-dev-server -- promtool query instant http://localhost:9090 'kafka_consumergroup_lag'
```

---

## 🧾 Application-Level Failures

| Symptom                        | Cause                         | Resolution                                                                                          |
| ------------------------------ | ----------------------------- | --------------------------------------------------------------------------------------------------- |
| Producer not generating events | Python error or network issue | `kubectl logs -l app=producer -n data-platform-dev`                                                 |
| Batch consumer not processing  | Scheduler not triggered       | Check APScheduler logs                                                                              |
| Events not written to DB       | Bad connection string         | Verify host and port in environment vars                                                            |
| Consumers exit silently        | Missing Kafka topic           | `kubectl exec -it -n kafka-dev kafka-0 -- kafka-topics.sh --list --bootstrap-server localhost:9092` |

---

## 🌐 Networking & DNS

Test connectivity between pods:

```bash
kubectl exec -it -n data-platform-dev <pod> -- ping kafka-dev
kubectl exec -it -n data-platform-dev <pod> -- nc -zv postgresql-dev 5432
```

Describe CoreDNS if names not resolving:

```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl logs -n kube-system -l k8s-app=kube-dns | grep error
```

---

## 🪵 Logging Review Checklist

1. Confirm pod logs exist:
   `kubectl logs -n data-platform-dev <pod>`
2. Search for errors:
   `kubectl logs -n data-platform-dev <pod> | grep -i error`
3. Inspect events:
   `kubectl get events -A --sort-by=.metadata.creationTimestamp`
4. If container restarts repeatedly:
   `kubectl logs --previous -n <ns> <pod>`

---

## 🔄 Clean Up & Recovery

When cluster state becomes inconsistent:

```bash
kubectl delete all --all -n data-platform-dev
kubectl delete pvc --all -n postgresql-dev
kubectl delete pods --field-selector=status.phase=Failed -A
```

Recreate infrastructure:

```bash
make destroy && make deploy
```

Reset Minikube completely:

```bash
minikube delete && minikube start --driver=docker
```

---

## ✅ Post-Fix Verification

* All pods in `Running` state:

  ```bash
  kubectl get pods -A | grep -v Running
  ```
* Kafka lag stable:

  ```bash
  promtool query instant http://localhost:9090 'max(kafka_consumergroup_lag)'
  ```
* PostgreSQL accessible:

  ```bash
  kubectl exec -it -n postgresql-dev postgresql-dev-0 -- psql -U postgres -c 'SELECT COUNT(*) FROM events_realtime;'
  ```
* Producer still generating events:

  ```bash
  kubectl logs -n data-platform-dev -l app=producer | tail -10
  ```

---

## 🧠 Summary

* **Start broad → narrow down:** cluster → pod → container → logs → metrics
* **Always cross-verify:** log timestamp with Prometheus metric spikes
* **Automate recoveries:** use `make destroy` / `make deploy` when cluster becomes inconsistent
* **Validate stability:** ensure consumer lag near zero and no pod restarts

---

Would you like me to add an optional **“incident response checklist”** at the end (step-by-step actions to diagnose and restore the system when it’s fully broken)?
