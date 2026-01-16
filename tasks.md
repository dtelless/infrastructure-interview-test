# Project Tasks

Based on the project requirements.

## Core Requirements (Mandatory)
- [✅] **Containerization**: Create a container image for the application and publish it to a public repository (DockerHub, Quay, etc).
- [✅] **Kubernetes Deployment**: Write necessary code (manifests) to deploy the image in a Kubernetes cluster.
- [✅] **External Exposure**: Expose the application externally to the Kubernetes cluster (Service/Ingress).
- [✅] **High Availability**: Configure the application for HA, considering worker nodes in 3 different availability zones (e.g., PodAntiAffinity, Replicas).

## Optional Goals
- [❌​] **Private Registry Auth**: Configure Kubernetes to authenticate to a private container registry.
- [✅] **Automation Script**: Create a script for automating image building and deployment.
- [✅] **Reverse Proxy**: Add a reverse proxy (e.g., Nginx) to route requests instead of exposing the main service directly.
- [✅] **Testing**: Write test scenarios (performance, functional, etc.).
- [✅] **Local Cluster Script**: Create a script to configure a local k8s cluster, deploy the app, and run tests.
- [✅] **Multi-node Local Cluster**: Configure the local cluster to have 2+ worker nodes.
- [✅] **Helm Charts**: Use Helm to package and deploy the application.
- [✅] **Infrastructure as Code (Terraform)**:
    - [✅] Configure the local environment.
    - [❌​] Configure a remote environment (Cloud Provider).

## Evaluation Criteria (Best Practices)
Ensure the following are addressed in all implementations:
- [✅] **Code Organization**: Clean structure and separation of concerns.
- [ ] **Documentation**: Clear instructions and comments.
- [✅] **Change History**: Clean git commit history.
- [✅] **Tests**: Implementation of tests.
- [✅] **Release/Deployment**: Robust mechanisms.
- [✅] **Security**: Best practices (non-root user, secrets, etc.).
- [✅] **Performance**: Optimization.
- [✅] **Availability**: Uptime considerations.
- [✅] **Cost**: Resource efficiency.
- [✅] **Industry Best Practices**: General standard conformance.
