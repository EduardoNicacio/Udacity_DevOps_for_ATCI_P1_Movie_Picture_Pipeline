# GitHub Secrets Required for CD Pipelines

Go to your GitHub repository -> Settings -> Secrets and variables -> Actions -> New repository secret.
Add each secret below.

## AWS Credentials (from github-action-user IAM user)

| Secret Name             | Where to get it                                              |
|-------------------------|--------------------------------------------------------------|
| `AWS_ACCESS_KEY_ID`     | IAM -> Users -> github-action-user -> Security credentials -> Create access key |
| `AWS_SECRET_ACCESS_KEY` | Same page (only shown once — copy immediately)               |
| `AWS_REGION`            | `us-east-1` (or the region Terraform used)                  |

## ECR Repository Names

Run `terraform output` from `setup/terraform/` to get the ECR repo names/URIs.
Store only the **repository name** (the part after the last `/` in the URI).

| Secret Name          | Value                                              |
|----------------------|----------------------------------------------------|
| `ECR_FRONTEND_REPO`  | e.g., `frontend` (from `terraform output`)         |
| `ECR_BACKEND_REPO`   | e.g., `backend` (from `terraform output`)          |

## Kubernetes Cluster

| Secret Name        | Value                                              |
|--------------------|----------------------------------------------------|
| `EKS_CLUSTER_NAME` | `cluster` (the default name used in Terraform)     |

## Backend API URL (set AFTER first successful backend CD run)

| Secret Name                | Value                                                                     |
|----------------------------|---------------------------------------------------------------------------|
| `REACT_APP_MOVIE_API_URL`  | The LoadBalancer URL for the backend service — get it with:              |
|                            | `kubectl get svc -n default` or `kubectl get svc --all-namespaces`       |
|                            | Look for the EXTERNAL-IP of the backend service. Format: `http://<IP>`   |

**Important**: Set a placeholder value (e.g., `http://localhost:5000`) for `REACT_APP_MOVIE_API_URL`
when first deploying. After the backend is running, update it to the real LoadBalancer URL,
then re-run the frontend CD workflow manually via workflow_dispatch.
