# Infrastructure Interview Test Project

This project demonstrates a complete infrastructure setup for a TypeScript Express application using TypeORM. It includes containerization, Kubernetes deployment via Helm, Infrastructure as Code with Terraform, and a CI/CD pipeline.

## Features

Based on the project tasks, the following features have been implemented:

### Core Requirements
- **Containerization**: Application is containerized using Docker and published to a public repository.
- **Kubernetes Deployment**: Full deployment manifests for Kubernetes.
- **External Exposure**: Application exposed via Service/Ingress.
- **High Availability**: configured for HA with replicas across availability zones (simulated).

### Additional Implementations
- **Automation**: Scripts for automating image building and deployment.
- **Reverse Proxy**: Nginx integration for routing.
- **Testing**: Functional and performance test scenarios.
- **Local Development**: Scripts to configure local Kind clusters.
- **Helm Charts**: Application packaged as a Helm chart.
- **Infrastructure as Code**: Local environment provisioning using Terraform.

## Prerequisites

To run this project, you will need the following tools installed:

- [Docker](https://docs.docker.com/get-docker/)
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/) (Kubernetes in Docker)
- [Terraform](https://www.terraform.io/downloads.html)
- [Helm](https://helm.sh/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Node.js](https://nodejs.org/) (for local application development)

## Getting Started

### Scripts & Tools

The `tools/` directory contains utility scripts to facilitate deployment, testing, and environment validation.

### 1. Full Automation Script (`deploy_and_test.sh`)

This is the main script to automatically "spin up the environment". It orchestrates the entire provisioning and testing process.

**What it does:**
1.  **Check Dependencies**: Checks if `terraform`, `kind`, `kubectl`, `k6`, etc., are installed.
2.  **Check Cloud Provider**: Alerts if `cloud-provider-kind` is not running (required for external IP).
3.  **Provision Infrastructure**: Runs Terraform to create/update the cluster and resources.
4.  **Configure Ingress**:
    *   Applies the initial Ingress.
    *   Waits for external IP assignment by the LoadBalancer.
    *   Automatically updates the Ingress host using `nip.io` (e.g., `192.168.x.x.nip.io`) to allow DNS access.
5.  **Run Tests**: Sequentially runs functional and load tests against the newly created environment.

**How to use:**
```bash
./tools/deploy_and_test.sh
```

### 2. Functional Tests (`functional_tests.sh`)

Bash script that performs end-to-end validations on the API using `curl`.

**Tested scenarios:**
*   Create a new Post (POST).
*   List Posts (GET).
*   Get Post by ID (GET).
*   Error validation for non-existent Post (404/200).

**How to use:**
```bash
./tools/functional_tests.sh <API_URL>
# Example: ./tools/functional_tests.sh http://172.18.0.2.nip.io
```

### 3. Load Tests (`load_test.js`)

Script for [k6](https://k6.io/) that simulates traffic on the application to validate performance and stability.

**Scenario:**
*   Ramp-up to 20 simultaneous users.
*   Sustain load for 1 minute.
*   Latency validation (p95 < 500ms) and error rate (< 1%).

**How to use:**
```bash
k6 run -e BASE_URL=<API_URL> tools/load_test.js
```

### Infrastructure Deployment (Local)

The infrastructure is managed using Terraform and targets a local Kind cluster (or Cloud Provider if configured).

1. Navigate to the Terraform directory:
   ```bash
   cd infraestructure/terraform
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Plan the deployment:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

### Kubernetes Deployment via Helm

You can deploy the application manually using the Helm chart located in `infraestructure/charts/typeorm-app`.

```bash
helm install my-app ./infraestructure/charts/typeorm-app
```

To upgrade the installation:
```bash
helm upgrade my-app ./infraestructure/charts/typeorm-app
```

## Testing

The project includes a functional test script to verify endpoints.

```bash
./functional_tests.sh
```

## CI/CD

The project supports CI/CD workflows (defined in `.github/workflows`) for:
- Building and Pushing Docker images.
- Publishing Helm charts.
