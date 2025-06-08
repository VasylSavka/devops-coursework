# DevOps Coursework Project

## 🧭 Overview

This project demonstrates modern DevOps practices for building, deploying, and monitoring a simple Node.js web application hosted on AWS EC2. The infrastructure is managed via Terraform and the CI/CD pipeline is orchestrated using Jenkins.

## ⚙️ Architecture

```
GitHub (Code)
   ↓ (Push)
Jenkins (CI/CD Pipeline)
   ↓
Terraform (Infra as Code)
   ↓
AWS EC2 (Node.js App)
   ↓
Prometheus + Grafana (Monitoring)
   ↓
Microsoft Teams (Notifications)
```

## 🚀 DevOps Practices Implemented

* **Infrastructure as Code**: Terraform is used to provision and manage AWS resources.
* **Continuous Integration / Deployment**: Jenkins automatically runs pipelines on GitHub commits.
* **Automated Notifications**: Teams channels receive updates on apply/destroy actions and build health.
* **Monitoring**: Prometheus and Grafana provide real-time visibility into EC2 and Jenkins metrics.
* **Secrets Management**: AWS credentials and Teams webhook are securely stored in Jenkins credentials.

## 🛠️ Technologies Used

* **Terraform** — AWS EC2 provisioning
* **Jenkins** — CI/CD automation
* **Node.js** — Simple Express app
* **Docker** — Containerization of the app
* **Prometheus & Grafana** — Monitoring and visualization
* **Microsoft Teams** — Alerting via Webhooks
* **AWS EC2 & S3** — Hosting and state backend

## 🧰 Getting Started

### 1. Clone Repository

```bash
git clone https://github.com/VasylSavka/devops-coursework.git
cd devops-coursework/terraform
```

### 2. Configure Backend (S3)

Ensure the S3 backend is configured in `backend.tf`.

```bash
terraform init -reconfigure
```

### 3. Apply Infrastructure

```bash
terraform apply -auto-approve \
  -var="teams_webhook_url=<your_teams_webhook>" \
  -var="action=apply"
```

### 4. Destroy Infrastructure

```bash
terraform destroy -auto-approve \
  -var="teams_webhook_url=<your_teams_webhook>" \
  -var="action=destroy"
```

## 🧪 CI/CD Pipeline

### Trigger:

* Jenkins is configured to poll SCM (GitHub) for changes.

### Stages:

1. **Checkout** — Clones latest commit from GitHub.
2. **Terraform Init & Apply** — Provisions infrastructure.
3. **Docker Build** — Builds Node.js app image.
4. **Deploy Container** — Runs the container on EC2.
5. **Healthcheck** — Validates app is up and running.
6. **Notifications** — Sends status update to Teams.

### Jenkins Notifications

* ✅ Deployment succeeded
* ❌ Build failed or healthcheck failed

## 📣 Teams Notifications

### Apply:

```text
Terraform apply: EC2 instance has been created successfully. Public IP: <ip>:3000
```

### Destroy:

```text
🗑️ Terraform destroy: EC2 instance is being terminated.
```

## 📌 Useful Commands

### Terraform Init After State Deletion

```bash
terraform init -reconfigure
```

### Manual Apply (with variable override)

```bash
terraform apply \
  -var="teams_webhook_url=..." \
  -var="action=apply"
```

### Run Shell Notification

```bash
bash ./notify_apply.sh <ip> <webhook>
bash ./notify_destroy.sh <webhook> "message"
```

---

© 2025 Vasyl Savka
