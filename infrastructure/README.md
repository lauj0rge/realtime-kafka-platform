# Minikube Setup

To set up a local Minikube environment for Kafka and PostgreSQL, follow these steps:

1. **Install Minikube**: Ensure you have Minikube installed on your machine. You can follow the [official installation guide](https://minikube.sigs.k8s.io/docs/start/) for your operating system.
2. **Add Bitnami Helm Repository**: Add the Bitnami Helm repository to your local Helm client:
   ```bash
   helm repo add bitnami https://charts.bitnami.com/bitnami
   ```
3. **Set Environment Variables**: 
   ```bash
    export TF_VAR_postgres_password="postgres"
   ```
4. **Apply Terraform Configuration**: Use the provided `minikube_kafka_setup.tf` file to set up Kafka and PostgreSQL in your Minikube cluster:
   ```bash
    terraform -chdir=minikube init
    terraform -chdir=minikube plan -var-file="env/dev.tfvars"
    terraform -chdir=minikube apply -var-file="env/dev.tfvars" -auto-approve
   ```

5. **Clean up**:
   ```bash
    terraform -chdir=minikube destroy -var-file="env/dev.tfvars" -auto-approve
   ```
