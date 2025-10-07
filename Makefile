# Makefile
ENV ?= dev
TERRAFORM_DIR = infrastructure
TF_VARS_FILE = env/$(ENV).tfvars
SCRIPTS_DIR = scripts
WAIT_TIME ?= 120  # Wait 2 minutes for system to stabilize
TEST_TIMEOUT ?= 600  # 10 minutes for batch processing tests

.PHONY: build build-producer build-consumers cache deploy destroy clean logs status test test-quick test-full view-tests wait-for-system deploy-and-test all

# Build targets
build: build-producer build-consumers

build-producer:
	@echo "Building producer image for $(ENV)..."
	docker build -t producer:$(ENV) src/producer/

build-realtime-consumer:
	@echo "Building realtime consumer image for $(ENV)..."
	docker build -t realtime-consumer:$(ENV) src/realtime-consumer/

build-batch-consumer:
	@echo "Building batch consumer image for $(ENV)..."
	docker build -t batch-consumer:$(ENV) src/batch-consumer/

build-consumers: build-realtime-consumer build-batch-consumer

cache:
	@echo "Caching $(ENV) images in Minikube..."
	@$(SCRIPTS_DIR)/cache-img.sh $(ENV)

# Deployment targets
deploy: build cache
	@echo "Deploying $(ENV) environment..."
	cd $(TERRAFORM_DIR) && terraform init -upgrade
	cd $(TERRAFORM_DIR) && terraform apply -var-file="$(TF_VARS_FILE)" -auto-approve

# Wait for system to be ready
wait-for-system:
	@echo "Waiting $(WAIT_TIME) seconds for system to stabilize..."
	@sleep $(WAIT_TIME)
	@echo "Checking if all pods are ready..."
	@until kubectl wait --for=condition=ready pod -l app -n data-platform-$(ENV) --timeout=60s >/dev/null 2>&1; do \
		echo "Waiting for pods to be ready..."; \
		sleep 10; \
	done

# Test targets
test-quick: wait-for-system
	@echo "Running quick health checks for $(ENV)..."
	@$(SCRIPTS_DIR)/generate-test-report.sh $(ENV)
	@echo "Quick test report generated in tests/ directory"

test-full: wait-for-system
	@echo "Running comprehensive end-to-end tests for $(ENV)..."
	@echo "Waiting additional time for batch processing cycles..."
	@sleep 300  # Wait 5 minutes for batch consumer to run
	@$(SCRIPTS_DIR)/generate-test-report.sh $(ENV)
	@echo "Comprehensive test report generated in tests/ directory"

test: test-quick
	@echo "Default test suite completed"

# View test results
view-tests:
	@echo "=== Latest Test Results ==="
	@ls -1t tests/test-results-$(ENV)-*.md 2>/dev/null | head -1 | xargs cat || echo "No test results found for $(ENV)"

view-latest:
	@ls -1t tests/*.md 2>/dev/null | head -1 | xargs cat || echo "No test results found"

# Combined deployment and testing
deploy-and-test: deploy test
	@echo "✅ Deployment and testing completed for $(ENV)!"

deploy-and-test-full: deploy test-full
	@echo "✅ Deployment and comprehensive testing completed for $(ENV)!"

# Destruction and cleanup
destroy:
	@echo "Destroying $(ENV) environment..."
	cd $(TERRAFORM_DIR) && terraform destroy -var-file="$(TF_VARS_FILE)" -auto-approve

clean:
	@echo "Cleaning up $(ENV) deployments..."
	@$(SCRIPTS_DIR)/clean-up.sh $(ENV)

clean-tests:
	@echo "Cleaning up test reports..."
	rm -f tests/test-results-$(ENV)-*.md

clean-all: clean clean-tests
	@echo "Full cleanup completed"

# Monitoring and logs
logs-producer:
	kubectl logs -f -n data-platform-$(ENV) deployment/event-producer

logs-realtime:
	kubectl logs -f -n data-platform-$(ENV) deployment/stream-consumer

logs-batch:
	kubectl logs -f -n data-platform-$(ENV) deployment/batch-consumer

logs-kafka:
	kubectl logs -f -n kafka-$(ENV) -l app.kubernetes.io/name=kafka

logs-postgres:
	kubectl logs -f -n postgresql-$(ENV) -l app.kubernetes.io/name=postgresql

# Status checks
status:
	@echo "=== $(ENV) Environment Status ==="
	kubectl get pods -n data-platform-$(ENV)
	@echo "=== Services ==="
	kubectl get svc -n data-platform-$(ENV)

status-all:
	@echo "=== All Application Pods ==="
	kubectl get pods -n data-platform-$(ENV)
	@echo "=== Kafka Pods ==="
	kubectl get pods -n kafka-$(ENV)
	@echo "=== PostgreSQL Pods ==="
	kubectl get pods -n postgresql-$(ENV)
	@echo "=== Monitoring Pods ==="
	kubectl get pods -n monitoring-$(ENV)

# Environment-specific shortcuts
dev:
	$(MAKE) deploy ENV=dev

prod:
	$(MAKE) deploy ENV=prod

dev-test:
	$(MAKE) deploy-and-test ENV=dev

prod-test:
	$(MAKE) deploy-and-test ENV=prod

# Full pipeline
all: deploy-and-test
	@echo "🎉 Full pipeline completed!"

# CI/CD specific targets
ci-setup:
	@echo "Setting up CI environment..."
	k3d cluster create data-platform-$(ENV) --wait

ci-cleanup:
	@echo "Cleaning up CI environment..."
	k3d cluster delete data-platform-$(ENV) --yes

ci-deploy: build cache deploy
	@echo "CI deployment completed for $(ENV)"

ci-full-pipeline: ci-setup ci-deploy test-full ci-cleanup
	@echo "Full CI pipeline completed for $(ENV)"

# Help target
help:
	@echo "Available targets:"
	@echo "  deploy           - Build and deploy the application"
	@echo "  test             - Run quick health checks"
	@echo "  test-full        - Run comprehensive tests (includes batch processing)"
	@echo "  deploy-and-test  - Deploy and run quick tests"
	@echo "  deploy-and-test-full - Deploy and run comprehensive tests"
	@echo "  status           - Check application status"
	@echo "  status-all       - Check all components status"
	@echo "  view-tests       - View latest test results"
	@echo "  logs-*           - View logs for specific components"
	@echo "  clean            - Clean up deployments"
	@echo "  destroy          - Destroy entire environment"
	@echo "  dev/prod         - Deploy to specific environment"
	@echo "  dev-test/prod-test - Deploy and test specific environment"
	@echo ""
	@echo "Usage examples:"
	@echo "  make deploy-and-test ENV=dev"
	@echo "  make test-full WAIT_TIME=300"
	@echo "  make deploy-and-test-full"