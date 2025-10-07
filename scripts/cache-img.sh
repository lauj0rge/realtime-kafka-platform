#!/usr/bin/env bash
set -euo pipefail

echo "📦 Starting Minikube image caching..."

if ! minikube status >/dev/null 2>&1; then
  echo "🚀 Starting Minikube..."
  minikube start --driver=docker --memory=4096 --cpus=2
fi

eval "$(minikube docker-env)"

IMAGES=(
  # PostgreSQL
  "docker.io/bitnami/postgresql:latest"

  # Prometheus components
  "quay.io/prometheus/prometheus:v2.50.1"
  "quay.io/prometheus/alertmanager:v0.27.0"
  "quay.io/prometheus/pushgateway:v1.7.0"
  "quay.io/prometheus/node-exporter:v1.7.0"
  "registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.10.1"
  "quay.io/prometheus-operator/prometheus-config-reloader:v0.71.2"

  # Kafka
  "docker.io/bitnamilegacy/kafka:3.7.0-debian-12-r4"
  "docker.io/bitnamilegacy/zookeeper:3.9.2-debian-12-r4"
  "danielqsj/kafka-exporter:v1.7.0"
  "docker.io/bitnamilegacy/jmx-exporter:1.2.0-debian-12-r1"
)

for IMAGE in "${IMAGES[@]}"; do
  echo "🧩 Caching image: $IMAGE"
  if ! minikube cache add "$IMAGE" >/dev/null 2>&1; then
    echo "⚠️  Warning: Failed to cache $IMAGE — skipping."
  fi
done

echo "✅ Cached images in Minikube:"
minikube cache list
