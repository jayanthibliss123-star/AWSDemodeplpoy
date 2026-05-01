# Deployment Guide for AWSDemodeplpoy

This guide explains how to build and deploy the AWS Demo application using Docker and Kubernetes.

## Prerequisites

- Docker installed on your machine
- Kubernetes cluster (local or cloud-based)
- kubectl CLI tool
- Docker Hub account (or any container registry)

## Building the Docker Image

### 1. Build the Docker Image

```bash
docker build -t jayanthibliss123-star/awsdemo:latest .
```

### 2. Tag the Image (if using a different registry)

```bash
docker tag jayanthibliss123-star/awsdemo:latest your-registry/awsdemo:latest
```

### 3. Push to Docker Registry

```bash
docker login
docker push jayanthibliss123-star/awsdemo:latest
```

### 4. Test Locally

```bash
docker run -d -p 8080:80 jayanthibliss123-star/awsdemo:latest
# Visit http://localhost:8080 in your browser
```

## Kubernetes Deployment

### 1. Create a Kubernetes Namespace (Optional)

```bash
kubectl create namespace awsdemo
# Then update the namespace in the YAML files from 'default' to 'awsdemo'
```

### 2. Deploy to Kubernetes

```bash
# Apply all configurations
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
kubectl apply -f kubernetes/hpa.yaml
```

### 3. Verify the Deployment

```bash
# Check deployment status
kubectl get deployments
kubectl get pods
kubectl get services

# Get service details
kubectl describe service awsdemo-service

# Watch pods being created
kubectl get pods -w
```

### 4. Access the Application

#### For LoadBalancer Service (AWS/Cloud):
```bash
kubectl get service awsdemo-service
# Find the EXTERNAL-IP and access via browser
```

#### For Local/Minikube:
```bash
minikube service awsdemo-service
```

#### Using Port Forward:
```bash
kubectl port-forward service/awsdemo-service 8080:80
# Visit http://localhost:8080
```

### 5. View Logs

```bash
# View logs from a specific pod
kubectl logs <pod-name>

# Tail logs
kubectl logs -f <pod-name>

# View logs from all pods
kubectl logs -l app=awsdemo --all-containers=true
```

### 6. Monitor HPA (Auto-Scaling)

```bash
# Check HPA status
kubectl get hpa
kubectl describe hpa awsdemo-hpa

# Watch HPA metrics
kubectl get hpa awsdemo-hpa -w
```

### 7. Update Deployment

```bash
# Update image
kubectl set image deployment/awsdemo-deployment awsdemo=jayanthibliss123-star/awsdemo:v1.1

# Rollout status
kubectl rollout status deployment/awsdemo-deployment

# Rollback if needed
kubectl rollout undo deployment/awsdemo-deployment
```

### 8. Scale Manually (if HPA is not active)

```bash
kubectl scale deployment awsdemo-deployment --replicas=5
```

## Cleanup

### Remove Kubernetes Resources

```bash
# Delete specific resources
kubectl delete service awsdemo-service
kubectl delete deployment awsdemo-deployment
kubectl delete hpa awsdemo-hpa

# Delete all at once
kubectl delete -f kubernetes/
```

### Remove Docker Image

```bash
docker rmi jayanthibliss123-star/awsdemo:latest
```

## Troubleshooting

### Image Pull Errors
- Ensure the image exists in your registry
- Check imagePullPolicy in deployment.yaml
- Verify Docker credentials: `docker login`

### Pod Not Starting
- Check pod logs: `kubectl logs <pod-name>`
- Describe pod: `kubectl describe pod <pod-name>`
- Check resource limits

### Service Not Accessible
- Verify service is running: `kubectl get services`
- Check LoadBalancer has an external IP
- Use port-forward to test: `kubectl port-forward service/awsdemo-service 8080:80`

### HPA Not Scaling
- Check metrics-server is installed: `kubectl get deployment metrics-server -n kube-system`
- Verify resource requests/limits are set in deployment
- Check HPA status: `kubectl describe hpa awsdemo-hpa`

## Files Overview

- **Dockerfile**: Builds the Docker image using Nginx to serve static content
- **kubernetes/deployment.yaml**: Kubernetes deployment with 3 replicas, health checks, and resource limits
- **kubernetes/service.yaml**: Exposes the application via a LoadBalancer service
- **kubernetes/hpa.yaml**: Horizontal Pod Autoscaler for automatic scaling based on CPU/Memory metrics
- **.dockerignore**: Excludes unnecessary files from Docker build

## Next Steps

- Configure Ingress for HTTP routing
- Set up SSL/TLS certificates
- Configure persistent storage if needed
- Implement CI/CD pipeline for automated deployments
