#!/usr/bin/env bash
set -euo pipefail

ENV=${1:-dev} # usage: ./clean-up.sh dev | prod
ROOT_DIR=~/LauraJorge/infrastructure  # ← Updated path
TFVARS_FILE="${ROOT_DIR}/env/${ENV}.tfvars"
NAMESPACES=("kafka-${ENV}" "postgresql-${ENV}" "monitoring-${ENV}" "data-platform-${ENV}")  # ← Updated namespaces

echo "💣🔥 Initiating TOTAL CLEANUP for environment: ${ENV}"

# 1. Terraform destroy
if [ -d "$ROOT_DIR" ]; then
  echo "🧾 Destroying Terraform-managed infrastructure with vars: ${TFVARS_FILE}"
  terraform -chdir="$ROOT_DIR" destroy -var-file="$TFVARS_FILE" -auto-approve || true
else
  echo "⚠️ Terraform directory not found at $ROOT_DIR — skipping."
fi

# 2. Delete all Helm releases in all namespaces
echo "🧹 Removing ALL Helm releases..."
helm list --all-namespaces -q | while read -r release; do
  ns=$(helm status "$release" -o json 2>/dev/null | jq -r .namespace || echo "default")
  echo "  🗑️  Uninstalling $release from namespace $ns"
  helm uninstall "$release" -n "$ns" || true
done

# 3. Delete Strimzi CRDs (Kafka)
echo "🧯 Removing Strimzi CRDs..."
kubectl get crds 2>/dev/null | grep strimzi.io | awk '{print $1}' | while read -r crd; do
  echo "  ❌ Deleting CRD: $crd"
  kubectl delete crd "$crd" --ignore-not-found
done

# 4. Delete key namespaces
echo "🧨 Deleting project namespaces..."
for ns in "${NAMESPACES[@]}"; do
  echo "  🧹 Namespace: $ns"
  kubectl delete ns "$ns" --ignore-not-found --wait=false
done

# 5. Wait for namespace deletion
echo "⏳ Waiting for namespaces to fully terminate..."
for ns in "${NAMESPACES[@]}"; do
  while kubectl get ns "$ns" >/dev/null 2>&1; do
    echo "  ...waiting for $ns to terminate..."
    sleep 5
  done
done

# 6. Clean up any leftover Kubernetes resources
echo "🧽 Cleaning dangling resources..."
kubectl delete all --all -A --ignore-not-found --wait=false || true

# 7. Remove Docker images from Minikube cache
echo "🗑️  Removing images from Minikube cache..."
minikube cache delete producer:${ENV} || true
minikube cache delete realtime-consumer:${ENV} || true
minikube cache delete batch-consumer:${ENV} || true

# 8. Optional: Reset Minikube (uncomment if needed)
# echo "🚮 Resetting Minikube..."
# minikube stop || true
# minikube delete || true
# minikube start --driver=docker --memory=4096 --cpus=2

# 9. Verify cleanup
echo "✅ Cluster fully reset for environment: ${ENV}"
echo "=== Final namespace status ==="
kubectl get ns
echo "=== Final pod status ==="
kubectl get pods -A