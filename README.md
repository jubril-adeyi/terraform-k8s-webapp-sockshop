# Deployment of a nginx web-app and the sock-shop app with neccesary dependencies using kubernetes as microservice orchestration tool, and Terraform as IAC tool for the creation of kubernetes (Amazon EKS) Infrastructure and the required resources. Helm chart was also used in creation of resources.
# Using ArgoCD and Github for Continous delivery of the Kubernetes resources and Prometheus and Grafana for monitoring and Visualization of Metrics. 
## Prerequisites
* AWS account
* AWS CLI (configured) 
* Terraform 
* Helm 
* Kubernetes
* Argocd 
* Docker (Dockerizing nginx web-app) 
* Nginx 
## Deployment of Infrastructure 
### The Kubernetes infrastucture (EKS Cluster and nodes) and all neccesary dependencies (VPC and network setup)  were created Using Terraform.  
#### STEPS
* Create 
