# ⚡ Real-time Event Processing Platform

[![Terraform](https://img.shields.io/badge/Terraform-1.8+-7B42BC?logo=terraform\&logoColor=white)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28+-326CE5?logo=kubernetes\&logoColor=white)](https://kubernetes.io/)
[![Helm](https://img.shields.io/badge/Helm-v3-0F1689?logo=helm\&logoColor=white)](https://helm.sh/)
[![Kafka](https://img.shields.io/badge/Apache-Kafka-231F20?logo=apachekafka\&logoColor=white)](https://kafka.apache.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16+-4169E1?logo=postgresql\&logoColor=white)](https://www.postgresql.org/)
[![Prometheus](https://img.shields.io/badge/Prometheus-Monitoring-E6522C?logo=prometheus\&logoColor=white)](https://prometheus.io/)
[![Real-time](https://img.shields.io/badge/⚡-Streaming-00B0F0)]()
[![Batch](https://img.shields.io/badge/📊-Processing-FF6B35)]()

---

## 🚀 Overview

A production-grade **event streaming platform** built with **Infrastructure as Code** and **Kubernetes-native components**.
It demonstrates **dual consumption patterns** for event-driven systems: *real-time* and *batch* processing — fully automated via Terraform.

**Core Concept:**
Events flow through Kafka and are consumed in two modes:

* **Real-time consumer:** processes messages instantly for immediate persistence
* **Batch consumer:** aggregates events every 5 minutes for analytical workloads

All resources — from Kafka to PostgreSQL — are provisioned declaratively using Terraform and deployed on Minikube.

---

## 🧩 Architecture

```
                         ┌──────────────────────────────┐
                         │          Producer            │
                         │  (1 event/sec)               │
                         └────────────┬─────────────────┘
                                      │
                                      ▼
                             ┌────────────────┐
                             │   Kafka Topic  │
                             └──────┬─────────┘
                                    │
             ┌──────────────────────┴───────────────────────┐
             ▼                                              ▼
  ┌─────────────────────┐                        ┌─────────────────────┐
  │ Real-time Consumer  │                        │ Batch Consumer      │
  │ (sub-second latency)│                        │ (5-min intervals)   │
  └──────────┬──────────┘                        └──────────┬──────────┘
             ▼                                              ▼
 ┌────────────────────────┐                    ┌────────────────────────┐
 │ events_realtime table  │                    │ events_batch table     │
 └────────────────────────┘                    └────────────────────────┘
```

| Layer          | Tool             | Role                                       |
| -------------- | ---------------- | ------------------------------------------ |
| Infrastructure | Terraform + Helm | Provisioning and environment orchestration |
| Messaging      | Apache Kafka     | Reliable event transport                   |
| Processing     | Python apps      | Real-time and batch consumers              |
| Storage        | PostgreSQL       | Durable event store                        |
| Monitoring     | Prometheus       | Metrics, alerts, and system health         |

---

## 🧱 Design & Scalability

The platform is structured for **clarity, modularity, and reproducibility**.

Each Terraform module has a single responsibility:

* `apps/` deploys producers and consumers.
* `kafka_cluster/` defines brokers and Zookeeper.
* `postgres/` manages persistence and metrics exporters.
* `monitoring/` provisions Prometheus and node exporters.

Environments are isolated through `.tfvars` files (`dev.tfvars`, `prod.tfvars`).
Adding a new environment only requires a new variable file — Terraform handles namespacing and configuration automatically.

This design enables consistent deployments, independent scaling of components, and parity between development and production setups.

---

## ⚙️ Automation

A **GitHub Actions** pipeline (`.github/workflows/cicd.yml`) automates:

* Terraform validation and apply
* Docker image build and cache
* Helm deployment
* Automated smoke testing

Each commit triggers a clean, reproducible build of the entire platform.

---

## 🧰 Run & Operate

### Deploy

```bash

minikube start --driver=docker --memory=4096 --cpus=2
export TF_VAR_postgres_password="postgres"
make deploy-and-test
```

### Validate

```bash

make status-all
make view-tests
```

### Monitor

```bash

kubectl port-forward -n monitoring-dev svc/prometheus-dev-server 9090:80
```
- On a browser open http://localhost:9090
### Query Data

```bash

kubectl exec -it -n postgresql-dev postgresql-dev-0 -- psql -U postgres -c "
SELECT COUNT(*) FROM events_realtime;
SELECT COUNT(*) FROM events_batch;"
```

---

## 🧩 Documentation

Supporting guides are available under `/docs`:

* **[Monitoring & Logging](docs/MONITORING_AND_LOGGING.md)** – metrics, exporters, PromQL queries, and log collection
* **[Troubleshooting](docs/TROUBLESHOOTING.md)** – command-based recovery steps for Terraform, Kafka, PostgreSQL, and Prometheus

Together, they describe how to monitor, debug, and recover every part of the platform.

---

## 🗂️ Repository Structure

```
src/            # Application logic (producer, consumers)
infrastructure/ # Terraform + Helm modules
scripts/        # Helper and test scripts
docs/           # Monitoring and troubleshooting guides
tests/          # Test reports
.github/        # CI/CD pipeline
```

---

## ✅ Highlights

* Fully declarative and modular architecture
* Environment-aware through simple `.tfvars` configuration
* Automated CI/CD pipeline with GitHub Actions
* Observability integrated from the start
* Real-time + batch data processing in one reproducible stack

---

